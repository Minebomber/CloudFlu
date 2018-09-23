//
//  FilterTableViewCell.h
//  CloudFlu
//
//  Created by Mark Lagae on 9/23/18.
//  Copyright © 2018 Mark Lagae. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UIView+FindViewController.h"

@interface FilterTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *illnessLabel;
@property (strong, nonatomic) NSNumber *illnessId;

@end
