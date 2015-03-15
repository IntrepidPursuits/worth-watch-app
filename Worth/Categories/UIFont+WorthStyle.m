//
//  UIFont+WorthStyle.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "UIFont+WorthStyle.h"

static NSString * kWorthRegularFont = @"DINRoundPro";
static NSString * kWorthMediumFont = @"DINRoundPro-Medium";
static NSString * kWorthLightFont = @"DINRoundPro-Light";
static NSString * kWorthBoldFont = @"DINRoundPro-Bold";
static NSString * kWorthBlackFont = @"DINRoundPro-Black";

@implementation UIFont (WorthStyle)

+ (UIFont *)worth_mediumFontWithSize:(CGFloat)textSize {
    return [UIFont fontWithName:kWorthMediumFont size:textSize];
}

+ (UIFont *)worth_blackFontWithSize:(CGFloat)textSize {
    return [UIFont fontWithName:kWorthBlackFont size:textSize];
}

+ (UIFont *)worth_boldFontWithSize:(CGFloat)textSize {
    return [UIFont fontWithName:kWorthBoldFont size:textSize];
}

+ (UIFont *)worth_lightFontWithSize:(CGFloat)textSize {
    return [UIFont fontWithName:kWorthLightFont size:textSize];
}

+ (UIFont *)worth_regularFontWithSize:(CGFloat)textSize {
    return [UIFont fontWithName:kWorthRegularFont size:textSize];
}

@end
