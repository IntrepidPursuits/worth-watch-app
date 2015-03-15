//
//  NSString+TimeString.h
//  Worth
//
//  Created by Patrick Butkiewicz on 3/15/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TimeString)

+ (NSString *)timeStringFromSecond:(NSInteger)totalSeconds;

@end
