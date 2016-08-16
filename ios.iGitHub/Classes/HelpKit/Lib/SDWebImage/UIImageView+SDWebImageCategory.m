//
//  UIImageView+SDWebImageCategory.m
//  ios_utils
//
//  Created by yangc on 16-4-19.
//  Copyright (c) 2016年 yangc. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>

#import "UIImage+Category.h"
#import "UIImageView+SDWebImageCategory.h"

@implementation UIImageView (SDWebImageCategory)

- (void)sd_setImageCircleWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self sd_setImageCircleWithURL:url placeholderImage:placeholder completed:nil];
}

- (void)sd_setImageCircleWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock {

    NSString *key = [url.absoluteString stringByAppendingString:@"_Circle"];
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    if (cacheImage) {
        self.image = cacheImage;
        if (completedBlock) completedBlock(self.image, nil, SDImageCacheTypeDisk, url);
    } else {
        [self sd_setImageWithURL:url
                placeholderImage:placeholder
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                           if (!error) {
                               UIImage *newImage = [image imageWithCircle:image.size];
                               self.image = newImage;
                               [[SDImageCache sharedImageCache] storeImage:newImage forKey:key];
                               [[SDImageCache sharedImageCache] removeImageForKey:url.absoluteString];
                               if (completedBlock) completedBlock(self.image, error, cacheType, imageURL);
                           }
                       }];
    }
}

- (void)sd_setImageRoundRectWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder radius:(CGFloat)radius {
    [self sd_setImageRoundRectWithURL:url placeholderImage:placeholder radius:radius completed:nil];
}

- (void)sd_setImageRoundRectWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder radius:(CGFloat)radius completed:(SDWebImageCompletionBlock)completedBlock {
    if (radius) {
        NSString *key = [url.absoluteString stringByAppendingString:@"_RoundRect"];
        UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
        if (cacheImage) {
            self.image = cacheImage;
            if (completedBlock) completedBlock(self.image, nil, SDImageCacheTypeDisk, url);
        } else {
            [self sd_setImageWithURL:url
                    placeholderImage:placeholder
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               if (!error) {
                                   UIImage *newImage = [image imageWithRoundRect:image.size radius:radius];
                                   self.image = newImage;
                                   [[SDImageCache sharedImageCache] storeImage:newImage forKey:key];
                                   [[SDImageCache sharedImageCache] removeImageForKey:url.absoluteString];
                                   if (completedBlock) completedBlock(self.image, error, cacheType, imageURL);
                               }
                           }];
        }
    } else {
        [self sd_setImageWithURL:url placeholderImage:placeholder completed:completedBlock];
    }
}

@end
