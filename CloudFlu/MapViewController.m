//
//  MapViewController.m
//  CloudFlu
//
//  Created by Mark Lagae on 9/22/18.
//  Copyright © 2018 Mark Lagae. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    allIds = @[@1, @2, @3, @4, @7, @10, @14, @15, @16, @18, @22, @24, @30, @31, @32, @33, @34, @46, @48, @50];
    self.coordinateQuadTree = [[CoordinateQuadTree alloc] init];
    self.coordinateQuadTree.delegate = self;
    [self.coordinateQuadTree buildTree: allIds];
    quadTreeLoaded = false;
    self.selectedIds = @[@4];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)quadTreeControllerDidLoadData {
    quadTreeLoaded = true;
    [self reloadMapOverlays];
}

- (void)reloadMapOverlays {
    if (!quadTreeLoaded) { return; }
    [self.mapView removeOverlays:self.mapView.overlays];
    MKMapRect mapRect = self.mapView.visibleMapRect;
    double scale = self.mapView.bounds.size.width / self.mapView.visibleMapRect.size.width;
    NSArray *circles = [self.coordinateQuadTree circlesWithinMapRect:mapRect withZoomScale:scale withIds:self.selectedIds];
    [self updateMapCirclesWithCircles:circles];
}

- (void)updateMapCirclesWithCircles:(NSArray *)circlesArray {
    [self.mapView addOverlays:circlesArray];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[IllnessCircle class]]) {
        MKCircleRenderer *circle = [[MKCircleRenderer alloc] initWithCircle:overlay];
        circle.fillColor = [self createColorForId:[(IllnessCircle *)overlay getId]];
        circle.lineWidth = 3;
        return circle;
    } else {
        return [[MKPolylineRenderer alloc] init];
    }
}

- (UIColor *)createColorForId:(int)illnessId {
    srand(illnessId);
    double h = rand() % 360 / 360.0;
    return [UIColor colorWithHue:h saturation:1.0 brightness:1.0 alpha:0.5];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self reloadMapOverlays];
}

- (IBAction)unwindToMap:(UIStoryboardSegue*)segue {
    FilterViewController* sourceVC = [segue sourceViewController];
    self.selectedIds = [[sourceVC selectedIllnessIds] copy];
    [self reloadMapOverlays];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"toFilter"]) {
        UINavigationController *nav = [segue destinationViewController];
        FilterViewController* destVC = [nav viewControllers][0];
        [destVC setSelectedIllnessIds:self.selectedIds];
    }
}

@end
