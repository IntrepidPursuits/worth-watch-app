//
//  WorthUserManager.h
//  Worth
//
//  Created by Patrick Butkiewicz on 3/15/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WorthUser;

@interface WorthUserManager : NSObject

+ (instancetype)sharedManager;
- (WorthUser *)currentUser;
- (void)favoriteUser:(WorthUser *)user;
- (void)setupSimpleDatabase;

@end
