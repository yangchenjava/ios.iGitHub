//
//  YCTrendingLanguageButton.m
//  ios.iGitHub
//
//  Created by 杨晨 on 2017/11/25.
//  Copyright © 2017年 yangc. All rights reserved.
//

#import <FontAwesomeKit/FontAwesomeKit.h>

#import "YCTrendingLanguageButton.h"

// 按钮中图文比例
#define kTitleWidthScale 0.8

@implementation YCTrendingLanguageButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        FAKOcticons *triangleDownIcon = [FAKOcticons triangleDownIconWithSize:YC_NavigationBarHeight * 0.3];
        [triangleDownIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        
        [self setImage:[triangleDownIcon imageWithSize:CGSizeMake(YC_NavigationBarHeight * 0.3, YC_NavigationBarHeight * 0.3)] forState:UIControlStateNormal];
        self.imageView.contentMode = UIViewContentModeLeft;
        [self setTitle:@"All Languages" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        self.titleLabel.font = [UIFont systemFontOfSize:20];
    }
    return self;
}

- (BOOL)isHighlighted {
    return NO;
}

// 布局按钮上的图片
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat x = contentRect.size.width * kTitleWidthScale;
    CGFloat y = 0;
    CGFloat width = contentRect.size.width - x;
    CGFloat height = contentRect.size.height;
    return CGRectMake(x, y, width, height);
}

// 布局按钮上的文字
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = contentRect.size.width * kTitleWidthScale - 2;
    CGFloat height = contentRect.size.height;
    return CGRectMake(x, y, width, height);
}

@end
