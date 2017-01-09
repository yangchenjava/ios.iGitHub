//
//  YCOAuthParam.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/5.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import "YCOAuthParam.h"

@implementation YCOAuthParam

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @"client_id" : @"client_id", @"client_secret" : @"client_secret", @"code" : @"code" };
}

@end
