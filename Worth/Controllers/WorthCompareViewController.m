//
//  WorthCompareViewController.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/15/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "WorthCompareViewController.h"
#import "WorthUser+UserGenerated.h"
#import "WorthUserView.h"
#import "WorthMoneyTextView.h"
#import "WorthUserManager.h"
#import "NSString+TimeString.h"
#import "UIColor+WorthStyle.h"
#import <NSDate-Escort/NSDate+Escort.h>

@interface WorthCompareViewController ()
@property (weak, nonatomic) IBOutlet UIView *topContainerView;
@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;

@property (weak, nonatomic) IBOutlet WorthUserView *selfUserView;
@property (weak, nonatomic) IBOutlet WorthMoneyTextView *selfYearlyEarningsField;
@property (weak, nonatomic) IBOutlet WorthMoneyTextView *selfTimerEarningsField;
@property (weak, nonatomic) IBOutlet WorthUserView *compareUserView;
@property (weak, nonatomic) IBOutlet WorthMoneyTextView *compareYearlyEarningsField;
@property (weak, nonatomic) IBOutlet WorthMoneyTextView *compareTimerEarningsField;

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *beginningOfDayDate;
@property (strong, nonatomic) NSDate *beginningOfYearDate;
@end

@implementation WorthCompareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Compare";
    self.user = [[WorthUserManager sharedManager] currentUser];
    [self configureAppearance];
    [self configureFields];
    [self configureNavigationItems];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.selfUserView configureWithUser:self.user];
    [self.compareUserView configureWithUser:self.comparedToUser];
    [self resetTimer];
    [self updateLayout];
    [self showFieldsAnimated:animated];
}

- (void)configureAppearance {
    [self.topContainerView setBackgroundColor:[UIColor worth_lightGreenColor]];
    [self.bottomContainerView setBackgroundColor:[UIColor worth_greenColor]];
    [self.selfUserView setContentMode:WorthUserViewContentModeSelf];
    [self.compareUserView setContentMode:WorthUserViewContentModeSelf];
}

- (void)configureNavigationItems {
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonTapped:)];
}

- (void)configureFields {
    [self.selfYearlyEarningsField setInputAlignment:WorthMoneyTextViewAlignmentRight];
    [self.selfYearlyEarningsField setSubtitleText:@"Earned so far this year"];
    
    [self.selfTimerEarningsField setInputAlignment:WorthMoneyTextViewAlignmentRight];
    [self.selfTimerEarningsField setSubtitleText:@"Earned in 00:00:00"];
    
    [self.compareYearlyEarningsField setInputAlignment:WorthMoneyTextViewAlignmentRight];
    [self.compareYearlyEarningsField setSubtitleText:@"Earned so far this year"];
    
    [self.compareTimerEarningsField setInputAlignment:WorthMoneyTextViewAlignmentRight];
    [self.compareTimerEarningsField setSubtitleText:@"Earned in 00:00:00"];
}

#pragma mark - Animations

- (void)showFieldsAnimated:(BOOL)animated {
    [self.selfYearlyEarningsField animateIntoView:animated];
    [self.selfTimerEarningsField animateIntoView:animated];
    [self.compareYearlyEarningsField animateIntoView:animated];
    [self.compareTimerEarningsField animateIntoView:animated];
}

#pragma mark - Timer Handling

- (void)updateLayout {
    NSDate *date = [NSDate date];
    NSUInteger secondsSinceTimer = [date timeIntervalSinceDate:self.startDate];
    NSUInteger secondsSinceYear = [date timeIntervalSinceDate:self.beginningOfYearDate];
    NSString *timerString = [NSString stringWithFormat:@"Earned in %@", [NSString timeStringFromSecond:secondsSinceTimer]];
    
    [self.selfYearlyEarningsField setAmount:@(self.user.salaryPerSecond * secondsSinceYear)];
    [self.selfTimerEarningsField setAmount:@(self.user.salaryPerSecond * secondsSinceTimer)];
    [self.selfTimerEarningsField setSubtitleText:timerString];
    
    [self.compareYearlyEarningsField setAmount:@(self.comparedToUser.salaryPerSecond * secondsSinceYear)];
    [self.compareTimerEarningsField setAmount:@(self.comparedToUser.salaryPerSecond * secondsSinceTimer)];
    [self.compareTimerEarningsField setSubtitleText:timerString];
}

#pragma mark - Helpers

- (void)resetTimer {
    self.startDate = [NSDate date];
    self.beginningOfDayDate = [[NSDate date] dateAtStartOfDay];
    self.beginningOfYearDate = [[NSDate date] dateAtStartOfYear];
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateLayout) userInfo:nil repeats:YES];
}

#pragma mark - Button Event Methods

- (void)refreshButtonTapped:(id)sender {
    [self resetTimer];
}

@end
