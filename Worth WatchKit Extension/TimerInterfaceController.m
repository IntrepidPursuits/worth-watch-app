//
//  TimerInterfaceController.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/13/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "TimerInterfaceController.h"

static CGFloat kSalary = 24000000;

@interface TimerInterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *salaryLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceTimer *salaryTimer;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *imRichLabel;

@property (strong, nonatomic) NSTimer *refreshTimer;
@property (strong, nonatomic) NSNumberFormatter *currencyFormatter;
@property (strong, nonatomic) NSDate *startDate;

@end


@implementation TimerInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
}

- (void)willActivate {
    [super willActivate];
    self.startDate = [NSDate date];
    [self.salaryTimer start];
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateLayout) userInfo:nil repeats:YES];
}

- (void)didDeactivate {
    [self.refreshTimer invalidate];
    [super didDeactivate];
}

#pragma mark - Layout

- (void)updateLayout {
    CGFloat timePassed = [[NSDate date] timeIntervalSinceDate:self.startDate];
    CGFloat salaryPerSecond = ((((kSalary / 365) / 24) / 60) / 60);
    CGFloat amountMade = salaryPerSecond * timePassed;
    self.salaryLabel.text = [self.currencyFormatter stringFromNumber:@(kSalary)];
    self.imRichLabel.text = [self.currencyFormatter stringFromNumber:@(amountMade)];
}

#pragma mark - Lazy

- (NSNumberFormatter *)currencyFormatter {
    if (_currencyFormatter == nil) {
        _currencyFormatter = [NSNumberFormatter new];
        [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    return _currencyFormatter;
}

@end



