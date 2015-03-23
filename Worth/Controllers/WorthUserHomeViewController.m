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
static CGFloat kUserContainerHeight = 98.0f;
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
@property (strong, nonatomic) WorthUser *user;

@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *verticalSpacingCollection;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *hideableFieldHeightConstraints;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *editableFieldSpacingConstraints;
@property (nonatomic) CGSize keyboardSize;

@end

@implementation WorthUserHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [[WorthUserManager sharedManager] currentUser];
    self.hourlyAmount = @(45.54);
    
    [self configureContainerViews];
    [self configureInputs];
    [self resetInputs];
    [self updateLayout];
    [self startInputTimers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];    
    [self configureNavigationItemsForContentMode:self.contentMode];
    [self configureLayoutWithContentMode:self.contentMode animated:NO];
    [self showInputFieldsAnimated:YES];
    [self enableNotificationsForListening:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self enableNotificationsForListening:NO];
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
    [self.earnedTimerField setDisplaysTimer:YES];
    
    [self.perHourField setInputAlignment:WorthMoneyTextViewAlignmentLeft];
    [self.perHourField setInputAccessoryText:@"/ hour"];
    [self.perHourField.numberFormatter setMaximumFractionDigits:2];
    [self.perHourField.numberFormatter setMinimumFractionDigits:2];
    
    [self.perHourEarnedTimerField setInputAlignment:WorthMoneyTextViewAlignmentRight];
    [self.perHourEarnedTimerField setDisplaysTimer:YES];
    
    self.userNameTextField.text = [[[WorthUserManager sharedManager] currentUser] name];
    self.userAvatarImageView.image = [UIImage imageNamed:@"profile_img"];
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

- (void)enableNotificationsForListening:(BOOL)enabled {
    if (enabled) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillBeHidden:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardDidHideNotification
                                                      object:nil];

        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillHideNotification
                                                      object:nil];
    }
}

- (void)resetInputs {
    NSDate *startDate = [NSDate date];
    NSDate *beginningOfDayDate = [startDate dateAtStartOfDay];
    NSDate *beginningOfYearDate = [startDate dateAtStartOfYear];
    double secondsSinceBeginningOfDayStart = [startDate timeIntervalSinceDate:beginningOfDayDate];
    double secondsSinceBeginningOfYearStart = [startDate timeIntervalSinceDate:beginningOfYearDate];
    
    CGFloat salaryPerSecond = [self.user salaryPerSecond];
    CGFloat dayAmount = (salaryPerSecond * secondsSinceBeginningOfDayStart);
    CGFloat yearAmount = (salaryPerSecond * secondsSinceBeginningOfYearStart);
    
    [self.salaryInput setStartAmount:self.user.salary];
    [self.yearToDateEarningsField setStartAmount:@(yearAmount)];
    [self.yearToDateEarningsField setDollarsPerSecond:salaryPerSecond];
    [self.dailyEarningsField setStartAmount:@(dayAmount)];
    [self.dailyEarningsField setDollarsPerSecond:salaryPerSecond];
    [self.earnedTimerField setStartAmount:@(0)];
    [self.earnedTimerField setDollarsPerSecond:salaryPerSecond];
    
    CGFloat hourlyPerSecond = ([self.hourlyAmount floatValue] / kSecondsPerHour);
    
    [self.perHourField setStartAmount:self.hourlyAmount];
    [self.perHourEarnedTimerField setStartAmount:@(0)];
    [self.perHourEarnedTimerField setDollarsPerSecond:hourlyPerSecond];
}

- (void)startInputTimers {
    [self.yearToDateEarningsField start];
    [self.dailyEarningsField start];
    [self.earnedTimerField start];
    [self.perHourEarnedTimerField start];
}

#pragma mark - Keyboard Notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    self.keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self configureLayoutWithContentMode:self.contentMode animated:YES];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    self.keyboardSize = CGRectZero.size;
    [self configureLayoutWithContentMode:self.contentMode animated:YES];
}

#pragma mark - Layout

- (void)updateLayout {
    self.userContainerView.hidden = (self.contentMode == WorthUserHomeControllerContentModeNone);
}

- (void)showInputFieldsAnimated:(BOOL)animated {
    [self.salaryInput animateIntoView:animated];
    [self.yearToDateEarningsField animateIntoView:animated];
    [self.dailyEarningsField animateIntoView:animated];
    [self.earnedTimerField animateIntoView:animated];
    [self.perHourField animateIntoView:animated];
    [self.perHourEarnedTimerField animateIntoView:animated];
}

#pragma mark - Button Event Methods

- (void)didTapEditButton:(id)sender {
    self.contentMode = ([[(UIBarButtonItem *)sender title] isEqualToString:kNavigationBarEditButtonTitle]) ? WorthUserHomeControllerContentModeEditing : WorthUserHomeControllerContentModeNone;
    self.view.backgroundColor = (self.contentMode == WorthUserHomeControllerContentModeEditing) ? [UIColor worth_darkGreenColor] : [UIColor worth_greenColor];
    BOOL editing = (self.contentMode == WorthUserHomeControllerContentModeEditing);

    if (editing == NO) {
        self.hourlyAmount = self.perHourField.startAmount;
        self.user.name = self.userNameTextField.text;
        self.user.salary = self.salaryInput.startAmount;
        [self.user.managedObjectContext save:nil];
        [self.view endEditing:YES];
    }
    
    [self updateLayout];
    [self configureNavigationItemsForContentMode:self.contentMode];
    [self.salaryInput setEditing:editing];
    [self.perHourField setEditing:editing];
    
    if (editing) {
        [self.salaryInput becomeFirstResponder];
    } else {
        [self resetInputs];
        [self startInputTimers];
    }
}

- (void)didTapRefreshButton:(id)sender {
    [self resetInputs];
    [self startInputTimers];
    [self updateLayout];
}

#pragma mark - Animations

- (void)configureLayoutWithContentMode:(WorthUserHomeControllerContentMode)contentMode animated:(BOOL)animated{
    BOOL editing = (contentMode == WorthUserHomeControllerContentModeEditing);
    [self.view layoutIfNeeded];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat bottomPadding = 10.0f;
    CGFloat windowHeight = screenRect.size.height;
    CGFloat navBarHeight = self.navigationController.navigationBar.bounds.size.height;
    CGFloat keyboardHeight = self.keyboardSize.height;
    CGFloat inputHeights = (self.salaryInput.bounds.size.height + self.perHourField.bounds.size.height);
    CGFloat remainingHeight = (windowHeight - keyboardHeight - navBarHeight - kUserContainerHeight - inputHeights);
    CGFloat inputFieldPadding = (remainingHeight / self.editableFieldSpacingConstraints.count) - bottomPadding;

    [UIView animateWithDuration:(animated) ? 0.3f : 0
                     animations:^{
                         for (NSLayoutConstraint *constraint in self.verticalSpacingCollection) {
                             [constraint setConstant:(editing) ? 0 : kVerticalSpacingDefault];
                         }
                         
                         for (NSLayoutConstraint *constraint in self.hideableFieldHeightConstraints) {
                             [constraint setConstant:(editing) ? 0 : FLT_MAX];
                         }
                         
                         for (NSLayoutConstraint *constraint in self.editableFieldSpacingConstraints) {
                             [constraint setConstant:(editing) ? inputFieldPadding : kVerticalSpacingDefault];
                         }
                         
                         self.userContainerHeightConstraint.constant = (contentMode == WorthUserHomeControllerContentModeEditing) ? kUserContainerHeight : 0;
                         [self.view layoutIfNeeded];
                     }];
}

@end
