//
//  UIImage+Category.m
//  ios_utils
//
//  Created by yangc on 16-1-28.
//  Copyright (c) 2016年 yangc. All rights reserved.
//

#import "UIImage+Category.h"

@implementation UIImage (Category)

/**
 * 图片拉伸
 */
+ (instancetype)imageNamedForResize:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
    CGFloat w = image.size.width * 0.5;
    CGFloat h = image.size.height * 0.5;
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
}

/**
 * 颜色图片
 */
+ (instancetype)imageWithColor:(UIColor *)color {
    CGFloat width = 1, height = 1;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [color set];
    UIRectFill(CGRectMake(0, 0, width, height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 * 圆形图片
 */
- (instancetype)imageWithCircle:(CGSize)size {
    return [self imageWithCircle:size borderWidth:5];
}

- (instancetype)imageWithCircle:(CGSize)size borderWidth:(CGFloat)borderWidth {
    return [self imageWithCircle:size borderWidth:borderWidth borderColor:[UIColor whiteColor]];
}

- (instancetype)imageWithCircle:(CGSize)size borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    CGSize newSize = CGSizeMake(size.width + 2 * borderWidth, size.height + 2 * borderWidth);

    UIGraphicsBeginImageContext(newSize);
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    // 画边框
    [borderColor set];
    CGContextAddArc(ctx, newSize.width * 0.5, newSize.height * 0.5, newSize.width * 0.5, 0, M_PI * 2, 0);
    CGContextFillPath(ctx);

    // 画圆
    CGContextAddArc(ctx, newSize.width * 0.5, newSize.height * 0.5, size.width * 0.5, 0, M_PI * 2, 0);
    // 剪裁(后面画的才会受影响)
    CGContextClip(ctx);
    [self drawInRect:(CGRect){CGPointMake(borderWidth, borderWidth), size}];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 * 圆角图片
 */
- (instancetype)imageWithRoundRect:(CGSize)size radius:(CGFloat)radius {
    return [self imageWithRoundRect:size radius:radius borderWidth:5];
}

- (instancetype)imageWithRoundRect:(CGSize)size radius:(CGFloat)radius borderWidth:(CGFloat)borderWidth {
    return [self imageWithRoundRect:size radius:radius borderWidth:borderWidth borderColor:[UIColor whiteColor]];
}

- (instancetype)imageWithRoundRect:(CGSize)size radius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    CGSize newSize = CGSizeMake(size.width + 2 * borderWidth, size.height + 2 * borderWidth);
    CGFloat newRadius = radius + borderWidth;

    UIGraphicsBeginImageContext(newSize);
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    // 画边框
    [borderColor set];
    CGContextAddArc(ctx, newRadius, newRadius, newRadius, -M_PI, -M_PI_2, 0);
    CGContextAddArc(ctx, newSize.width - newRadius, newRadius, newRadius, -M_PI_2, 0, 0);
    CGContextAddArc(ctx, newSize.width - newRadius, newSize.height - newRadius, newRadius, 0, M_PI_2, 0);
    CGContextAddArc(ctx, newRadius, newSize.height - newRadius, newRadius, M_PI_2, M_PI, 0);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);

    // 画圆
    CGContextAddArc(ctx, newRadius, newRadius, radius, -M_PI, -M_PI_2, 0);
    CGContextAddArc(ctx, newSize.width - newRadius, newRadius, radius, -M_PI_2, 0, 0);
    CGContextAddArc(ctx, newSize.width - newRadius, newSize.height - newRadius, radius, 0, M_PI_2, 0);
    CGContextAddArc(ctx, newRadius, newSize.height - newRadius, radius, M_PI_2, M_PI, 0);
    CGContextClosePath(ctx);
    // 剪裁(后面画的才会受影响)
    CGContextClip(ctx);
    [self drawInRect:(CGRect){CGPointMake(borderWidth, borderWidth), size}];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  @author yangc, 16-07-08 09:07:48
 *
 *  改变图片颜色(非渐变)
 */
- (instancetype)imageWithTintColor:(UIColor *)tintColor {
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

/**
 *  @author yangc, 16-07-08 09:07:48
 *
 *  改变图片颜色(含渐变，灰色无效)
 */
- (instancetype)imageWithGradientTintColor:(UIColor *)tintColor {
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

/**
 *  @author yangc, 16-07-08 09:07:48
 *
 *  根据CGBlendMode改变图片颜色
 */
- (instancetype)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode {
    // We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);

    // Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];

    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }

    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return tintedImage;
}

@end
