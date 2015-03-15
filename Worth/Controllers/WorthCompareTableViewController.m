//
//  WorthCompareTableViewController.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "WorthCompareTableViewController.h"
#import "WorthCompareUserTableViewCell.h"
#import "UIColor+WorthStyle.h"

static NSString * const kWorthCompareUserTableViewCellIdentifier = @"WorthCompareUserTableViewCell";

@interface WorthCompareTableViewController ()

@end

@implementation WorthCompareTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    [self configureTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self configureNavigationItems];
}

- (void)configureView {
    [self.view setBackgroundColor:[UIColor worth_greenColor]];
}

- (void)configureTableView {
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:kWorthCompareUserTableViewCellIdentifier bundle:nil]
         forCellReuseIdentifier:kWorthCompareUserTableViewCellIdentifier];
}

- (void)configureNavigationItems {
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                       target:self
                                                                                       action:@selector(didTapAddButton:)];
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = addBarButtonItem;
}

#pragma mark - Button Event Methods

- (void)didTapAddButton:(id)sender {
    NSLog(@"Add Button Tapped");
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WorthCompareUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWorthCompareUserTableViewCellIdentifier
                                                            forIndexPath:indexPath];
    WorthCompareUserTableCellContentMode contentMode = (indexPath.row == 0) ? WorthCompareUserTableCellContentModeSelf : WorthCompareUserTableCellContentModeOtherUser;
    [cell setContentMode:contentMode];
    return cell;
}

@end
