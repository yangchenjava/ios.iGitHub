//
//  UIBarButtonItem+Category.h
//  ios_utils
//
//  Created by yangc on 16-3-31.
//  Copyright (c) 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Category)

+ (instancetype)barButtonItemWithSize:(CGSize)size imageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)action;

+ (instancetype)barButtonItemWithSize:(CGSize)size title:(NSString *)title font:(UIFont *)font color:(UIColor *)color highlightedColor:(UIColor *)highlightedColor target:(id)target action:(SEL)action;

+ (instancetype)barButtonItemWithSize:(CGSize)size
                                title:(NSString *)title
                                 font:(UIFont *)font
                                color:(UIColor *)color
                     highlightedColor:(UIColor *)highlightedColor
                        disabledColor:(UIColor *)disabledColor
                               target:(id)target
                               action:(SEL)action;

@end
