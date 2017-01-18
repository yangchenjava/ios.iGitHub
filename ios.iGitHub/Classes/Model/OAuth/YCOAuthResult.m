//
//  YCOAuthResult.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/5.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import "YCOAuthResult.h"

@implementation YCOAuthResult

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @"access_token" : @"access_token", @"scope" : @"scope", @"token_type" : @"token_type" };
}

@end
