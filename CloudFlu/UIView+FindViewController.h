//
//  UIView+FindViewController.h
//  CloudFlu
//
//  Created by Mark Lagae on 9/23/18.
//  Copyright © 2018 Mark Lagae. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef UIView_FindViewController_h
#define UIView_FindViewController_h

@interface UIView (FindUIViewController)
- (UIViewController *) firstAvailableUIViewController;
- (id) traverseResponderChainForUIViewController;
@end

@implementation UIView (FindUIViewController)
- (UIViewController *) firstAvailableUIViewController {
    // convenience function for casting and to "mask" the recursive function
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id) traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}
@end

#endif /* UIView_FindViewController_h */
