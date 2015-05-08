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

@end

@implementation WorthHeaderView

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
    [self.imageContainerView setBackgroundColor:[UIColor worth_darkerGreenColor]];
    [self.imageView setBackgroundColor:[UIColor worth_greenColor]];
    [self.infoContainerView setBackgroundColor:[UIColor worth_darkGreenColor]];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.subTitleLabel setTextColor:[UIColor whiteColor]];
}

@end
