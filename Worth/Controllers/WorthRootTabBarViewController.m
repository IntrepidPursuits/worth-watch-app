//
//  WorthRootTabBarViewController.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "WorthRootTabBarViewController.h"

static NSString *kWorthNavigationBarTitleHome = @"WORTH";
static NSString *kWorthNavigationBarTitleCompare = @"ADD";

@interface WorthRootTabBarViewController ()

@end

@implementation WorthRootTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"WORTH";
    [self configureTabBar];
}

- (void)configureTabBar {
//    [self.tabBar setItems:@[@"Self", @"Compare"]];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    self.title = ([self.tabBar.items indexOfObject:item] == 0) ? kWorthNavigationBarTitleHome : kWorthNavigationBarTitleCompare;
}

@end
