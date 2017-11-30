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

@interface YCTrendingLanguageButton ()

@end

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
        // 适配iOS11
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (BOOL)isHighlighted {
    return NO;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    
    CGFloat width = [title sizeWithFont:[UIFont systemFontOfSize:20] size:CGSizeMake(MAXFLOAT, YC_NavigationBarHeight)].width + 5;
    self.frame = CGRectMake(0, 0, width + kImageWidth, YC_NavigationBarHeight);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, width, 0, -width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -kImageWidth, 0, kImageWidth);
}

@end
