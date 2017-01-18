//
//  YCBadgeButton.m
//  ios.iGitHub
//
//  Created by yangc on 16-3-29.
//  Copyright (c) 2016年 yangc. All rights reserved.
//

#import <YCHelpKit/NSString+Category.h>
#import <YCHelpKit/UIImage+Category.h>

#import "YCBadgeButton.h"

@implementation YCBadgeButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES;
        self.userInteractionEnabled = NO;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setBackgroundImage:[UIImage imageNamedForResize:@"main_badge"] forState:UIControlStateNormal];
    }
    return self;
}

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    if (self.badgeValue) {
        CGSize size = [self.badgeValue sizeWithFont:self.titleLabel.font size:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        CGRect frame = self.frame;
        frame.size = CGSizeMake(size.width + 12, size.height + 5);
        self.frame = frame;
        [self setTitle:self.badgeValue forState:UIControlStateNormal];
        self.hidden = NO;
    } else {
        self.hidden = YES;
    }
}

@end
