//
//  WorthUserView.h
//  Worth
//
//  Created by Patrick Butkiewicz on 3/15/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WorthUser;

typedef NS_ENUM(NSUInteger, WorthUserViewContentMode) {
    WorthUserViewContentModeSelf,
    WorthUserViewContentModeOtherUser,
};

@interface WorthUserView : UIView

@property (nonatomic) WorthUserViewContentMode contentMode;
- (void)configureWithUser:(WorthUser *)user;

@end
