//
//  WorthTextField.m
//  Worth
//
//  Created by Patrick Butkiewicz on 5/22/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "WorthTextField.h"
#import "UIColor+WorthStyle.h"
#import "UIFont+WorthStyle.h"

@implementation WorthTextField

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setBackgroundColor:[UIColor worth_blumineColor]];
    [self setFont:[UIFont worth_boldFontWithSize:17.0f]];
    [self setTextColor:[UIColor whiteColor]];
}

- (CGRect)rectForTextWithinBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 0);
}

#pragma mark - Overridden methods

- (CGRect)textRectForBounds:(CGRect)bounds {
    return [self rectForTextWithinBounds:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self rectForTextWithinBounds:bounds];
}

@end
