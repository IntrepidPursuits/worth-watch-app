//
//  WorthCompareUserTableViewCell.h
//  Worth
//
//  Created by Patrick Butkiewicz on 3/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WorthCompareUserTableCellContentMode) {
    WorthCompareUserTableCellContentModeSelf,
    WorthCompareUserTableCellContentModeOtherUser,
};

@class WorthUser;

@interface WorthCompareUserTableViewCell : UITableViewCell

@property (nonatomic) WorthCompareUserTableCellContentMode contentMode;
- (void)configureWithUser:(WorthUser *)user;

@end
