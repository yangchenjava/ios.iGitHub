//
//  YCUserAccessButton.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/6.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import "YCUserAccessButton.h"

#define kTitleHeight 30
#define kMargin 20

@implementation YCUserAccessButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.adjustsImageWhenHighlighted = NO;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat x = kMargin;
    CGFloat y = kMargin;
    CGFloat width = contentRect.size.width - 2 * kMargin;
    CGFloat height = contentRect.size.height - kTitleHeight - 2 * kMargin;
    return CGRectMake(x, y, width, height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat x = kMargin;
    CGFloat y = contentRect.size.height - kMargin - kTitleHeight;
    CGFloat width = contentRect.size.width - 2 * kMargin;
    CGFloat height = kTitleHeight;
    return CGRectMake(x, y, width, height);
}

@end
