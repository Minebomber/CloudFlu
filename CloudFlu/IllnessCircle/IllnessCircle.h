//
//  IllnessCircle.h
//  CloudFlu
//
//  Created by Mark Lagae on 9/22/18.
//  Copyright © 2018 Mark Lagae. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface IllnessCircle : MKCircle {
    int illnessId;
}

- (void)setId:(int)newId;

- (int)getId;

@end
