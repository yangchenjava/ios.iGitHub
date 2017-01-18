//
//  YCCommitResult.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/19.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import "YCCommitFileResult.h"
#import "YCCommitResult.h"

@implementation YCCommitResult

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"sha" : @"sha",
        @"commit" : @"commit",
        @"author" : @"author",
        @"committer" : @"committer",
        @"message" : @"message",
        @"distinct" : @"distinct",
        @"url" : @"url",
        @"parents" : @"parents",
        @"total" : @"stats.total",
        @"additions" : @"stats.additions",
        @"deletions" : @"stats.deletions",
        @"files" : @"files"
    };
}

+ (NSValueTransformer *)parentsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[YCCommitResult class]];
}

+ (NSValueTransformer *)filesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[YCCommitFileResult class]];
}

@end
