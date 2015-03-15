//
//  WorthFavoritesTableViewController.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/15/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "WorthFavoritesTableViewController.h"
#import "WorthCompareUserTableViewCell.h"
#import "WorthCompareViewController.h"
#import "UIColor+WorthStyle.h"

static NSString * const kWorthCompareUserTableViewCellIdentifier = @"WorthCompareUserTableViewCell";

@interface WorthFavoritesTableViewController ()

@end

@implementation WorthFavoritesTableViewController

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
    NSLog(@"Search");
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"kCompareSegue" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WorthCompareUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWorthCompareUserTableViewCellIdentifier
                                                                          forIndexPath:indexPath];
    WorthCompareUserTableCellContentMode contentMode = (indexPath.row == 0) ? WorthCompareUserTableCellContentModeSelf : WorthCompareUserTableCellContentModeOtherUser;
    [cell setContentMode:contentMode];
    
    CGFloat randomSalary = ((arc4random() % 3000000) + 250000);
    [cell setSalary:@(randomSalary)];
    
    return cell;
}

@end
