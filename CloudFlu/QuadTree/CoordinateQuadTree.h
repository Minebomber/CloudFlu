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
#import "IllnessCircle.h"

@interface CoordinateQuadTree : NSObject

@property (nonatomic, weak) id <CoordinateQuadTreeControllerDelegate> delegate;
@property (assign, nonatomic) QuadTreeNode *root;

- (void)buildTree:(NSArray *)ids;
- (NSArray *)circlesWithinMapRect:(MKMapRect)rect withZoomScale:(double)zoomScale withIds:(NSArray *)ids;

@end
