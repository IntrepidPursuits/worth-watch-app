//
//  WorthUserView.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/15/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "WorthUserView.h"
#import "WorthRoundAvatarImageView.h"
#import "WorthUser.h"
#import "UIColor+WorthStyle.h"
#import "UIImage+WorthStyle.h"
#import "UIFont+WorthStyle.h"

@interface WorthUserView()

@property (strong, nonatomic) UIView *nibView;
@property (strong, nonatomic) WorthUser *user;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet WorthRoundAvatarImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *salaryLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation WorthUserView

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
    [self commonInit];
}

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    self.nibView.backgroundColor = [UIColor clearColor];
    [self.nameLabel setFont:[UIFont worth_mediumFontWithSize:17.0f]];
    [self.salaryLabel setFont:[UIFont worth_regularFontWithSize:17.0f]];
    [self.nameLabel setTextColor:[UIColor whiteColor]];
    [self.salaryLabel setTextColor:[UIColor worth_darkGreenColor]];
}

- (void)updateLayout {
    BOOL isSelfContent = (self.contentMode == WorthUserViewContentModeSelf);
    self.favoriteButton.hidden = isSelfContent;
    
    static NSNumberFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    self.nameLabel.text = [self.user name];
    self.salaryLabel.text = [NSString stringWithFormat:@"%@ /year", [formatter stringFromNumber:self.user.salary]];
}

#pragma mark - Button Event Methods

- (IBAction)favoriteButtonTapped:(id)sender {
    UIButton *button = (UIButton *)sender;
    [button setSelected:!button.selected];
}

#pragma mark - Public

- (void)configureWithUser:(WorthUser *)user {
    self.user = user;
    [self updateLayout];
}

- (void)setContentMode:(WorthUserViewContentMode)contentMode {
    _contentMode = contentMode;
    [self updateLayout];
}

@end
