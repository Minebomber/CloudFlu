//
//  CoordinateQuadTree.m
//  CloudFlu
//
//  Created by Mark Lagae on 9/22/18.
//  Copyright © 2018 Mark Lagae. All rights reserved.
//

#import "CoordinateQuadTree.h"

typedef struct IllnessInfo {
    int idNumber;
    double h; // Hue for HSB color
} IllnessInfo;

BoundingBox BoundingBoxForMapRect(MKMapRect mapRect) {
    CLLocationCoordinate2D topLeft = MKCoordinateForMapPoint(mapRect.origin);
    CLLocationCoordinate2D botRight = MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMaxX(mapRect), MKMapRectGetMaxY(mapRect)));
    
    CLLocationDegrees minLat = botRight.latitude;
    CLLocationDegrees maxLat = topLeft.latitude;
    
    CLLocationDegrees minLon = topLeft.longitude;
    CLLocationDegrees maxLon = botRight.longitude;
    
    return BoundingBoxMake(minLat, minLon, maxLat, maxLon);
}

MKMapRect MapRectForBoundingBox(BoundingBox boundingBox) {
    MKMapPoint topLeft = MKMapPointForCoordinate(CLLocationCoordinate2DMake(boundingBox.x0, boundingBox.y0));
    MKMapPoint botRight = MKMapPointForCoordinate(CLLocationCoordinate2DMake(boundingBox.xf, boundingBox.yf));
    
    return MKMapRectMake(topLeft.x, botRight.y, fabs(botRight.x - topLeft.x), fabs(botRight.y - topLeft.y));
}

NSInteger ZoomScaleToZoomLevel(MKZoomScale scale) {
    double totalTilesAtMaxZoom = MKMapSizeWorld.width / 256.0;
    NSInteger zoomLevelAtMaxZoom = log2(totalTilesAtMaxZoom);
    NSInteger zoomLevel = MAX(0, zoomLevelAtMaxZoom + floor(log2f(scale) + 0.5));
    
    return zoomLevel;
}

float CellSizeForZoomScale(MKZoomScale zoomScale) {
    NSInteger zoomLevel = ZoomScaleToZoomLevel(zoomScale);
    
    switch (zoomLevel) {
        case 13:
        case 14:
        case 15:
            return 64;
        case 16:
        case 17:
        case 18:
            return 32;
        case 19:
            return 16;
            
        default:
            return 88;
    }
}

QuadTreeNodeData DataFromIllness(NSDictionary *illness) {
    double lat = [[illness objectForKey:@"lat"] doubleValue];
    double lon = [[illness objectForKey:@"lon"] doubleValue];
    
    int idNumber = [[illness objectForKey:@"illness"] intValue];
    
    IllnessInfo *illnessInfo = malloc(sizeof(IllnessInfo));
    illnessInfo->idNumber = idNumber;
    
    return QuadTreeNodeDataMake(lat, lon, illnessInfo);
}

@implementation CoordinateQuadTree

- (void)buildTree:(NSArray *)ids {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Enumerate through the ids, load each json
        NSMutableArray *illnessArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [ids count]; i++) {
            int illnessId = [[ids objectAtIndex:i] intValue];
            NSLog(@"Loading %d.json", illnessId);
            NSString *idString = [NSString stringWithFormat:@"%d", illnessId];
            NSString *jsonPath = [[NSBundle mainBundle] pathForResource:idString ofType:@"json"];
            NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
            NSAssert(jsonData != nil, @"Reading data from file failed");
            NSError *parseError = nil;
            NSArray *illnessData = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&parseError];
            NSAssert(parseError == nil, @"Error parsing JSON data");
            [illnessArray addObjectsFromArray:illnessData];
            NSLog(@"[COORD TREE] Finished loading %d.json", illnessId);
        }
        
        NSInteger count = [illnessArray count];
        
        QuadTreeNodeData *dataArray = malloc(sizeof(QuadTreeNodeData) * count);
        for (NSInteger i = 0; i < count; i++) {
            dataArray[i] = DataFromIllness([illnessArray objectAtIndex:i]);
        }
        
        BoundingBox world = BoundingBoxMake(19, -166, 72, -53);
        self->_root = QuadTreeBuildWithData(dataArray, (int)count, world, 4);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_delegate quadTreeControllerDidLoadData];
        });
    });
}

- (NSArray *)circlesWithinMapRect:(MKMapRect)rect withZoomScale:(double)zoomScale withIds:(NSArray *)ids {
    double cellSize = CellSizeForZoomScale(zoomScale);
    double scaleFactor = zoomScale / cellSize;
    NSInteger minX = floor(MKMapRectGetMinX(rect) * scaleFactor);
    NSInteger maxX = floor(MKMapRectGetMaxX(rect) * scaleFactor);
    NSInteger minY = floor(MKMapRectGetMinY(rect) * scaleFactor);
    NSInteger maxY = floor(MKMapRectGetMaxY(rect) * scaleFactor);
    
    NSMutableArray *circles = [[NSMutableArray alloc] init];
    
    int maxId = [[ids valueForKeyPath:@"@max.intValue"] intValue];
    
    NSMutableArray *idCounts = [NSMutableArray array];
    for (int i = 0; i < maxId + 1; i++) {
        [idCounts addObject:@(0)];
    }
    
    for (NSInteger x = minX; x <= maxX; x++) {
        for (NSInteger y = minY; y <= maxY; y++) {
            MKMapRect mapRect = MKMapRectMake(x / scaleFactor, y / scaleFactor, 1.0 / scaleFactor, 1.0 / scaleFactor);
            
            QuadTreeGatherDataInRange(self.root, BoundingBoxForMapRect(mapRect), ^(QuadTreeNodeData data) {
                IllnessInfo *currentIllnessInfo = (IllnessInfo *)data.data;
                int currentId = currentIllnessInfo->idNumber;
                if (![ids containsObject:@(currentId)]) { return; }
                [idCounts replaceObjectAtIndex:currentId withObject:@([[idCounts objectAtIndex:currentId] intValue] + 1)];
                if ([[idCounts objectAtIndex:currentId] intValue] >= 1000 / ids.count) { return; }
                CLLocationCoordinate2D center = CLLocationCoordinate2DMake(data.x, data.y);
                IllnessCircle *illnessCircle = [IllnessCircle circleWithCenterCoordinate:center radius:5000];
                [illnessCircle setId:currentIllnessInfo->idNumber];
                [circles addObject:illnessCircle];
            });
        }
    }
    return [circles copy];
}


@end
