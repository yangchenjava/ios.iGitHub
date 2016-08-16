//
//  UIBarButtonItem+Category.m
//  ios_utils
//
//  Created by yangc on 16-3-31.
//  Copyright (c) 2016年 yangc. All rights reserved.
//

#import "UIBarButtonItem+Category.h"

@implementation UIBarButtonItem (Category)

+ (instancetype)barButtonItemWithSize:(CGSize)size imageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = (CGRect){CGPointZero, size};
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (instancetype)barButtonItemWithSize:(CGSize)size
                                title:(NSString *)title
                                 font:(UIFont *)font
                                color:(UIColor *)color
                     highlightedColor:(UIColor *)highlightedColor
                               target:(id)target
                               action:(SEL)action {
    return [self barButtonItemWithSize:size title:title font:font color:color highlightedColor:highlightedColor disabledColor:[UIColor lightGrayColor] target:target action:action];
}

+ (instancetype)barButtonItemWithSize:(CGSize)size
                                title:(NSString *)title
                                 font:(UIFont *)font
                                color:(UIColor *)color
                     highlightedColor:(UIColor *)highlightedColor
                        disabledColor:(UIColor *)disabledColor
                               target:(id)target
                               action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = (CGRect){CGPointZero, size};
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:highlightedColor forState:UIControlStateHighlighted];
    [button setTitleColor:disabledColor forState:UIControlStateDisabled];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
