//
//  FilterViewController.m
//  CloudFlu
//
//  Created by Mark Lagae on 9/23/18.
//  Copyright © 2018 Mark Lagae. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _illnessNames = [NSArray arrayWithObjects:@"Norovirus", @"Bronchitis", @"Common Cold", @"Croup", @"Flu", @"Strep Throat", @"Chicken Pox", @"Pneumonia", @"Food Poisoning", @"Fifth Disease", @"RSV", @"Hand Foot & Mouth", @"Mosquitoes", @"Allergies", @"Head Lice", @"Ticks", @"Pink Eye", @"Stomach Virus", @"Asthma", @"Whooping Cough", nil];
    _illnessIds = [NSArray arrayWithObjects:@(32), @(1), @(2), @(3), @(4), @(33), @(10), @(7), @(34), @(14), @(15), @(16), @(50), @(18), @(48), @(46), @(22), @(24), @(30), @(31), nil];
    _selectedIndexes = [[NSMutableArray alloc] init];
    if (_selectedIllnessIds != NULL) {
        NSLog(@"NOT NULL");
        _selectedIndexes = [[self selectedIdsFromIllnessIds] mutableCopy];
    } else {
        _selectedIllnessIds = [[NSArray alloc] init];
    }
    self.tableView.allowsSelection = YES;
    self.tableView.allowsMultipleSelection = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (UIColor *)createColorForId:(int)illnessId {
    srand(illnessId*illnessId*illnessId + illnessId);
    double h = rand() % 360 / 360.0;
    return [UIColor colorWithHue:h saturation:1.0 brightness:1.0 alpha:1.0];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FilterTableViewCell *tableCell = (FilterTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"illness_filter_cell" forIndexPath:indexPath];
    [tableCell.illnessLabel setText:[_illnessNames objectAtIndex:indexPath.row]];
    [tableCell.colorView setBackgroundColor:[self createColorForId:[[_illnessIds objectAtIndex:indexPath.row] intValue]]];
    tableCell.illnessId = @([[_illnessIds objectAtIndex:indexPath.row] intValue]);
    tableCell.colorView.layer.cornerRadius = tableCell.colorView.bounds.size.width / 2.0;
    tableCell.colorView.clipsToBounds = YES;
    if ([_selectedIndexes containsObject:@(indexPath.row)]) {
        tableCell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        tableCell.accessoryType = UITableViewCellAccessoryNone;
    }
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![_selectedIndexes containsObject:@(indexPath.row)]) {
        [_selectedIndexes addObject:@(indexPath.row)];
    } else {
        [_selectedIndexes removeObject:@(indexPath.row)];
    }
    _selectedIllnessIds = [self illnessIdsFromSelected];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView reloadData];
}

- (NSArray *)illnessIdsFromSelected {
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (int i = 0; i < _selectedIndexes.count; i++) {
        int selectedIndex = [[_selectedIndexes objectAtIndex:i] intValue];
        int selectedIllnessId = [[_illnessIds objectAtIndex:selectedIndex] intValue];
        [temp addObject:@(selectedIllnessId)];
    }
    return [temp copy];
}

- (NSArray *)selectedIdsFromIllnessIds {
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (int i = 0; i < _selectedIllnessIds.count; i++) {
        int illnessId = [[_selectedIllnessIds objectAtIndex:i] intValue];
        int selectedIndex = (int)[_illnessIds indexOfObject:@(illnessId)];
        [temp addObject:@(selectedIndex)];
    }
    return [temp copy];
}

- (IBAction)doneClicked:(id)sender {
    [self performSegueWithIdentifier:@"unwindToMap" sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
