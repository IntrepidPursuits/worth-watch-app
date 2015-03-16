//
//  NSString+StripCurrencySymbols.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/16/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "NSString+StripCurrencySymbols.h"

@implementation NSString (StripCurrencySymbols)

- (NSString *)stringByStrippingCurrencySymbols {
    static NSNumberFormatter *numberFormatter;
    if (numberFormatter == nil) {
        numberFormatter = [NSNumberFormatter new];
    }
    NSString *tempNewString;
    tempNewString = [self stringByReplacingOccurrencesOfString:numberFormatter.currencySymbol withString:@""];
    tempNewString = [tempNewString stringByReplacingOccurrencesOfString:numberFormatter.groupingSeparator withString:@""];
    tempNewString = [tempNewString stringByReplacingOccurrencesOfString:numberFormatter.decimalSeparator withString:@""];
    return tempNewString;
}

@end
