//
//  UITextViewWithPlaceholder.m
//  ios_utils
//
//  Created by yangc on 16-5-3.
//  Copyright (c) 2016年 yangc. All rights reserved.
//

#import "UITextViewWithPlaceholder.h"

@interface UITextViewWithPlaceholder ()

@property (nonatomic, weak) UILabel *placeholderView;

@end

@implementation UITextViewWithPlaceholder

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *placeholderView = [[UILabel alloc] init];
        placeholderView.textColor = [UIColor lightGrayColor];
        placeholderView.font = self.font;
        placeholderView.numberOfLines = 0;
        [self addSubview:placeholderView];
        self.placeholderView = placeholderView;

        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChangeNotification) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textViewTextDidChangeNotification {
    self.placeholderView.hidden = self.text.length;
}

#pragma mark - 文本
- (NSString *)placeholderText {
    return self.placeholderView.text;
}

- (void)setPlaceholderText:(NSString *)placeholderText {
    self.placeholderView.text = placeholderText;
}

#pragma mark - 颜色
- (UIColor *)placeholderColor {
    return self.placeholderView.textColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    self.placeholderView.textColor = placeholderColor;
}

#pragma mark - 字体
- (UIFont *)placeholderFont {
    return self.placeholderView.font;
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    self.placeholderView.font = placeholderFont;
}

@end
