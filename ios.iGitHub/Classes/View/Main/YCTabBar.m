//
//  YCTabBar.m
//  ios.iGitHub
//
//  Created by yangc on 16-3-28.
//  Copyright (c) 2016年 yangc. All rights reserved.
//

#import "YCTabBar.h"

@interface YCTabBar ()

@property (nonatomic, weak) YCTabBarButton *selectedButton;

@end

@implementation YCTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat width = self.frame.size.width / self.subviews.count;
    CGFloat height = self.frame.size.height;
    for (int i = 0; i < self.subviews.count; i++) {
        YCTabBarButton *button = (YCTabBarButton *) self.subviews[i];
        button.frame = CGRectMake(i * width, 2, width, height);
        button.tag = i;
    }
}

- (void)addTabBarItem:(UITabBarItem *)tabBarItem {
    YCTabBarButton *button = [YCTabBarButton buttonWithType:UIButtonTypeCustom];
    button.tabBarItem = tabBarItem;
    [button addTarget:self action:@selector(clickTabBarButton:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:button];

    if (self.subviews.count == 1) {
        [self clickTabBarButton:button];
    }
}

- (void)clickTabBarButton:(YCTabBarButton *)button {
    if ([self.delegate respondsToSelector:@selector(tabBar:didClickTabBarButtonFrom:to:)]) {
        [self.delegate tabBar:self didClickTabBarButtonFrom:self.selectedButton.tag to:button.tag];
    }
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}

@end
