//
//  CoordinateQuadTree.h
//  CloudFlu
//
//  Created by Mark Lagae on 9/22/18.
//  Copyright © 2018 Mark Lagae. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "QuadTree.h"
#import "CoordinateQuadTreeControllerDelegate.h"

@interface CoordinateQuadTree : NSObject

@property (nonatomic, weak) id <CoordinateQuadTreeControllerDelegate> delegate;
@property (assign, nonatomic) QuadTreeNode *root;
@property (assign, nonatomic) MKMapView *mapView;

- (void)buildTree:(NSArray *)ids;
- (NSArray *)annotationsWithinMapRect:(MKMapRect)rect withZoomScale:(double)zoomScale;

@end
