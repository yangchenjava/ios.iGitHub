//
//  YCCommentResult.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/27.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import "YCCommentResult.h"
#import "YCGitHubUtils.h"

@implementation YCCommentResult

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"url" : @"url",
        @"issue_url" : @"issue_url",
        @"ID" : @"id",
        @"user" : @"user",
        @"commit_id" : @"commit_id",
        @"created_at" : @"created_at",
        @"updated_at" : @"updated_at",
        @"body" : @"body"
    };
}

+ (NSValueTransformer *)created_atJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [YCGitHubUtils.dateFormatter dateFromString:dateString];
    }
        reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
            return [YCGitHubUtils.dateFormatter stringFromDate:date];
        }];
}

+ (NSValueTransformer *)updated_atJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [YCGitHubUtils.dateFormatter dateFromString:dateString];
    }
        reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
            return [YCGitHubUtils.dateFormatter stringFromDate:date];
        }];
}

@end
