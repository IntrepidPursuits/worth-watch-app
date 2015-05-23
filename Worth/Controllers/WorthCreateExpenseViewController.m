//
//  WorthCreateExpenseViewController.m
//  Worth
//
//  Created by Patrick Butkiewicz on 5/22/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "WorthCreateExpenseViewController.h"
#import "WorthTextField.h"
#import "UIColor+WorthStyle.h"
#import "UIFont+WorthStyle.h"

@interface WorthCreateExpenseViewController ()
@property (weak, nonatomic) IBOutlet WorthTextField *serviceNameField;
@property (weak, nonatomic) IBOutlet WorthTextField *serviceCostField;
@property (weak, nonatomic) IBOutlet UIButton *weeklyButton;
@property (weak, nonatomic) IBOutlet UIButton *monthlyButton;
@property (weak, nonatomic) IBOutlet UIButton *yearlyButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@end

@implementation WorthCreateExpenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureLayout];
}

- (void)configureLayout {
    [self.view setBackgroundColor:[UIColor worth_MainPhotoAreaColor]];
    [self configureButtons];
    [self configureInputs];
}

- (void)configureInputs {
    [self.serviceNameField setPlaceholder:@"Name of Service"];
    [self.serviceCostField setPlaceholder:@"Cost of Service"];
}

- (void)configureButtons {
    [self.weeklyButton setBackgroundColor:[UIColor worth_Section1PhotoColor]];
    [self.weeklyButton setTitleColor:[UIColor worth_TitleBarColor] forState:UIControlStateNormal];
    
    [self.monthlyButton setBackgroundColor:[UIColor worth_Section1TextColor]];
    [self.monthlyButton setTitleColor:[UIColor worth_TitleBarColor] forState:UIControlStateNormal];
    
    [self.yearlyButton setBackgroundColor:[UIColor worth_Section2PhotoColor]];
    [self.yearlyButton setTitleColor:[UIColor worth_TitleBarColor] forState:UIControlStateNormal];
    
    [self.closeButton setBackgroundColor:[UIColor worth_Section2TextColor]];
    [self.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

@end
