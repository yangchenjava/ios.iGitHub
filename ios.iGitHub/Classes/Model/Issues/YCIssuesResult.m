//
//  YCIssuesResult.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/18.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import "YCGitHubUtils.h"
#import "YCIssuesResult.h"

@implementation YCIssuesResult

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"url" : @"url",
        @"repository_url" : @"repository_url",
        @"comments_url" : @"comments_url",
        @"ID" : @"id",
        @"number" : @"number",
        @"title" : @"title",
        @"user" : @"user",
        @"state" : @"state",
        @"locked" : @"locked",
        @"assignee" : @"assignee",
        @"assignees" : @"assignees",
        @"comments" : @"comments",
        @"created_at" : @"created_at",
        @"updated_at" : @"updated_at",
        @"closed_at" : @"closed_at",
        @"body" : @"body"
    };
}

+ (NSValueTransformer *)assigneesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[YCProfileResult class]];
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

+ (NSValueTransformer *)closed_atJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [YCGitHubUtils.dateFormatter dateFromString:dateString];
    }
        reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
            return [YCGitHubUtils.dateFormatter stringFromDate:date];
        }];
}

@end
