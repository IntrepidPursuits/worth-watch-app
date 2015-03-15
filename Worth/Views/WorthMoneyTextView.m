//
//  WorthMoneyTextView.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "WorthMoneyTextView.h"
#import "UIFont+WorthStyle.h"
#import <UICountingLabel/UICountingLabel.h>

static CGFloat kMoneyTextViewAlignmentIndentation = 0.25f;
static CGFloat kMoneyTextViewDefaultIndentation = 0.0f;
static CGFloat kMoneyTextViewSubTextFontSize = 14.0f;
static CGFloat kMoneyTextViewTextFontSize = 24.0f;
static CGFloat kMoneyTextViewCountAnimationDefaultLength = 1.0f;
static NSUInteger kMoneyTextViewDefaultDecimalPlaces = 6;

@interface WorthMoneyTextView()

@property (strong, nonatomic) UIView *nibView;
@property (weak, nonatomic) IBOutlet UICountingLabel *inputLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputTextFieldLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputTextFieldTrailingConstraint;
@property (strong, nonatomic) NSNumberFormatter *inputFormatter;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation WorthMoneyTextView
@synthesize amount = _amount;
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
    [self.inputTextField setUserInteractionEnabled:NO];
    [self.inputTextField setHidden:YES];
    
    [self configureInputLabelWithDecimalPlaces:self.decimalPlaces accessoryText:self.inputAccessoryText];
    [self setDecimalPlaces:kMoneyTextViewDefaultDecimalPlaces];
    [self updateLayout];
}

- (void)configureInputLabelWithDecimalPlaces:(NSUInteger)decimals accessoryText:(NSString *)accessoryText {
    NSString *formatString = [NSString stringWithFormat:@"$%%.0%luf %@", (unsigned long)decimals, (accessoryText.length) ? accessoryText : @""];
    [self.inputLabel setFormat:formatString];
    [self.inputLabel setMethod:UILabelCountingMethodLinear];
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

#pragma mark - Public

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
        [self configureInputLabelWithDecimalPlaces:self.decimalPlaces accessoryText:_inputAccessoryText];
    }
}

- (void)setSubtitleText:(NSString *)subtitleText {
    if ([_subtitleText isEqualToString:subtitleText] == NO) {
        _subtitleText = subtitleText;
        [self updateLayout];
    }
}

- (void)setDecimalPlaces:(NSUInteger)decimalPlaces {
    if (_decimalPlaces != decimalPlaces) {
        _decimalPlaces = decimalPlaces;
        [self configureInputLabelWithDecimalPlaces:_decimalPlaces accessoryText:self.inputAccessoryText];
        [self updateLayout];
    }
}

#pragma mark - Animations

- (void)animateIntoView:(BOOL)animated {
    CGFloat indentation = (self.bounds.size.width * kMoneyTextViewAlignmentIndentation);
    CGFloat width = self.bounds.size.width;
    CGFloat leftIndent = (self.inputAlignment == WorthMoneyTextViewAlignmentLeft) ? kMoneyTextViewDefaultIndentation : -indentation;
    CGFloat rightIndent = (self.inputAlignment == WorthMoneyTextViewAlignmentRight) ? kMoneyTextViewDefaultIndentation : indentation;
    
    self.inputTextFieldLeadingConstraint.constant = (self.inputAlignment == WorthMoneyTextViewAlignmentLeft) ? 0 : -width;
    self.inputTextFieldTrailingConstraint.constant = (self.inputAlignment == WorthMoneyTextViewAlignmentRight) ? 0 : width;
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:(animated) ? 0.4f : 0 animations:^{
        self.inputTextFieldLeadingConstraint.constant = (self.inputAlignment == WorthMoneyTextViewAlignmentLeft) ? kMoneyTextViewDefaultIndentation : leftIndent;
        self.inputTextFieldTrailingConstraint.constant = (self.inputAlignment == WorthMoneyTextViewAlignmentRight) ? kMoneyTextViewDefaultIndentation : rightIndent;
        [self layoutIfNeeded];
    }];
}

@end
