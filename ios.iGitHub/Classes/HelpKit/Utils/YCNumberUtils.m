//
//  YCNumberUtils.m
//  ios_utils
//
//  Created by yangc on 16-5-11.
//  Copyright (c) 2016年 yangc. All rights reserved.
//

#import "YCNumberUtils.h"

@implementation YCNumberUtils

static double const _KB = 1024.0;
static double const _MB = 1024.0 * 1024.0;
static double const _GB = 1024.0 * 1024.0 * 1024.0;
static double const _TB = 1024.0 * 1024.0 * 1024.0 * 1024.0;

+ (NSString *)size:(NSNumber *)size {
    long long value = size.longLongValue;
    if (value <= 0) {
        return @"0B";
    } else if (value <= _KB) {
        return [NSString stringWithFormat:@"%lldB", value];
    } else if (value <= _MB) {
        return [NSString stringWithFormat:@"%.1fK", value / _KB];
    } else if (value <= _GB) {
        return [NSString stringWithFormat:@"%.1fM", value / _MB];
    } else if (value <= _TB) {
        return [NSString stringWithFormat:@"%.1fG", value / _GB];
    } else {
        return [NSString stringWithFormat:@"%lld", value];
    }
}

@end
