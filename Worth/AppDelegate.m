//
//  AppDelegate.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/13/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "AppDelegate.h"
#import "UIColor+WorthStyle.h"
#import "UIFont+WorthStyle.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self customizeAppearance];
    return YES;
}

#pragma mark - Appearance 

- (void)customizeAppearance {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [navigationBarAppearance setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setBarTintColor:[UIColor worth_darkGreenColor]];
    [navigationBarAppearance setShadowImage:[UIImage new]];
    [navigationBarAppearance setTintColor:[UIColor whiteColor]];
    [navigationBarAppearance setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                      NSFontAttributeName: [UIFont worth_boldFontWithSize:18.0f]}];
    
    UIBarButtonItem *barButtonItemAppearance = [UIBarButtonItem appearance];
    [barButtonItemAppearance setTitleTextAttributes:@{NSFontAttributeName: [UIFont worth_lightFontWithSize:16.0f]} forState:UIControlStateNormal];
    
    UITabBar *tabBarAppearance = [UITabBar appearance];
    [tabBarAppearance setBackgroundColor:[UIColor worth_darkestGreenColor]];
    [tabBarAppearance setBarTintColor:[UIColor worth_darkestGreenColor]];
    [tabBarAppearance setTintColor:[UIColor whiteColor]];
    [tabBarAppearance setShadowImage:nil];
    
    UITabBarItem *tabBarItemAppearance = [UITabBarItem appearance];
    [tabBarItemAppearance setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
    [tabBarItemAppearance setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
    
//    UIImage *backButtonImage = [UIImage imageNamed:@"icon_back_arrow"];
//    [barButtonItemAppearance setBackButtonBackgroundImage:[backButtonImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, backButtonImage.size.width, 0, 0)]
//                                                 forState:UIControlStateNormal
//                                               barMetrics:UIBarMetricsDefault];
}

@end
