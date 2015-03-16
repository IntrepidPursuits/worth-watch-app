//
//  WorthMoneyTextView.h
//  Worth
//
//  Created by Patrick Butkiewicz on 3/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WorthMoneyTextViewAlignment) {
    WorthMoneyTextViewAlignmentNone,
    WorthMoneyTextViewAlignmentRight,
    WorthMoneyTextViewAlignmentLeft,
};

@interface WorthMoneyTextView : UIView

@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSString *inputAccessoryText;
@property (nonatomic, assign) WorthMoneyTextViewAlignment inputAlignment;
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@property (nonatomic, strong) NSString *subtitleText;

- (void)animateIntoView:(BOOL)animated;
- (void)setEditing:(BOOL)editing;

@end
