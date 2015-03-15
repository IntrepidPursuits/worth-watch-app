//
//  WorthMoneyTextView.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "WorthMoneyTextView.h"
#import "UIFont+WorthStyle.h"

static CGFloat kMoneyTextViewAlignmentIndentation = 0.25f;
static CGFloat kMoneyTextViewDefaultIndentation = 0.0f;
static CGFloat kMoneyTextViewSubTextFontSize = 14.0f;
static CGFloat kMoneyTextViewTextFontSize = 24.0f;

@interface WorthMoneyTextView()

@property (strong, nonatomic) UIView *nibView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputTextFieldLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputTextFieldTrailingConstraint;

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
    [self updateLayout];
}

#pragma mark - Layout

- (void)updateLayout {
    [self updateFieldAlignmentToAlignment:self.inputAlignment];
    
    NSString *formattedAmountString = [self.inputFormatter stringFromNumber:self.amount];
    [self updateAmountText:formattedAmountString inputAccessoryText:self.inputAccessoryText subText:self.subtitleText];
}

- (void)updateFieldAlignmentToAlignment:(WorthMoneyTextViewAlignment)alignment {
    CGFloat indentation = (self.bounds.size.width * kMoneyTextViewAlignmentIndentation);
    CGFloat leftIndent = (alignment == WorthMoneyTextViewAlignmentLeft) ? kMoneyTextViewDefaultIndentation : -indentation;
    CGFloat rightIndent = (alignment == WorthMoneyTextViewAlignmentRight) ? kMoneyTextViewDefaultIndentation : indentation;
    
    NSTextAlignment textAlignment = (alignment == WorthMoneyTextViewAlignmentLeft || WorthMoneyTextViewAlignmentNone) ? NSTextAlignmentLeft : NSTextAlignmentRight;
    
    self.subTitleLabel.textAlignment = textAlignment;
    self.inputTextField.textAlignment = textAlignment;
    self.inputTextFieldLeadingConstraint.constant = (self.inputAlignment == WorthMoneyTextViewAlignmentNone) ? kMoneyTextViewDefaultIndentation : leftIndent;
    self.inputTextFieldTrailingConstraint.constant = (self.inputAlignment == WorthMoneyTextViewAlignmentNone) ? kMoneyTextViewDefaultIndentation : rightIndent;
}

- (void)updateAmountText:(NSString *)amount inputAccessoryText:(NSString *)accessoryText subText:(NSString *)subText {
    NSMutableAttributedString *attributedLabelString = [NSMutableAttributedString new];
    NSAttributedString *attributedAmountString = [[NSAttributedString alloc] initWithString:amount
                                                                                 attributes:@{
                                                                                              NSFontAttributeName : [UIFont worth_lightFontWithSize:kMoneyTextViewTextFontSize]
                                                                                              }];
    [attributedLabelString appendAttributedString:attributedAmountString];
    
    if (accessoryText) {
        NSAttributedString *attributedAccessoryString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", accessoryText]
                                                                                        attributes:@{
                                                                                                     NSFontAttributeName : [UIFont worth_regularFontWithSize:kMoneyTextViewSubTextFontSize]
                                                                                                     }];
        [attributedLabelString appendAttributedString:attributedAccessoryString];
    }
    
    [self.inputTextField setAttributedText:attributedLabelString];
    [self.subTitleLabel setText:subText];
}

#pragma mark - Public

- (void)setInputAlignment:(WorthMoneyTextViewAlignment)inputAlignment {
    if (_inputAlignment != inputAlignment) {
        _inputAlignment = inputAlignment;
        [self updateLayout];
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
        [self updateLayout];
    }
}

- (void)setSubtitleText:(NSString *)subtitleText {
    if ([_subtitleText isEqualToString:subtitleText] == NO) {
        _subtitleText = subtitleText;
        [self updateLayout];
    }
}

#pragma mark - Lazy

- (NSNumberFormatter *)inputFormatter {
    if (_inputFormatter == nil) {
        _inputFormatter = [NSNumberFormatter new];
        [_inputFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    return _inputFormatter;
}

- (NSNumber *)amount {
    if (_amount == nil) {
        _amount = @(0);
    }
    return _amount;
}

@end
