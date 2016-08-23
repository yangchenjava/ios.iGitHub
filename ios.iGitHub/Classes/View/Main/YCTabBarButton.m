//
//  YCTabBarButton.m
//  ios.iGitHub
//
//  Created by yangc on 16-3-28.
//  Copyright (c) 2016年 yangc. All rights reserved.
//

#import "YCBadgeButton.h"
#import "YCTabBarButton.h"

// 按钮中图文比例
#define kImageHeightScale 0.6

@interface YCTabBarButton ()

@property (nonatomic, weak) YCBadgeButton *badgeButton;

@end

@implementation YCTabBarButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        [self setTitleColor:YC_Color_RGB(130, 130, 130) forState:UIControlStateNormal];
        [self setTitleColor:YC_Color_RGB(50, 50, 50) forState:UIControlStateSelected];

        YCBadgeButton *badgeButton = [YCBadgeButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:badgeButton];
        self.badgeButton = badgeButton;
    }
    return self;
}

- (BOOL)isHighlighted {
    return NO;
}

// 布局按钮上的图片
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = contentRect.size.width;
    CGFloat height = contentRect.size.height * kImageHeightScale;
    return CGRectMake(x, y, width, height);
}

// 布局按钮上的文字
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat x = 0;
    CGFloat y = contentRect.size.height * kImageHeightScale;
    CGFloat width = contentRect.size.width;
    CGFloat height = contentRect.size.height - y;
    return CGRectMake(x, y, width, height);
}

// 设置未读数量按钮位置
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat x = self.frame.size.width * 0.5;
    CGFloat y = 0;
    CGRect frame = self.badgeButton.frame;
    frame.origin = CGPointMake(x, y);
    self.badgeButton.frame = frame;
}

// 记得移除KVO
- (void)dealloc {
    [self.badgeButton removeObserver:self forKeyPath:@"title"];
    [self.badgeButton removeObserver:self forKeyPath:@"image"];
    [self.badgeButton removeObserver:self forKeyPath:@"selectedImage"];
    [self.badgeButton removeObserver:self forKeyPath:@"badgeValue"];
}

- (void)setTabBarItem:(UITabBarItem *)tabBarItem {
    _tabBarItem = tabBarItem;
    [self setTitle:self.tabBarItem.title forState:UIControlStateNormal];
    [self setImage:self.tabBarItem.image forState:UIControlStateNormal];
    [self setImage:self.tabBarItem.selectedImage forState:UIControlStateSelected];
    self.badgeButton.badgeValue = self.tabBarItem.badgeValue;

    [self.tabBarItem addObserver:self forKeyPath:@"title" options:0 context:nil];
    [self.tabBarItem addObserver:self forKeyPath:@"image" options:0 context:nil];
    [self.tabBarItem addObserver:self forKeyPath:@"selectedImage" options:0 context:nil];
    [self.tabBarItem addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];
}

// KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"title"]) {
        [self setTitle:self.tabBarItem.title forState:UIControlStateNormal];
    } else if ([keyPath isEqualToString:@"image"]) {
        [self setImage:self.tabBarItem.image forState:UIControlStateNormal];
    } else if ([keyPath isEqualToString:@"selectedImage"]) {
        [self setImage:self.tabBarItem.selectedImage forState:UIControlStateSelected];
    } else if ([keyPath isEqualToString:@"badgeValue"]) {
        self.badgeButton.badgeValue = self.tabBarItem.badgeValue;
    }
}

@end
