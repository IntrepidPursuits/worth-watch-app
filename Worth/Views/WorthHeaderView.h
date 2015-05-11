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

@interface WorthHeaderView : UIView

- (void)setAccessoryType:(WorthHeaderViewAccessoryButtonType)type;
- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle;
- (void)setImageContainerBackgroundColor:(UIColor *)color;
- (void)setInformationContainerBackgroundColor:(UIColor *)color;

@end
