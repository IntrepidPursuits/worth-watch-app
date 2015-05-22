//
//  WorthEditUserViewController.h
//  Worth
//
//  Created by Patrick Butkiewicz on 5/22/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WorthUser;

@interface WorthEditUserViewController : UIViewController

- (void)configureWithUser:(WorthUser *)user;

@end
