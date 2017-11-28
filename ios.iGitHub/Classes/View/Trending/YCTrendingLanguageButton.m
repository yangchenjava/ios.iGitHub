//
//  YCTrendingLanguageButton.m
//  ios.iGitHub
//
//  Created by 杨晨 on 2017/11/25.
//  Copyright © 2017年 yangc. All rights reserved.
//

#import <FontAwesomeKit/FontAwesomeKit.h>
#import <YCHelpKit/NSString+Category.h>

#import "YCTrendingLanguageButton.h"

// 按钮中图文比例
#define kImageWidth 15

@implementation YCTrendingLanguageButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        FAKOcticons *triangleDownIcon = [FAKOcticons triangleDownIconWithSize:kImageWidth];
        [triangleDownIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        
        [self setImage:[triangleDownIcon imageWithSize:CGSizeMake(kImageWidth, kImageWidth)] forState:UIControlStateNormal];
        self.imageView.contentMode = UIViewContentModeCenter;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:20];
    }
    return self;
}

- (BOOL)isHighlighted {
    return NO;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    CGFloat width = [title sizeWithFont:self.titleLabel.font size:CGSizeMake(MAXFLOAT, YC_NavigationBarHeight)].width;
    YCLog(@"%f", width);
    self.bounds = CGRectMake(0, 0, width + 5 + kImageWidth, YC_NavigationBarHeight);
}

// 布局按钮上的图片
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat x = contentRect.size.width - kImageWidth;
    CGFloat y = 0;
    CGFloat width = kImageWidth;
    CGFloat height = contentRect.size.height;
    return CGRectMake(x, y, width, height);
}

// 布局按钮上的文字
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = contentRect.size.width - 4 - kImageWidth;
    CGFloat height = contentRect.size.height;
    return CGRectMake(x, y, width, height);
}

@end
