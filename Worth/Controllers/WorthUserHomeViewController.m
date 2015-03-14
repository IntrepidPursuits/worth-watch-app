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

@end

@implementation WorthUserHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureInputs];
    [self configureContainerViews];
    [self configureNavigationItemsForContentMode:self.contentMode];
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

#pragma mark - Layout

- (void)updateLayout {
    [self configureNavigationItemsForContentMode:self.contentMode];
}
                                            
#pragma mark - Button Event Methods

- (void)didTapEditButton:(id)sender {
    self.contentMode = ([[(UIBarButtonItem *)sender title] isEqual:@"Edit"]) ? WorthUserHomeControllerContentModeEditing : WorthUserHomeControllerContentModeNone;
    [self updateLayout];
}

@end
