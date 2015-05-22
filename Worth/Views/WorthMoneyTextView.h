//
//  WorthMoneyTextView.h
//  Worth
//
//  Created by Patrick Butkiewicz on 3/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WorthMoneyTextViewContentType) {
    WorthMoneyTextViewContentTypeMinute,
    WorthMoneyTextViewContentTypeHourly,
    WorthMoneyTextViewContentTypeDaily,
    WorthMoneyTextViewContentTypeMonthly,
    WorthMoneyTextViewContentTypeYearly,
    WorthMoneyTextViewContentTypeTimed,
    WorthMoneyTextViewContentTypeCustom,
};

typedef NS_ENUM(NSUInteger, WorthMoneyTextViewContentMode) {
    WorthMoneyTextViewContentModeSpent,
    WorthMoneyTextViewContentModeEarned,
};

@interface WorthMoneyTextView : UIView

@property (nonatomic) WorthMoneyTextViewContentMode contentMode;
@property (nonatomic) WorthMoneyTextViewContentType contentType;
@property (nonatomic) CGFloat dollarsPerSecond;
@property (nonatomic, strong) NSString *inputAccessoryText;
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@property (nonatomic, strong) NSNumber *startAmount;
@property (nonatomic, strong) NSString *subtitleText;

- (void)animateIntoViewWithProgress:(CGFloat)progress animated:(BOOL)animated;
- (void)start;
- (void)startWithTime:(CFTimeInterval)time;

@end
