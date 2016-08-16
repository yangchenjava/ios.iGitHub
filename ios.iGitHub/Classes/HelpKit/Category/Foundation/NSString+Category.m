//
//  NSString+Category.m
//  ios_utils
//
//  Created by yangc on 16-1-28.
//  Copyright (c) 2016年 yangc. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

- (CGSize)sizeWithFont:(UIFont *)font size:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (NSString *)md5String {
    const char *data = [self UTF8String];
    unsigned char md[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data, (int) strlen(data), md);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", md[i]];
    }
    return output.copy;
}

@end
