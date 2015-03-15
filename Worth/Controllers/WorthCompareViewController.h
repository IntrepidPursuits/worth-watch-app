//
//  WorthCompareViewController.h
//  Worth
//
//  Created by Patrick Butkiewicz on 3/15/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorthUser.h"

@interface WorthCompareViewController : UIViewController

@property (strong, nonatomic) WorthUser *user;
@property (strong, nonatomic) WorthUser *comparedToUser;

@end
