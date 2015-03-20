//
//  WorthMoneyTextView.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "WorthMoneyTextView.h"
#import "NSString+StripCurrencySymbols.h"
#import "UIFont+WorthStyle.h"
#import <UICountingLabel/UICountingLabel.h>

static CGFloat kMoneyTextViewAlignmentIndentation = 0.25f;
static CGFloat kMoneyTextViewDefaultIndentation = 0.0f;
static CGFloat kMoneyTextViewSubTextFontSize = 14.0f;
static CGFloat kMoneyTextViewTextFontSize = 24.0f;
static CGFloat kMoneyTextViewCountAnimationDefaultLength = 1.0f;
static NSUInteger kMoneyTextViewDefaultDecimalPlaces = 6;

@interface WorthMoneyTextView() <UITextFieldDelegate>

@property (strong, nonatomic) UIView *nibView;
@property (weak, nonatomic) IBOutlet UICountingLabel *inputLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputTextFieldLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputTextFieldTrailingConstraint;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation WorthMoneyTextView
@synthesize inputAccessoryText = _inputAccessoryText;
@synthesize subtitleText = _subtitleText;

#pragma mark - Init

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])){
        self.nibView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                      owner:self
                                                    options:nil] lastObject];
        [self addSubview:self.nibView];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bar]-0-|" options:0 metrics:nil views:@{@"bar" : self.nibView}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[bar]-0-|" options:0 metrics:nil views:@{@"bar" : self.nibView}]];
        self.nibView.translatesAutoresizingMaskIntoConstraints = NO;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self configure];
    }
    return self;
}

- (void)configure {
    [self.inputTextField setDelegate:self];
    [self.inputTextField setFont:[UIFont worth_regularFontWithSize:kMoneyTextViewTextFontSize]];
    [self.inputTextField setHidden:YES];
    [self.inputTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    [self.inputTextField setUserInteractionEnabled:NO];
    [self.inputLabel setMethod:UILabelCountingMethodLinear];
    
    [self configureInputLabelWithAccessoryText:self.inputAccessoryText];
    [self updateLayout];
}

- (void)configureInputLabelWithAccessoryText:(NSString *)accessoryText {
    [self.inputLabel setAttributedFormatBlock:^NSAttributedString * (float value) {
        return [self attributedStringForSalaryAmount:value accessoryText:accessoryText];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - Layout

- (void)updateLayout {
    [self updateFieldAlignmentToAlignment:self.inputAlignment];
    [self updateAmountText:self.amount inputAccessoryText:self.inputAccessoryText subText:self.subtitleText];
}

- (void)updateFieldAlignmentToAlignment:(WorthMoneyTextViewAlignment)alignment {
    NSTextAlignment textAlignment = (alignment == WorthMoneyTextViewAlignmentLeft || WorthMoneyTextViewAlignmentNone) ? NSTextAlignmentLeft : NSTextAlignmentRight;
    self.subTitleLabel.textAlignment = textAlignment;
    self.inputTextField.textAlignment = textAlignment;
    self.inputLabel.textAlignment = textAlignment;
}

- (void)updateAmountText:(NSNumber *)amount inputAccessoryText:(NSString *)accessoryText subText:(NSString *)subText {
    [self.inputLabel countFromCurrentValueTo:[amount floatValue] withDuration:kMoneyTextViewCountAnimationDefaultLength];
    [self.subTitleLabel setText:subText];
}

- (NSAttributedString *)attributedStringForSalaryAmount:(CGFloat)value accessoryText:(NSString *)accessoryText{
    NSString *amountString = [NSString stringWithFormat:@"$%@", [self.numberFormatter stringFromNumber:@(value)]];
    NSDictionary *amountAttributes = @{ NSFontAttributeName: [UIFont worth_regularFontWithSize:kMoneyTextViewTextFontSize] };
    NSDictionary *accessoryAttributes = @{ NSFontAttributeName: [UIFont worth_lightFontWithSize:kMoneyTextViewSubTextFontSize] };
    NSMutableAttributedString *attributedAmountString = [[NSMutableAttributedString alloc] initWithString:amountString attributes:amountAttributes];
    if (accessoryText.length > 0) {
        accessoryText = [NSString stringWithFormat:@" %@", accessoryText];
        NSAttributedString *attributedAccessoryString = [[NSAttributedString alloc] initWithString:accessoryText attributes:accessoryAttributes];
        [attributedAmountString appendAttributedString:attributedAccessoryString];
    }
    return attributedAmountString;
}

#pragma mark - Public

- (void)setEditing:(BOOL)editing {
    self.inputTextField.enabled = editing;
    self.inputTextField.userInteractionEnabled = editing;
    self.inputTextField.hidden = !editing;
    self.inputTextField.attributedText = [self attributedStringForSalaryAmount:[self.amount floatValue] accessoryText:nil];
    self.inputLabel.hidden = editing;
}

- (void)setInputAlignment:(WorthMoneyTextViewAlignment)inputAlignment {
    if (_inputAlignment != inputAlignment) {
        _inputAlignment = inputAlignment;
        [self updateFieldAlignmentToAlignment:self.inputAlignment];
    }
}

- (void)setAmount:(NSNumber *)amount {
    if ([_amount floatValue] != [amount floatValue]) {
        _amount = amount;
        [self updateLayout];
    }
}

- (void)setInputAccessoryText:(NSString *)inputAccessoryText {
    if ([_inputAccessoryText isEqualToString:inputAccessoryText] == NO) {
        _inputAccessoryText = inputAccessoryText;
        [self configureInputLabelWithAccessoryText:_inputAccessoryText];
    }
}

- (void)setSubtitleText:(NSString *)subtitleText {
    if ([_subtitleText isEqualToString:subtitleText] == NO) {
        _subtitleText = subtitleText;
        [self updateLayout];
    }
}

#pragma mark - Animations

- (void)animateIntoView:(BOOL)animated {
    CGFloat indentation = floorf(self.bounds.size.width * kMoneyTextViewAlignmentIndentation);
    CGFloat width = self.bounds.size.width;
    CGFloat leftFinalIndent = (self.inputAlignment == WorthMoneyTextViewAlignmentLeft) ? kMoneyTextViewDefaultIndentation : -indentation;
    CGFloat leftStartIndent = (self.inputAlignment == WorthMoneyTextViewAlignmentLeft) ? kMoneyTextViewDefaultIndentation : -width;
    CGFloat rightFinalIndent = (self.inputAlignment == WorthMoneyTextViewAlignmentRight) ? kMoneyTextViewDefaultIndentation : indentation;
    CGFloat rightStartIndent = (self.inputAlignment == WorthMoneyTextViewAlignmentRight) ? kMoneyTextViewDefaultIndentation : width;
    
    self.inputTextFieldLeadingConstraint.constant = leftStartIndent;
    self.inputTextFieldTrailingConstraint.constant = rightStartIndent;
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:(animated) ? 0.5f : 0 animations:^{
        self.inputTextFieldLeadingConstraint.constant = (self.inputAlignment == WorthMoneyTextViewAlignmentLeft) ? kMoneyTextViewDefaultIndentation : leftFinalIndent;
        self.inputTextFieldTrailingConstraint.constant = (self.inputAlignment == WorthMoneyTextViewAlignmentRight) ? kMoneyTextViewDefaultIndentation : rightFinalIndent;
        [self layoutIfNeeded];
    }];
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *unattributedString = [textField.attributedText string];
    NSString *tempNewString = [unattributedString stringByReplacingCharactersInRange:range withString:string];
    tempNewString = [tempNewString stringByStrippingCurrencySymbols];
    tempNewString = [tempNewString stringByReplacingOccurrencesOfString:self.inputAccessoryText withString:@""];
    NSInteger newValue = [tempNewString integerValue];
    
    if ([tempNewString length] == 0 || newValue == 0) {
        textField.attributedText = [self attributedStringForSalaryAmount:0 accessoryText:nil];
    } else if ([tempNewString length] > self.numberFormatter.maximumIntegerDigits) {
        textField.attributedText = textField.attributedText;
    } else {
        NSNumber *newAmount = @((newValue / 100.0f));
        textField.attributedText = [self attributedStringForSalaryAmount:[newAmount floatValue] accessoryText:nil];
        [self setAmount:newAmount];
    }
    return NO;
}

#pragma mark - Helpers

- (NSNumberFormatter *)numberFormatter {
    if (_numberFormatter == nil) {
        _numberFormatter = [NSNumberFormatter new];
        [_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [_numberFormatter setMaximumFractionDigits:kMoneyTextViewDefaultDecimalPlaces];
        [_numberFormatter setMinimumFractionDigits:kMoneyTextViewDefaultDecimalPlaces];
    }
    return _numberFormatter;
}

#pragma mark - UIView

- (BOOL)becomeFirstResponder {
    return [self.inputTextField becomeFirstResponder];
}

@end
