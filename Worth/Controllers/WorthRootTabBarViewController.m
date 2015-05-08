//
//  WorthRootTabBarViewController.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "WorthRootTabBarViewController.h"

#import "WorthUserHomeViewController.h"
#import "WorthFavoritesViewController.h"

static NSString *kWorthNavigationBarTitleHome = @"WORTH";
static NSString *kWorthNavigationBarTitleCompare = @"ADD";

@interface WorthRootTabBarViewController ()

@property (nonatomic, strong) WorthUserHomeViewController *homeViewController;
@property (nonatomic, strong) WorthFavoritesViewController *favoritesViewController;

@end

@implementation WorthRootTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kWorthNavigationBarTitleHome;
    [self configureViewControllers];
    [self configureTabBar];
}

- (void)configureTabBar {
    UITabBarItem *homeItem = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *compareItem = [self.tabBar.items objectAtIndex:1];
    
    [homeItem setImage:[UIImage imageNamed:@"Timer"]];
    [homeItem setSelectedImage:[[UIImage imageNamed:@"Timer"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [compareItem setImage:[UIImage imageNamed:@"Compare"]];
    [compareItem setSelectedImage:[[UIImage imageNamed:@"Compare"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

- (void)configureViewControllers {
    [self setViewControllers:@[self.homeViewController, self.favoritesViewController]];
    [self setSelectedIndex:0];
}

#pragma mark - TabBarDelegate Methods

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    self.title = ([self.tabBar.items indexOfObject:item] == 0) ? kWorthNavigationBarTitleHome : kWorthNavigationBarTitleCompare;
}

#pragma mark - Lazy

- (WorthUserHomeViewController *)homeViewController {
    if (_homeViewController == nil) {
        _homeViewController = [WorthUserHomeViewController new];
    }
    return _homeViewController;
}

- (WorthFavoritesViewController *)favoritesViewController {
    if (_favoritesViewController == nil) {
        _favoritesViewController = [WorthFavoritesViewController new];
    }
    return _favoritesViewController;
}

@end
