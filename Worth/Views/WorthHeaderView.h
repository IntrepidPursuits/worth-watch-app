//
//  WorthHeaderView.h
//  Worth
//
//  Created by Patrick Butkiewicz on 5/8/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WorthHeaderViewAccessoryButtonType) {
    WorthHeaderViewAccessoryButtonTypePlus,
    WorthHeaderViewAccessoryButtonTypeNone,
};

@protocol WorthHeaderViewDelegate;

@interface WorthHeaderView : UIView
@property (nonatomic, weak) id<WorthHeaderViewDelegate>delegate;
- (void)setAccessoryType:(WorthHeaderViewAccessoryButtonType)type;
- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle;
- (void)setImageContainerBackgroundColor:(UIColor *)color;
- (void)setInformationContainerBackgroundColor:(UIColor *)color;
@end

@protocol WorthHeaderViewDelegate <NSObject>
- (void)worthHeaderView:(WorthHeaderView *)view didTapAccessoryButton:(id)button;
@end