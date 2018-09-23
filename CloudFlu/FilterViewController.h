//
//  FilterViewController.h
//  CloudFlu
//
//  Created by Mark Lagae on 9/23/18.
//  Copyright © 2018 Mark Lagae. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterTableViewCell.h"

@interface FilterViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *illnessNames;
@property (nonatomic, strong) NSArray *illnessIds;
@property (nonatomic, strong) NSMutableArray *selectedIndexes;
@property (nonatomic, strong) NSArray *selectedIllnessIds;

@end
