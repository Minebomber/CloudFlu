//
//  FilterTableViewCell.m
//  CloudFlu
//
//  Created by Mark Lagae on 9/23/18.
//  Copyright © 2018 Mark Lagae. All rights reserved.
//

#import "FilterTableViewCell.h"

@implementation FilterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)infoButtonPressed:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *illnessInfo = [appDelegate illnessInfo];
    int intId = [[self illnessId] intValue];
    NSDictionary *currentInfo;
    for (NSDictionary *dict in illnessInfo) {
        int testId = [[dict objectForKey:@"id"] intValue];
        if (testId == intId) {
            currentInfo = dict;
        }
    }
    
    NSString *illnessName = [currentInfo objectForKey:@"name"];
    NSString *description = [currentInfo objectForKey:@"definition"];
    UIAlertController *infoController = [UIAlertController alertControllerWithTitle:illnessName message:description preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil];
    [infoController addAction:done];
    UIViewController *firstVC = [self firstAvailableUIViewController];
    [firstVC presentViewController:infoController animated:YES completion:nil];
}

@end
