//
//  AppDelegate.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/13/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "AppDelegate.h"
#import "WorthObjectModel.h"
#import "WorthUserManager.h"
#import "WorthRootTabBarViewController.h"
#import "UIColor+WorthStyle.h"
#import "UIFont+WorthStyle.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self customizeAppearance];
    [self setupSimpleDatabase];
    
    self.rootViewController = [[WorthRootTabBarViewController alloc] initWithNibName:nil bundle:nil];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.rootViewController];
    self.window.rootViewController = navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - Appearance 

- (void)customizeAppearance {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [navigationBarAppearance setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setBarTintColor:[UIColor worth_TitleBarColor]];
    [navigationBarAppearance setShadowImage:[UIImage new]];
    [navigationBarAppearance setTintColor:[UIColor whiteColor]];
    [navigationBarAppearance setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                      NSFontAttributeName: [UIFont worth_boldFontWithSize:18.0f]}];
    [navigationBarAppearance setTranslucent:NO];
    
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
    
}

- (void)setupSimpleDatabase {
    static NSString * kUserDefaultsHasSetupDatabaseKey = @"kUserDefaultsHasSetupDatabaseKey";
    NSNumber *hasSetupDatabase = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsHasSetupDatabaseKey];
    if ([hasSetupDatabase boolValue] == NO) {
        [[WorthUserManager sharedManager] setupSimpleDatabase];
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:kUserDefaultsHasSetupDatabaseKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
