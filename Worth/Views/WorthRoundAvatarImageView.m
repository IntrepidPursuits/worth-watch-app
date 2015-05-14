//
//  WorthRoundAvatarImageView.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/15/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "WorthRoundAvatarImageView.h"
#import "UIImage+WorthStyle.h"
#import "UIColor+WorthStyle.h"

@implementation WorthRoundAvatarImageView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)awakeFromNib {
    [self configure];
}

#pragma mark - Configure

- (void)configure {
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.layer.masksToBounds = YES;
    self.image = nil;
    self.backgroundColor = [UIColor worth_greenColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = CGRectGetWidth(self.bounds) / 2.0f;
}

@end