//
//  NSDate+Worth.h
//  Worth
//
//  Created by Patrick Butkiewicz on 5/8/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Worth)

+ (CFTimeInterval)secondsSinceBeginningOfDayStart;
+ (CFTimeInterval)secondsSinceBeginningOfYearStart;

@end
