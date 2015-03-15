//
//  WorthAddUserTableViewController.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "WorthAddUserTableViewController.h"
#import "WorthCompareUserTableViewCell.h"

static NSString * kWorthCompareUserTableViewCellIdentifier = @"WorthCompareUserTableViewCell";

@interface WorthAddUserTableViewController ()

@end

@implementation WorthAddUserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationItems];
    [self configureTableView];
}

- (void)configureTableView {
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:kWorthCompareUserTableViewCellIdentifier bundle:nil]
         forCellReuseIdentifier:kWorthCompareUserTableViewCellIdentifier];
}

- (void)configureNavigationItems {
    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonTapped:)];
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = searchBarItem;
}

#pragma mark - Button Event Method

- (void)searchButtonTapped:(id)sender {
    NSLog(@"Search Button Tapped");
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
