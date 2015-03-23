//
//  NSString+TimeString.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/15/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NSString+TimeString.h"

@implementation NSString (TimeString)

+ (NSString *)timeStringFromSecond:(NSInteger)totalSeconds {
    NSUInteger seconds = totalSeconds % 60;
    NSUInteger minutes = (totalSeconds / 60) % 60;
    NSUInteger hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours, (long)minutes, (long)seconds];
}

@end
