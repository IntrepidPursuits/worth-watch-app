//
//  WorthUserHomeViewController.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "WorthUserHomeViewController.h"
#import "WorthMoneyTextView.h"
#import "UIColor+WorthStyle.h"
#import <NSDate-Escort/NSDate+Escort.h>

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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *salaryContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *perHourContainerHeightConstraint;

@property (strong, nonatomic) NSNumber *amount;
@property (strong, nonatomic) NSNumber *hourlyAmount;

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *beginningOfDayDate;
@property (strong, nonatomic) NSDate *beginningOfYearDate;

@end

@implementation WorthUserHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.amount = @(1000000);
    self.hourlyAmount = @(45.54);
    
    [self configureInputs];
    [self configureContainerViews];
    [self configureTimer];
    [self updateLayout];
    [self.view layoutIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated {
    [self configureNavigationItemsForContentMode:self.contentMode];
    [self configureLayoutWithContentMode:self.contentMode animated:NO];
}

- (void)configureContainerViews {
    [self.salaryContainerView setBackgroundColor:[UIColor worth_lightGreenColor]];
    [self.hourlyContainerView setBackgroundColor:[UIColor worth_greenColor]];
}

- (void)configureInputs {
    [self.salaryInput setInputAlignment:WorthMoneyTextViewAlignmentLeft];
    [self.salaryInput setInputAccessoryText:@"/ year"];
    [self.salaryInput setSubtitleText:@"Salary"];

    [self.yearToDateEarningsField setInputAlignment:WorthMoneyTextViewAlignmentRight];
    [self.yearToDateEarningsField setSubtitleText:@"Earned so far this year"];
    
    [self.dailyEarningsField setInputAlignment:WorthMoneyTextViewAlignmentRight];
    [self.dailyEarningsField setSubtitleText:@"Earned so far today"];
    
    [self.earnedTimerField setInputAlignment:WorthMoneyTextViewAlignmentRight];
    [self.earnedTimerField setSubtitleText:@"Earned in 00:00:00:00"];
    
    [self.perHourField setInputAlignment:WorthMoneyTextViewAlignmentLeft];
    [self.perHourField setInputAccessoryText:@"/ hour"];
    
    [self.perHourEarnedTimerField setInputAlignment:WorthMoneyTextViewAlignmentRight];
    [self.perHourEarnedTimerField setSubtitleText:@"Earned in 00:00:00:00"];
    
    [self.salaryInput setBackgroundColor:[UIColor clearColor]];
    [self.dailyEarningsField setBackgroundColor:[UIColor clearColor]];
    [self.yearToDateEarningsField setBackgroundColor:[UIColor clearColor]];
    [self.earnedTimerField setBackgroundColor:[UIColor clearColor]];
    [self.perHourField setBackgroundColor:[UIColor clearColor]];
    [self.perHourEarnedTimerField setBackgroundColor:[UIColor clearColor]];
}

- (void)configureNavigationItemsForContentMode:(WorthUserHomeControllerContentMode)contentMode {
    NSString *buttonString = (contentMode == WorthUserHomeControllerContentModeEditing) ? @"Save" : @"Edit";
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:buttonString
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(didTapEditButton:)];
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = editBarButtonItem;
}

- (void)configureTimer {
    self.startDate = [NSDate date];
    self.beginningOfDayDate = [[NSDate date] dateAtStartOfDay];
    self.beginningOfYearDate = [[NSDate date] dateAtStartOfYear];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateLayout) userInfo:nil repeats:YES];
}

#pragma mark - Layout

- (void)updateLayout {
    self.userContainerView.hidden = (self.contentMode == WorthUserHomeControllerContentModeNone);
    [self.salaryInput setAmount:self.amount];
    
    NSDate *date = [NSDate date];
    CGFloat amountPerSecond = (((([self.amount floatValue] / 365) / 24) / 60) / 60);
    NSUInteger secondsSinceTimer = [date timeIntervalSinceDate:self.startDate];
    NSUInteger secondsSinceDay = [date timeIntervalSinceDate:self.beginningOfDayDate];
    NSUInteger secondsSinceYear = [date timeIntervalSinceDate:self.beginningOfYearDate];
    
    CGFloat timerAmount = (amountPerSecond * secondsSinceTimer);
    CGFloat dayAmount = (amountPerSecond * secondsSinceDay);
    CGFloat yearAmount = (amountPerSecond * secondsSinceYear);
    
    [self.yearToDateEarningsField setAmount:@(yearAmount)];
    [self.dailyEarningsField setAmount:@(dayAmount)];
    [self.earnedTimerField setAmount:@(timerAmount)];
    
    NSString *earnedTimerString = [NSString stringWithFormat:@"Earned in %@", [self timeFormatted:secondsSinceTimer]];
    [self.earnedTimerField setSubtitleText:earnedTimerString];
    [self.perHourEarnedTimerField setSubtitleText:earnedTimerString];
    
    CGFloat perHourAmountPerSecond = (([self.hourlyAmount floatValue] / 60) / 60);
    CGFloat perHourTimerAmount = (perHourAmountPerSecond * secondsSinceTimer);
    [self.perHourField setAmount:self.hourlyAmount];
    [self.perHourEarnedTimerField setAmount:@(perHourTimerAmount)];
}

#pragma mark - Button Event Methods

- (void)didTapEditButton:(id)sender {
    self.contentMode = ([[(UIBarButtonItem *)sender title] isEqual:@"Edit"]) ? WorthUserHomeControllerContentModeEditing : WorthUserHomeControllerContentModeNone;
    [self updateLayout];
    [self configureNavigationItemsForContentMode:self.contentMode];
    [self configureLayoutWithContentMode:self.contentMode animated:YES];
}

#pragma mark - Animations

- (void)configureLayoutWithContentMode:(WorthUserHomeControllerContentMode)contentMode animated:(BOOL)animated{
    BOOL editing = (contentMode == WorthUserHomeControllerContentModeEditing);
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:(animated) ? 0.3f : 0
                     animations:^{
                         NSLayoutConstraint *salaryConstraint = (editing) ? [self heightConstraintForView:self.salaryContainerView height:[self heightForInputView:self.salaryInput]] : [self softHeightConstraintForView:self.salaryContainerView];
                         [salaryConstraint setPriority:UILayoutPriorityRequired];
                         NSLayoutConstraint *perHourConstraint = (editing) ? [self heightConstraintForView:self.hourlyContainerView height:[self heightForInputView:self.perHourField]] : [self softHeightConstraintForView:self.hourlyContainerView];
                         [perHourConstraint setPriority:UILayoutPriorityRequired];
                         
                         [self.salaryContainerView removeConstraint:self.salaryContainerHeightConstraint];
                         [self.salaryContainerView layoutIfNeeded];
                         [self.salaryContainerView addConstraint:salaryConstraint];
                         [self.salaryContainerView layoutIfNeeded];
                         
                         [self.hourlyContainerView removeConstraint:self.perHourContainerHeightConstraint];
                         [self.hourlyContainerView layoutIfNeeded];
                         [self.hourlyContainerView addConstraint:perHourConstraint];
                         [self.hourlyContainerView layoutIfNeeded];
                         
                         self.salaryContainerHeightConstraint = salaryConstraint;
                         self.perHourContainerHeightConstraint = perHourConstraint;
                         
                         self.salaryInput.userInteractionEnabled = editing;
                         
                         self.userContainerHeightConstraint.constant = (contentMode == WorthUserHomeControllerContentModeEditing) ? 98.0f : 0;
                         [self.view layoutIfNeeded];
                     }];
}

- (NSLayoutConstraint *)heightConstraintForView:(UIView *)view height:(CGFloat)height {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:view
                                                                  attribute:NSLayoutAttributeHeight
                                                                 multiplier:1.0
                                                                   constant:height];
    return constraint;
}

- (NSLayoutConstraint *)softHeightConstraintForView:(UIView *)view {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                     toItem:view
                                                                  attribute:NSLayoutAttributeHeight
                                                                 multiplier:1.0
                                                                   constant:1.0];
    return constraint;
}


- (CGFloat)heightForInputView:(UIView *)view {
    static CGFloat padding = 8.0f;
    CGFloat height = (padding * 2.0f) + view.bounds.size.height;
    return height;
}

#pragma mark - Helpers

- (NSString *)timeFormatted:(NSInteger)totalSeconds {
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

@end
