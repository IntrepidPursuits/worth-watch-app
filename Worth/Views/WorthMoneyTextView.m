//
//  WorthMoneyTextView.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "WorthMoneyTextView.h"
#import "NSString+StripCurrencySymbols.h"
#import "NSString+TimeString.h"
#import "UIFont+WorthStyle.h"

static CGFloat kFramesPerSecond = 25.0f;
static NSUInteger kMoneyTextViewDefaultDecimalPlaces = 6;

@interface WorthMoneyTextView()

@property (strong, nonatomic) UIView *nibView;
@property (weak, nonatomic) IBOutlet UILabel *inputLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressViewTrailingConstraint;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *progressView;

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic) NSTimeInterval currentTime;

@end

@implementation WorthMoneyTextView
@synthesize inputAccessoryText = _inputAccessoryText;
@synthesize subtitleText = _subtitleText;

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.nibView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                      owner:self
                                                    options:nil] lastObject];
        [self addSubview:self.nibView];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bar]-0-|" options:0 metrics:nil views:@{@"bar" : self.nibView}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[bar]-0-|" options:0 metrics:nil views:@{@"bar" : self.nibView}]];
        self.nibView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

#pragma mark - Layout

- (void)updateLayout {
    [self updateAmountText:self.startAmount inputAccessoryText:self.inputAccessoryText subText:self.subtitleText];
}

- (void)updateAmountText:(NSNumber *)amount inputAccessoryText:(NSString *)accessoryText subText:(NSString *)subText {
    [self.inputLabel setText:[NSString stringWithFormat:@"$%@", [self.numberFormatter stringFromNumber:amount]]];
    [self.subTitleLabel setText:subText];
}

#pragma mark - Public

- (void)start {
    [self startWithTime:CACurrentMediaTime()];
}

- (void)startWithTime:(CFTimeInterval)time {
    self.startTime = time;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        self.currentTime = CACurrentMediaTime();
        NSTimeInterval elapsedTime = self.currentTime - self.startTime;
        CGFloat newAmount = ([self.startAmount floatValue] + (self.dollarsPerSecond * elapsedTime));
        [self.inputLabel setText:[NSString stringWithFormat:@"$%@", [self.numberFormatter stringFromNumber:@(newAmount)]]];
        
        if (self.displaysTimer) {
            NSString *timeString = [NSString timeStringFromSecond:elapsedTime];
            NSString *earnedString = [NSString stringWithFormat:@"In last %@", timeString];
            self.subTitleLabel.text = earnedString;
        }
    }];
    
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0f / kFramesPerSecond)
                                                  target:operation
                                                selector:@selector(main)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)setEditing:(BOOL)editing {
    self.inputLabel.hidden = editing;
}

- (void)setStartAmount:(NSNumber *)startAmount{
    if ([_startAmount floatValue] != [startAmount floatValue]) {
        _startAmount = startAmount;
        [self updateLayout];
    }
}

- (void)setSubtitleText:(NSString *)subtitleText {
    if ([_subtitleText isEqualToString:subtitleText] == NO) {
        _subtitleText = subtitleText;
        [self updateLayout];
    }
}

#pragma mark - Animations

- (void)animateIntoViewWithProgress:(CGFloat)progress animated:(BOOL)animated {
    CGFloat animationDuration = ((animated) ? 0.5f : 0);
    CGFloat width = self.bounds.size.width;
    CGFloat adjustedProgress = MAX(MIN(progress, 1), 0);
    CGFloat progressWidth = (width * adjustedProgress);
    CGFloat trailingSpace = (width - progressWidth);

    self.progressViewTrailingConstraint.constant = width;
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.progressViewTrailingConstraint.constant = trailingSpace;
        [self layoutIfNeeded];
    }];
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

@end
