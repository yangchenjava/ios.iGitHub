//
//  YCPullResult.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/4.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import "YCGitHubUtils.h"
#import "YCProfileResult.h"
#import "YCPullResult.h"

@implementation YCPullResult

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"ID" : @"id",
        @"number" : @"number",
        @"state" : @"state",
        @"locked" : @"locked",
        @"title" : @"title",
        @"user" : @"user",
        @"body" : @"body",
        @"created_at" : @"created_at",
        @"updated_at" : @"updated_at",
        @"closed_at" : @"closed_at",
        @"merged_at" : @"merged_at",
        @"assignee" : @"assignee",
        @"assignees" : @"assignees",
        @"merged" : @"merged",
        @"merged_by" : @"merged_by",
        @"comments" : @"comments",
        @"commits" : @"commits",
        @"additions" : @"additions",
        @"deletions" : @"deletions",
        @"changed_files" : @"changed_files"
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

+ (NSValueTransformer *)closed_atJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [YCGitHubUtils.dateFormatter dateFromString:dateString];
    }
        reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
            return [YCGitHubUtils.dateFormatter stringFromDate:date];
        }];
}

+ (NSValueTransformer *)merged_atJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [YCGitHubUtils.dateFormatter dateFromString:dateString];
    }
        reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
            return [YCGitHubUtils.dateFormatter stringFromDate:date];
        }];
}

+ (NSValueTransformer *)assigneesJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[YCProfileResult class]];
}

@end
