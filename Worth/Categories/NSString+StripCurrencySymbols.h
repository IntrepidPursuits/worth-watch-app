//
//  NSString+StripCurrencySymbols.h
//  Worth
//
//  Created by Patrick Butkiewicz on 3/16/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StripCurrencySymbols)

- (NSString *)stringByStrippingCurrencySymbols;

@end
