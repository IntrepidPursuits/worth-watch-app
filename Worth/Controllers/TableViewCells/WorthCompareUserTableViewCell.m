//
//  WorthCompareUserTableViewCell.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/14/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "WorthCompareUserTableViewCell.h"
#import "WorthRoundAvatarImageView.h"
#import "UIColor+WorthStyle.h"
#import "UIFont+WorthStyle.h"

@interface WorthCompareUserTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *salaryLabel;
@property (weak, nonatomic) IBOutlet WorthRoundAvatarImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

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
    self.salaryLabel.text = [NSString stringWithFormat:@"%@ /year", [formatter stringFromNumber:self.salary]];
}

#pragma mark - Public

- (void)setContentMode:(WorthCompareUserTableCellContentMode)contentMode {
    if (_contentMode != contentMode) {
        _contentMode = contentMode;
        [self updateLayout];
    }
}

- (void)setSalary:(NSNumber *)salary {
    if ([_salary doubleValue] != [salary doubleValue]) {
        _salary = salary;
        [self updateLayout];
    }
}

#pragma mark - Button Event Methods

- (IBAction)favoriteButtonTapped:(id)sender {
    UIButton *button = (UIButton *)sender;
    [button setSelected:!button.selected];
}


@end
