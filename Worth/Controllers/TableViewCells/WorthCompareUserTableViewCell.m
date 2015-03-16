//
//  WorthCompareUserTableViewCell.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "WorthCompareUserTableViewCell.h"
#import "WorthRoundAvatarImageView.h"
#import "WorthUser+UserGenerated.h"
#import "UIColor+WorthStyle.h"
#import "UIFont+WorthStyle.h"

@interface WorthCompareUserTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *salaryLabel;
@property (weak, nonatomic) IBOutlet WorthRoundAvatarImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (strong, nonatomic) WorthUser *user;

@end

@implementation WorthCompareUserTableViewCell

- (void)awakeFromNib {
    [self commonInit];
    [self updateLayout];
}

- (void)commonInit {
    [self.nameLabel setFont:[UIFont worth_mediumFontWithSize:17.0f]];
    [self.salaryLabel setFont:[UIFont worth_regularFontWithSize:17.0f]];
    [self.nameLabel setTextColor:[UIColor whiteColor]];
    [self.salaryLabel setTextColor:[UIColor worth_darkGreenColor]];
}

- (void)updateLayout {
    BOOL isSelfContent = (self.contentMode == WorthCompareUserTableCellContentModeSelf);
    self.favoriteButton.hidden = isSelfContent;
    
    UIColor *backgroundColor = (isSelfContent) ? [UIColor worth_lightGreenColor] : [UIColor worth_greenColor];
    [self setBackgroundColor:backgroundColor];
    
    static NSNumberFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    self.nameLabel.text = self.user.name;
    self.salaryLabel.text = [NSString stringWithFormat:@"%@ /year", [formatter stringFromNumber:self.user.salary]];
    [self.favoriteButton setSelected:[self.user.favorited boolValue]];
}

#pragma mark - Public

- (void)setContentMode:(WorthCompareUserTableCellContentMode)contentMode {
    if (_contentMode != contentMode) {
        _contentMode = contentMode;
        [self updateLayout];
    }
}

- (void)configureWithUser:(WorthUser *)user {
    self.user = user;
    [self updateLayout];
}

+ (CGFloat)preferredHeight {
    return 78.0f;
}

#pragma mark - Button Event Methods

- (IBAction)favoriteButtonTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(compareUserTableViewCell:didTapFavoriteButton:)]) {
        [self.delegate compareUserTableViewCell:self didTapFavoriteButton:sender];
    }
}

@end
