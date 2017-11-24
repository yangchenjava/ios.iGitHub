//
//  YCCommitResult.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/19.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJExtension/MJExtension.h>

#import "YCCommitFileResult.h"
#import "YCCommitResult.h"

@implementation YCCommitResult

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"total" : @"stats.total",
        @"additions" : @"stats.additions",
        @"deletions" : @"stats.deletions"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"parents" : [YCCommitResult class],
        @"files" :[YCCommitFileResult class]
    };
}

@end
