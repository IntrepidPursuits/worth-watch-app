//
//  WorthUserHomeViewController.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "WorthUserHomeViewController.h"
#import "WorthMoneyTextView.h"
#import "WorthHeaderView.h"
#import "WorthUserManager.h"
#import "WorthRoundAvatarImageView.h"
#import "WorthUser+UserGenerated.h"
#import "UIColor+WorthStyle.h"
#import "NSString+StripCurrencySymbols.h"
#import "NSString+TimeString.h"
#import "NSDate+Worth.h"
#import <NSDate-Escort/NSDate+Escort.h>

static NSString * startTimeKey = @"kWorthAppHomeStoredTimer";
static NSInteger WorthUserHomeTableViewNumberOfSections = 8;
static NSString * kNavigationBarEditButtonTitle = @"Edit";
static NSString * kNavigationBarSaveButtonTitle = @"Save";

typedef NS_ENUM(NSUInteger, WorthUserHomeInfoSection) {
    WorthUserHomeInfoSectionUserGeneral,
    WorthUserHomeInfoSectionSalaryThisYear,
    WorthUserHomeInfoSectionSalaryToday,
    WorthUserHomeInfoSectionSalaryTimer,
    WorthUserHomeInfoSectionExpensesGeneral,
    WorthUserHomeInfoSectionExpensesThisYear,
    WorthUserHomeInfoSectionExpensesToday,
    WorthUserHomeInfoSectionExpensesTimer,
    WorthUserHomeInfoSectionExpensesDetail,
};

@interface WorthUserHomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) WorthUser *user;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) WorthHeaderView *userHeaderView;
@property (strong, nonatomic) WorthMoneyTextView *earnedThisYearView;
@property (strong, nonatomic) WorthMoneyTextView *earnedTodayView;
@property (strong, nonatomic) WorthMoneyTextView *earnedTimerView;
@property (strong, nonatomic) WorthHeaderView *expensesHeaderView;
@property (strong, nonatomic) WorthMoneyTextView *expensesThisYearView;
@property (strong, nonatomic) WorthMoneyTextView *expensesTodayView;
@property (strong, nonatomic) WorthMoneyTextView *expensesTimerView;

@property (strong, nonatomic) NSMutableArray *expenseViews;

@end

@implementation WorthUserHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [[WorthUserManager sharedManager] currentUser];
    [self configureContainerViews];
    [self resetInputs];
}

- (void)configureContainerViews {
    [self.view setBackgroundColor:[UIColor worth_greenColor]];
    [self.tableView setEstimatedRowHeight:UITableViewAutomaticDimension];
}

- (void)resetInputs {
    NSArray *expenses = @[@"Communibator", @"Spotify", @"Qup", @"Netflix",@"Communibator", @"Spotify", @"Qup", @"Netflix",@"Communibator", @"Spotify", @"Qup", @"Netflix",@"Communibator", @"Spotify", @"Qup", @"Netflix"];
    self.expenseViews = [NSMutableArray arrayWithCapacity:expenses.count];
    for (NSString *expense in expenses) {
        WorthHeaderView *hv = [[WorthHeaderView alloc] initWithFrame:CGRectZero];
        [hv setTitle:expense subTitle:@"$9.99/month"];
        [hv setAccessoryType:WorthHeaderViewAccessoryButtonTypeNone];
        [self.expenseViews addObject:hv];
    }
    
    [self resetEarnings];
    [self resetExpenses];
    [self startInputTimers];
}

- (void)startInputTimers {
    NSNumber *storedStartTime = [[NSUserDefaults standardUserDefaults] objectForKey:startTimeKey];
    CFTimeInterval startTime = ([storedStartTime integerValue] > 0) ? [storedStartTime floatValue] : CACurrentMediaTime();
    [self setTimerStartTime:startTime];
    
    [self.earnedThisYearView start];
    [self.earnedTodayView start];
    [self.earnedTimerView start];
    [self.expensesThisYearView start];
    [self.expensesTodayView start];
    [self.expensesTimerView start];
}

- (void)setTimerStartTime:(CFTimeInterval)time {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(time) forKey:startTimeKey];
    [defaults synchronize];
}

#pragma mark - Reset Helpers

- (void)resetEarnings {
    CGFloat salaryPerSecond = [self.user salaryPerSecond];
    CGFloat dayAmount = (salaryPerSecond * [NSDate secondsSinceBeginningOfDayStart]);
    CGFloat yearAmount = (salaryPerSecond * [NSDate secondsSinceBeginningOfYearStart]);
    
    [self.earnedThisYearView setStartAmount:@(yearAmount)];
    [self.earnedThisYearView setDollarsPerSecond:salaryPerSecond];
    [self.earnedTodayView setStartAmount:@(dayAmount)];
    [self.earnedTodayView setDollarsPerSecond:salaryPerSecond];
    [self.earnedTimerView setStartAmount:@(0)];
    [self.earnedTimerView setDollarsPerSecond:salaryPerSecond];
}

- (void)resetExpenses {
    CGFloat expensesPerSecond = 0.0012f;
    CGFloat dayAmount = (expensesPerSecond * [NSDate secondsSinceBeginningOfDayStart]);
    CGFloat yearAmount = (expensesPerSecond * [NSDate secondsSinceBeginningOfYearStart]);
    
    [self.expensesThisYearView setStartAmount:@(yearAmount)];
    [self.expensesThisYearView setDollarsPerSecond:expensesPerSecond];
    [self.expensesTodayView setStartAmount:@(dayAmount)];
    [self.expensesTodayView setDollarsPerSecond:expensesPerSecond];
    [self.expensesTimerView setStartAmount:@(0)];
    [self.expensesTimerView setDollarsPerSecond:expensesPerSecond];
}

#pragma mark - Button Event Methods

- (void)didTapRefreshButton:(id)sender {
    [self resetInputs];
}

#pragma mark - UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Tapped %@", indexPath);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return WorthUserHomeTableViewNumberOfSections + self.expenseViews.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WorthUserHomeInfoSection worthSection = (section >= WorthUserHomeInfoSectionExpensesDetail) ? WorthUserHomeInfoSectionExpensesDetail : (WorthUserHomeInfoSection)section;
    switch (worthSection) {
        case WorthUserHomeInfoSectionUserGeneral:       return self.userHeaderView;
        case WorthUserHomeInfoSectionSalaryThisYear:    return self.earnedThisYearView;
        case WorthUserHomeInfoSectionSalaryToday:       return self.earnedTodayView;
        case WorthUserHomeInfoSectionSalaryTimer:       return self.earnedTimerView;
        case WorthUserHomeInfoSectionExpensesGeneral:   return self.expensesHeaderView;
        case WorthUserHomeInfoSectionExpensesThisYear:  return self.expensesThisYearView;
        case WorthUserHomeInfoSectionExpensesToday:     return self.expensesTodayView;
        case WorthUserHomeInfoSectionExpensesTimer:     return self.expensesTimerView;
        case WorthUserHomeInfoSectionExpensesDetail:    return [self viewForExpenseInExpenseDetailSection:section];
        default:                                        return nil;
    }
}

- (UIView *)viewForExpenseInExpenseDetailSection:(NSInteger)section {
    NSInteger adjustedIndex = (section - WorthUserHomeInfoSectionExpensesDetail);
    WorthHeaderView *header = [self.expenseViews objectAtIndex:adjustedIndex];
    
    switch ((adjustedIndex % 3)) {
        case 0: {
            [header setImageContainerBackgroundColor:[UIColor worth_Section1PhotoColor]];
            [header setInformationContainerBackgroundColor:[UIColor worth_Section1TextColor]];
        }
            break;
        case 1: {
            [header setImageContainerBackgroundColor:[UIColor worth_Section1TextColor]];
            [header setInformationContainerBackgroundColor:[UIColor worth_Section2PhotoColor]];
        }
            break;
        case 2: {
            [header setImageContainerBackgroundColor:[UIColor worth_Section2PhotoColor]];
            [header setInformationContainerBackgroundColor:[UIColor worth_Section2TextColor]];
        }
        default:
            break;
    }
    
    return header;
}

#pragma mark - Lazy

- (WorthHeaderView *)userHeaderView {
    if (_userHeaderView == nil) {
        _userHeaderView = [[WorthHeaderView alloc] initWithFrame:CGRectZero];
        NSString *salary = [NSString stringWithFormat:@"%@/year", self.user.salary];
        [_userHeaderView setTitle:self.user.name subTitle:salary];
        [_userHeaderView setAccessoryType:WorthHeaderViewAccessoryButtonTypeNone];
    }
    return _userHeaderView;
}

- (WorthMoneyTextView *)earnedThisYearView {
    if (_earnedThisYearView == nil) {
        _earnedThisYearView = [[WorthMoneyTextView alloc] initWithFrame:CGRectZero];
        [_earnedThisYearView setSubtitleText:@"Earned this year"];
        [_earnedThisYearView.numberFormatter setMaximumFractionDigits:2];
    }
    return _earnedThisYearView;
}

- (WorthMoneyTextView *)earnedTodayView {
    if (_earnedTodayView == nil) {
        _earnedTodayView = [[WorthMoneyTextView alloc] initWithFrame:CGRectZero];
        [_earnedTodayView setSubtitleText:@"Earned today"];
        [_earnedTodayView.numberFormatter setMaximumFractionDigits:2];
    }
    return _earnedTodayView;
}

- (WorthMoneyTextView *)earnedTimerView {
    if (_earnedTimerView == nil) {
        _earnedTimerView = [[WorthMoneyTextView alloc] initWithFrame:CGRectZero];
        [_earnedTimerView setDisplaysTimer:YES];
        [_earnedTimerView.numberFormatter setMaximumFractionDigits:5];
    }
    return _earnedTimerView;
}

- (WorthHeaderView *)expensesHeaderView {
    if (_expensesHeaderView == nil) {
        _expensesHeaderView = [[WorthHeaderView alloc] initWithFrame:CGRectZero];
        NSString *salary = [NSString stringWithFormat:@"%@/year", @"$1,234.00"];
        [_expensesHeaderView setTitle:@"Recurring Expenses" subTitle:salary];
        [_expensesHeaderView setAccessoryType:WorthHeaderViewAccessoryButtonTypePlus];
    }
    return _expensesHeaderView;
}

- (WorthMoneyTextView *)expensesThisYearView {
    if (_expensesThisYearView == nil) {
        _expensesThisYearView = [[WorthMoneyTextView alloc] initWithFrame:CGRectZero];
        [_expensesThisYearView setSubtitleText:@"Spent this year"];
        [_expensesThisYearView.numberFormatter setMaximumFractionDigits:2];
    }
    return _expensesThisYearView;
}

- (WorthMoneyTextView *)expensesTodayView {
    if (_expensesTodayView == nil) {
        _expensesTodayView = [[WorthMoneyTextView alloc] initWithFrame:CGRectZero];
        [_expensesTodayView setSubtitleText:@"Spent today"];
        [_expensesTodayView.numberFormatter setMaximumFractionDigits:2];
    }
    return _expensesTodayView;
}

- (WorthMoneyTextView *)expensesTimerView {
    if (_expensesTimerView == nil) {
        _expensesTimerView = [[WorthMoneyTextView alloc] initWithFrame:CGRectZero];
        [_expensesTimerView setDisplaysTimer:YES];
        [_expensesTimerView.numberFormatter setMaximumFractionDigits:5];
    }
    return _expensesTimerView;
}

@end
