//
//  YCProfileTableFooterView.m
//  ios.iGitHub
//
//  Created by yangc on 17/1/24.
//  Copyright © 2017年 yangc. All rights reserved.
//

#import <YCHelpKit/UIImage+Category.h>
#import <YCHelpKit/UIView+Category.h>

#import "YCProfileTableFooterView.h"

@implementation YCProfileTableFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = YC_Color_RGB(200, 199, 204);
        [self setupButton];
    }
    return self;
}

- (void)setupButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.x, self.y + 0.5, self.width, self.height - 1);
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitle:@"注销" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:YC_Color_RGB(217, 217, 217)] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)clickButton {
    if ([_delegate respondsToSelector:@selector(tableFooterViewDidClick:)]) {
        [_delegate tableFooterViewDidClick:self];
    }
}

@end
