//
//  WorthUserHomeViewController.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "WorthUserHomeViewController.h"
#import "WorthMoneyTextView.h"
#import "WorthUserManager.h"
#import "WorthRoundAvatarImageView.h"
#import "WorthUser+UserGenerated.h"
#import "UIColor+WorthStyle.h"
#import "NSString+StripCurrencySymbols.h"
#import "NSString+TimeString.h"
#import <NSDate-Escort/NSDate+Escort.h>

static NSInteger kSecondsPerHour = (60 * 60);
static CGFloat kVerticalSpacingDefault = 8.0f;
static NSString * kNavigationBarEditButtonTitle = @"Edit";
static NSString * kNavigationBarSaveButtonTitle = @"Save";

typedef NS_ENUM(NSUInteger, WorthUserHomeControllerContentMode) {
    WorthUserHomeControllerContentModeNone,
    WorthUserHomeControllerContentModeEditing,
};

@interface WorthUserHomeViewController ()
@property (nonatomic) WorthUserHomeControllerContentMode contentMode;

@property (weak, nonatomic) IBOutlet WorthMoneyTextView *salaryInput;
@property (weak, nonatomic) IBOutlet WorthMoneyTextView *yearToDateEarningsField;
@property (weak, nonatomic) IBOutlet WorthMoneyTextView *dailyEarningsField;
@property (weak, nonatomic) IBOutlet WorthMoneyTextView *earnedTimerField;

@property (weak, nonatomic) IBOutlet WorthMoneyTextView *perHourField;
@property (weak, nonatomic) IBOutlet WorthMoneyTextView *perHourEarnedTimerField;

@property (weak, nonatomic) IBOutlet UIView *salaryContainerView;
@property (weak, nonatomic) IBOutlet UIView *hourlyContainerView;
@property (weak, nonatomic) IBOutlet UIView *userContainerView;

@property (weak, nonatomic) IBOutlet WorthRoundAvatarImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *salaryContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *perHourContainerHeightConstraint;

@property (strong, nonatomic) NSNumber *hourlyAmount;

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *beginningOfDayDate;
@property (nonatomic, assign) NSUInteger secondsSinceBeginningOfDayStart;
@property (strong, nonatomic) NSDate *beginningOfYearDate;
@property (nonatomic, assign) NSUInteger secondsSinceBeginningOfYearStart;
@property (strong, nonatomic) WorthUser *user;

@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *verticalSpacingCollection;

@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *hideableFieldHeightConstraints;

@end

@implementation WorthUserHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [[WorthUserManager sharedManager] currentUser];
    self.hourlyAmount = @(45.54);
    
    [self configureInputs];
    [self configureContainerViews];
    [self resetTimer];
    [self updateLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavigationItemsForContentMode:self.contentMode];
    [self configureLayoutWithContentMode:self.contentMode animated:NO];
    
    [self.salaryInput setAmount:self.user.salary];
    [self.perHourField setAmount:self.hourlyAmount];

    [self.salaryInput animateIntoView:YES];
    [self.yearToDateEarningsField animateIntoView:YES];
    [self.dailyEarningsField animateIntoView:YES];
    [self.earnedTimerField animateIntoView:YES];
    [self.perHourField animateIntoView:YES];
    [self.perHourEarnedTimerField animateIntoView:YES];
    
    self.userNameTextField.text = [[[WorthUserManager sharedManager] currentUser] name];
    self.userAvatarImageView.image = [UIImage imageNamed:@"profile_img"];
}

- (void)configureContainerViews {
    [self.view setBackgroundColor:[UIColor worth_greenColor]];
    [self.salaryContainerView setBackgroundColor:[UIColor worth_lightGreenColor]];
    [self.hourlyContainerView setBackgroundColor:[UIColor worth_greenColor]];
    [self.userContainerView setBackgroundColor:[UIColor worth_darkGreenColor]];
}

- (void)configureInputs {
    [self.salaryInput setInputAlignment:WorthMoneyTextViewAlignmentLeft];
    [self.salaryInput setInputAccessoryText:@"/ year"];
    [self.salaryInput.numberFormatter setMaximumFractionDigits:2];
    [self.salaryInput.numberFormatter setMinimumFractionDigits:2];

    [self.yearToDateEarningsField setInputAlignment:WorthMoneyTextViewAlignmentRight];
    [self.yearToDateEarningsField setSubtitleText:@"Earned so far this year"];
    
    [self.dailyEarningsField setInputAlignment:WorthMoneyTextViewAlignmentRight];
    [self.dailyEarningsField setSubtitleText:@"Earned so far today"];
    
    [self.earnedTimerField setInputAlignment:WorthMoneyTextViewAlignmentRight];
    [self.earnedTimerField setSubtitleText:@"Earned in 00:00:00:00"];
    
    [self.perHourField setInputAlignment:WorthMoneyTextViewAlignmentLeft];
    [self.perHourField setInputAccessoryText:@"/ hour"];
    [self.perHourField.numberFormatter setMaximumFractionDigits:2];
    [self.perHourField.numberFormatter setMinimumFractionDigits:2];
    
    [self.perHourEarnedTimerField setInputAlignment:WorthMoneyTextViewAlignmentRight];
    [self.perHourEarnedTimerField setSubtitleText:@"Earned in 00:00:00:00"];
}

- (void)configureNavigationItemsForContentMode:(WorthUserHomeControllerContentMode)contentMode {
    NSString *buttonString = (contentMode == WorthUserHomeControllerContentModeEditing) ? kNavigationBarSaveButtonTitle : kNavigationBarEditButtonTitle;
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:buttonString
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(didTapEditButton:)];
    UIBarButtonItem *refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                          target:self
                                                                                          action:@selector(didTapRefreshButton:)];
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = refreshBarButtonItem;
    self.navigationController.topViewController.navigationItem.leftBarButtonItem = editBarButtonItem;
}

- (void)resetTimer {
    self.startDate = [NSDate date];
    self.beginningOfDayDate = [[NSDate date] dateAtStartOfDay];
    self.secondsSinceBeginningOfDayStart = [self.startDate timeIntervalSinceDate:self.beginningOfDayDate];
    self.beginningOfYearDate = [[NSDate date] dateAtStartOfYear];
    self.secondsSinceBeginningOfYearStart = [self.startDate timeIntervalSinceDate:self.beginningOfYearDate];
    [self.timer invalidate];
    self.timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateLayout) userInfo:nil repeats:YES];
    [self.timer setTolerance:0.3f];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark - Layout

- (void)updateLayout {
    self.userContainerView.hidden = (self.contentMode == WorthUserHomeControllerContentModeNone);
    
    NSDate *date = [NSDate date];
    NSUInteger secondsSinceTimer = [date timeIntervalSinceDate:self.startDate];
    NSUInteger secondsSinceDay = (self.secondsSinceBeginningOfDayStart + secondsSinceTimer);
    NSUInteger secondsSinceYear = (self.secondsSinceBeginningOfYearStart + secondsSinceTimer);
    
    CGFloat salaryPerSecond = [self.user salaryPerSecond];
    CGFloat timerAmount = (salaryPerSecond * secondsSinceTimer);
    CGFloat dayAmount = (salaryPerSecond * secondsSinceDay);
    CGFloat yearAmount = (salaryPerSecond * secondsSinceYear);
    
    [self.yearToDateEarningsField setAmount:@(yearAmount)];
    [self.dailyEarningsField setAmount:@(dayAmount)];
    [self.earnedTimerField setAmount:@(timerAmount)];
    
    NSString *earnedTimerString = [NSString stringWithFormat:@"Earned in %@", [NSString timeStringFromSecond:secondsSinceTimer]];
    [self.earnedTimerField setSubtitleText:earnedTimerString];
    [self.perHourEarnedTimerField setSubtitleText:earnedTimerString];
    
    CGFloat perHourAmountPerSecond = ([self.hourlyAmount floatValue] / kSecondsPerHour);
    CGFloat perHourTimerAmount = (perHourAmountPerSecond * secondsSinceTimer);
    [self.perHourEarnedTimerField setAmount:@(perHourTimerAmount)];
}

#pragma mark - Button Event Methods

- (void)didTapEditButton:(id)sender {
    self.contentMode = ([[(UIBarButtonItem *)sender title] isEqualToString:kNavigationBarEditButtonTitle]) ? WorthUserHomeControllerContentModeEditing : WorthUserHomeControllerContentModeNone;
    self.view.backgroundColor = (self.contentMode == WorthUserHomeControllerContentModeEditing) ? [UIColor worth_darkGreenColor] : [UIColor worth_greenColor];

    BOOL didSave = (self.contentMode == WorthUserHomeControllerContentModeNone);
    if (didSave) {
        self.hourlyAmount = self.perHourField.amount;
        self.user.name = self.userNameTextField.text;
        self.user.salary = self.salaryInput.amount;
        [self.user.managedObjectContext save:nil];
        [self.view endEditing:YES];
    }
    
    [self updateLayout];
    [self configureNavigationItemsForContentMode:self.contentMode];
    [self configureLayoutWithContentMode:self.contentMode animated:YES];
}

- (void)didTapRefreshButton:(id)sender {
    [self resetTimer];
    [self updateLayout];
}

#pragma mark - Animations

- (void)configureLayoutWithContentMode:(WorthUserHomeControllerContentMode)contentMode animated:(BOOL)animated{
    BOOL editing = (contentMode == WorthUserHomeControllerContentModeEditing);
    [self.view layoutIfNeeded];

    [self.salaryInput setEditing:editing];
    [self.perHourField setEditing:editing];
    
    [UIView animateWithDuration:(animated) ? 0.3f : 0
                     animations:^{
                         for (NSLayoutConstraint *constraint in self.verticalSpacingCollection) {
                             [constraint setConstant:(editing) ? 0 : kVerticalSpacingDefault];
                         }
                         
                         for (NSLayoutConstraint *constraint in self.hideableFieldHeightConstraints) {
                             [constraint setConstant:(editing) ? 0 : 600];
                         }
                         
                         self.userContainerHeightConstraint.constant = (contentMode == WorthUserHomeControllerContentModeEditing) ? 98.0f : 0;
                         [self.view layoutIfNeeded];
                     }];
    
    [self.salaryInput becomeFirstResponder];
}

@end
