//
//  WorthUser+UserGenerated.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/15/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "WorthUser+UserGenerated.h"

static NSInteger kSecondsPerYear = (364 * 24 * 60 * 60);

@implementation WorthUser (UserGenerated)

+ (NSString *)entityName {
    return @"User";
}

- (UIImage *)avatarImage {
    return [UIImage imageWithData:self.avatar];
}

- (float)salaryPerSecond {
    return ([self.salary floatValue] / (float)kSecondsPerYear);
}

@end
