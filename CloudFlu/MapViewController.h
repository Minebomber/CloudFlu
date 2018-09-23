//
//  MapViewController.h
//  CloudFlu
//
//  Created by Mark Lagae on 9/22/18.
//  Copyright © 2018 Mark Lagae. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CoordinateQuadTree.h"
#import "FilterViewController.h"

@interface MapViewController : UIViewController<CoordinateQuadTreeControllerDelegate, MKMapViewDelegate> {
    NSArray *allIds;
    bool quadTreeLoaded;
}

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) CoordinateQuadTree *coordinateQuadTree;
@property (nonatomic, strong) NSArray *selectedIds;

- (UIColor *)createColorForId:(int)illnessId;
- (void)updateMapCirclesWithCircles:(NSArray *)circlesArray;
- (void)reloadMapOverlays;
@end
