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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.selfUserView configureWithUser:self.user];
    [self.compareUserView configureWithUser:self.comparedToUser];
    [self resetTimer];
    [self showFieldsAnimated:animated];
    [self configureNavigationItems];
}

- (void)configureAppearance {
    [self.view setBackgroundColor:[UIColor worth_greenColor]];
    [self.topContainerView setBackgroundColor:[UIColor worth_lightGreenColor]];
    [self.bottomContainerView setBackgroundColor:[UIColor worth_greenColor]];
    [self.selfUserView setContentMode:WorthUserViewContentModeSelf];
    [self.compareUserView setContentMode:WorthUserViewContentModeSelf];
}

- (void)configureNavigationItems {
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonTapped:)];
}

- (void)configureFields {
    [self.selfYearlyEarningsField setSubtitleText:@"Earned so far this year"];
    [self.selfYearlyEarningsField setContentType:WorthMoneyTextViewContentTypeTimed];
    [self.selfYearlyEarningsField setContentMode:WorthMoneyTextViewContentModeEarned];
    
    [self.compareYearlyEarningsField setSubtitleText:@"Earned so far this year"];
    [self.compareYearlyEarningsField setContentMode:WorthMoneyTextViewContentModeEarned];
    [self.compareYearlyEarningsField setContentType:WorthMoneyTextViewContentTypeTimed];
}

#pragma mark - Animations

- (void)showFieldsAnimated:(BOOL)animated {
    [self.selfYearlyEarningsField animateIntoViewWithProgress:0.5 animated:YES];
    [self.selfTimerEarningsField animateIntoViewWithProgress:0.5 animated:YES];
    [self.compareYearlyEarningsField animateIntoViewWithProgress:0.5 animated:YES];
    [self.compareTimerEarningsField animateIntoViewWithProgress:0.5 animated:YES];
}

#pragma mark - Helpers

- (void)resetTimer {
    NSDate *date = [NSDate date];
    NSDate *beginningOfYearDate = [date dateAtStartOfYear];
    NSTimeInterval secondsSinceYear = [date timeIntervalSinceDate:beginningOfYearDate];
    
    [self.selfYearlyEarningsField setDollarsPerSecond:self.user.salaryPerSecond];
    [self.selfYearlyEarningsField setStartAmount:@(self.user.salaryPerSecond * secondsSinceYear)];
    [self.selfTimerEarningsField setDollarsPerSecond:self.user.salaryPerSecond];
    [self.selfTimerEarningsField setStartAmount:@(0)];
    
    [self.compareYearlyEarningsField setDollarsPerSecond:self.comparedToUser.salaryPerSecond];
    [self.compareYearlyEarningsField setStartAmount:@(self.comparedToUser.salaryPerSecond * secondsSinceYear)];
    [self.compareTimerEarningsField setDollarsPerSecond:self.comparedToUser.salaryPerSecond];
    [self.compareTimerEarningsField setStartAmount:@(0)];
    
    [self.selfYearlyEarningsField start];
    [self.selfTimerEarningsField start];
    [self.compareTimerEarningsField start];
    [self.compareYearlyEarningsField start];
}

#pragma mark - Button Event Methods

- (void)refreshButtonTapped:(id)sender {
    [self resetTimer];
}

@end
