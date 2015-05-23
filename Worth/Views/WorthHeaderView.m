//
//  WorthHeaderView.m
//  Worth
//
//  Created by Patrick Butkiewicz on 5/8/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "WorthHeaderView.h"
#import "WorthRoundAvatarImageView.h"
#import "UIColor+WorthStyle.h"

@interface WorthHeaderView()

@property (strong, nonatomic) UIView *nibView;
@property (weak, nonatomic) IBOutlet UIView *imageContainerView;
@property (weak, nonatomic) IBOutlet WorthRoundAvatarImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *infoContainerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *accessoryButton;
@property (nonatomic) WorthHeaderViewAccessoryButtonType accessoryButtonType;
@end

@implementation WorthHeaderView

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
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (void)commonInit {
    [self.nibView setBackgroundColor:[UIColor clearColor]];
    [self.imageContainerView setBackgroundColor:[UIColor worth_MainPhotoAreaColor]];
    [self.imageView setBackgroundColor:[UIColor worth_Section2PhotoColor]];
    [self.infoContainerView setBackgroundColor:[UIColor worth_blumineColor]];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.subTitleLabel setTextColor:[UIColor whiteColor]];
}

- (void)updateLayout {
    switch (self.accessoryButtonType) {
        case WorthHeaderViewAccessoryButtonTypeNone: {
            self.accessoryButton.hidden = YES;
        }
            break;
        case WorthHeaderViewAccessoryButtonTypePlus: {
            self.accessoryButton.hidden = NO;
            [self.accessoryButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
            [self.accessoryButton.imageView setImage:[UIImage imageNamed:@"add"]];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Button Events

- (IBAction)accessoryButtonTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(worthHeaderView:didTapAccessoryButton:)]) {
        [self.delegate worthHeaderView:self didTapAccessoryButton:sender];
    }
}

#pragma mark - Public

- (void)setAccessoryType:(WorthHeaderViewAccessoryButtonType)type {
    if (type != self.accessoryButtonType) {
        _accessoryButtonType = type;
        [self updateLayout];
    }
}

- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle {
    self.titleLabel.text = title;
    self.subTitleLabel.text = subTitle;
}

- (void)setImageContainerBackgroundColor:(UIColor *)color {
    [self.imageContainerView setBackgroundColor:color];
}

- (void)setInformationContainerBackgroundColor:(UIColor *)color {
    [self.infoContainerView setBackgroundColor:color];
}

@end
