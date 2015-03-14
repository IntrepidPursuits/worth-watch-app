//
//  UIFont+WorthStyle.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "UIFont+WorthStyle.h"

static NSString * kWorthSubTextFont = @"HelveticaNeue";
static NSString * kWorthBodyTextFont = @"HelveticaNeue-Light";
static NSString * kWorthBoldBodyTextFont = @"HelveticaNeue-Bold";

@implementation UIFont (WorthStyle)

+ (UIFont *)worth_boldBodyTextFontWithSize:(CGFloat)textSize {
    return [UIFont fontWithName:kWorthBoldBodyTextFont size:textSize];
}

+ (UIFont *)worth_bodyTextFontWithSize:(CGFloat)textSize {
    return [UIFont fontWithName:kWorthBodyTextFont size:textSize];
}

+ (UIFont *)worth_subTextFontWithSize:(CGFloat)textSize {
    return [UIFont fontWithName:kWorthSubTextFont size:textSize];
}


@end
