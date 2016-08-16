//
//  UIImageView+SDWebImageCategory.h
//  ios_utils
//
//  Created by yangc on 16-4-19.
//  Copyright (c) 2016年 yangc. All rights reserved.
//

#import <SDWebImage/SDWebImageManager.h>
#import <UIKit/UIKit.h>

@interface UIImageView (SDWebImageCategory)

- (void)sd_setImageCircleWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)sd_setImageCircleWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;

- (void)sd_setImageRoundRectWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder radius:(CGFloat)radius;

- (void)sd_setImageRoundRectWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder radius:(CGFloat)radius completed:(SDWebImageCompletionBlock)completedBlock;

@end
