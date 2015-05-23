//
//  WorthEditUserViewController.m
//  Worth
//
//  Created by Patrick Butkiewicz on 5/22/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "WorthEditUserViewController.h"
#import "WorthRoundAvatarImageView.h"
#import "WorthTextField.h"
#import "WorthUser+UserGenerated.h"
#import "UIColor+WorthStyle.h"
#import "UIFont+WorthStyle.h"

@interface WorthEditUserViewController () <UITextFieldDelegate>

@property (strong, nonatomic) WorthUser *user;
@property (weak, nonatomic) IBOutlet WorthTextField *nameInputField;
@property (weak, nonatomic) IBOutlet WorthTextField *salaryInputField;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet WorthRoundAvatarImageView *avatarImageView;

@end

@implementation WorthEditUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
    [self configureLayout];
    [self updateLayout];
}

- (void)configure {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:gesture];
    [self setContinueButtonEnabled:NO];
}

- (void)configureLayout {
    [self.view setBackgroundColor:[UIColor worth_MainPhotoAreaColor]];
    [self.continueButton setBackgroundColor:[UIColor worth_Section2TextColor]];
    
    UIFont *inputFont = [UIFont worth_boldFontWithSize:17.0f];
    [self.continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.continueButton.titleLabel setFont:inputFont];
}

- (void)setContinueButtonEnabled:(BOOL)enabled {
    self.continueButton.enabled = enabled;
    self.continueButton.alpha = (enabled) ? 1.0f : 0.5f;
}

- (void)configureWithUser:(WorthUser *)user {
    self.user = user;
    [self updateLayout];
}

- (void)updateLayout {
    self.nameInputField.text = self.user.name;
    self.salaryInputField.text = [self.user.salary stringValue];
    
    BOOL enabled = (self.nameInputField.text.length && self.salaryInputField.text.length);
    [self setContinueButtonEnabled:enabled];
}

#pragma mark - Button Event Methods

- (IBAction)continueButtonTapped:(id)sender {
    [self.view endEditing:YES];
    self.user.name = self.nameInputField.text;
    self.user.salary = @([self.salaryInputField.text doubleValue]);
    [self.user.managedObjectContext save:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    UITextField *otherField = (textField == self.nameInputField) ? self.salaryInputField : self.nameInputField;
    
    BOOL enabled = (newText.length > 0) && (otherField.text.length > 0);
    [self setContinueButtonEnabled:enabled];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == self.nameInputField) {
        [self.salaryInputField becomeFirstResponder];
    }
    return YES;
}

@end
