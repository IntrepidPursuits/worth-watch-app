//
//  UIColor+WorthStyle.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "UIColor+WorthStyle.h"

@implementation UIColor (WorthStyle)

+ (UIColor *)worth_lightGreenColor; {
    return [UIColor colorWithRed:(78.0f/255.0f) green:(168.0f/255.0f) blue:(169.0f/255.0f) alpha:1.0f];
}

+ (UIColor *)worth_greenColor; {
    return [UIColor colorWithRed:(67.0f/255.0f) green:(142.0f/255.0f) blue:(141.0f/255.0f) alpha:1.0f];
}

+ (UIColor *)worth_darkGreenColor {
    return [UIColor colorWithRed:(40.0f/255.0f) green:(85.0f/255.0f) blue:(86.0f/255.0f) alpha:1.0f];
}

+ (UIColor *)worth_darkerGreenColor {
    return [UIColor colorWithRed:(19.0f/255.0f) green:(62.0f/255.0f) blue:(69.0f/255.0f) alpha:1.0f];
}

+ (UIColor *)worth_darkestGreenColor {
    return [UIColor colorWithRed:(15.0f/255.0f) green:(43.0f/255.0f) blue:(47.0f/255.0f) alpha:1.0f];
}

@end