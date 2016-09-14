//
//  YCPayloadResult.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/18.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import "YCCommitResult.h"
#import "YCPayloadResult.h"

@implementation YCPayloadResult

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"ref" : @"ref",
        @"ref_type" : @"ref_type",
        @"master_branch" : @"master_branch",
        @"desc" : @"description",
        @"pusher_type" : @"pusher_type",
        @"forkee" : @"forkee",
        @"push_id" : @"push_id",
        @"size" : @"size",
        @"distinct_size" : @"distinct_size",
        @"head" : @"head",
        @"before" : @"before",
        @"commits" : @"commits",
        @"action" : @"action",
        @"issue" : @"issue",
        @"comment" : @"comment",
        @"pull_request" : @"pull_request"
    };
}

+ (NSValueTransformer *)ref_typeJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"repository" : @(RefTypeRepository), @"branch" : @(RefTypeBranch), @"tag" : @(RefTypeTag) }];
}

+ (NSValueTransformer *)commitsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[YCCommitResult class]];
}

@end
