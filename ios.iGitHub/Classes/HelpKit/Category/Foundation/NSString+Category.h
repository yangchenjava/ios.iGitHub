//
//  NSString+Category.h
//  ios_utils
//
//  Created by yangc on 16-1-28.
//  Copyright (c) 2016年 yangc. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Category)

- (CGSize)sizeWithFont:(UIFont *)font size:(CGSize)maxSize;

- (NSString *)md5String;

@end
