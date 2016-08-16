//
//  UIImage+Category.h
//  ios_utils
//
//  Created by yangc on 16-1-28.
//  Copyright (c) 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)

/**
 * 图片拉伸
 */
+ (instancetype)imageNamedForResize:(NSString *)name;

/**
 * 颜色图片
 */
+ (instancetype)imageWithColor:(UIColor *)color;

/**
 * 圆形图片
 */
- (instancetype)imageWithCircle:(CGSize)size;
- (instancetype)imageWithCircle:(CGSize)size borderWidth:(CGFloat)borderWidth;
- (instancetype)imageWithCircle:(CGSize)size borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 * 圆角图片
 */
- (instancetype)imageWithRoundRect:(CGSize)size radius:(CGFloat)radius;
- (instancetype)imageWithRoundRect:(CGSize)size radius:(CGFloat)radius borderWidth:(CGFloat)borderWidth;
- (instancetype)imageWithRoundRect:(CGSize)size radius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 *  改变图片颜色(非渐变)
 */
- (instancetype)imageWithTintColor:(UIColor *)tintColor;

/**
 *  改变图片颜色(含渐变，灰色无效)
 */
- (instancetype)imageWithGradientTintColor:(UIColor *)tintColor;

/**
 *  根据CGBlendMode改变图片颜色
 */
- (instancetype)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;

@end
