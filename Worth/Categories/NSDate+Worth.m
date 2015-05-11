//
//  NSDate+Worth.m
//  Worth
//
//  Created by Patrick Butkiewicz on 5/8/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NSDate+Worth.h"
#import <NSDate-Escort/NSDate+Escort.h>

@implementation NSDate (Worth)

+ (CFTimeInterval)secondsSinceBeginningOfDayStart {
    NSDate *startDate = [NSDate date];
    NSDate *beginningOfDayDate = [startDate dateAtStartOfDay];
    double secondsSinceBeginningOfDayStart = [startDate timeIntervalSinceDate:beginningOfDayDate];
    return secondsSinceBeginningOfDayStart;
}

+ (CFTimeInterval)secondsSinceBeginningOfYearStart {
    NSDate *startDate = [NSDate date];
    NSDate *beginningOfYearDate = [startDate dateAtStartOfYear];
    double secondsSinceBeginningOfYearStart = [startDate timeIntervalSinceDate:beginningOfYearDate];
    return secondsSinceBeginningOfYearStart;
}

@end
