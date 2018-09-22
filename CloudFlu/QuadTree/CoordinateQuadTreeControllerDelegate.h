//
//  CoordinateQuadTreeControllerDelegate.h
//  CloudFlu
//
//  Created by Mark Lagae on 9/22/18.
//  Copyright © 2018 Mark Lagae. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CoordinateQuadTreeControllerDelegate <NSObject>
@optional
- (void)quadTreeControllerDidLoadData;
@end
