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
@protocol WorthCompareUserTableViewDelegate;

@interface WorthCompareUserTableViewCell : UITableViewCell

@property (nonatomic) WorthCompareUserTableCellContentMode contentMode;
@property (nonatomic, weak) id<WorthCompareUserTableViewDelegate> delegate;
- (void)configureWithUser:(WorthUser *)user;
+ (CGFloat)preferredHeight;

@end

@protocol WorthCompareUserTableViewDelegate <NSObject>

- (void)compareUserTableViewCell:(WorthCompareUserTableViewCell *)cell didTapFavoriteButton:(id)button;

@end
