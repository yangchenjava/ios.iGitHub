//
//  YCReposResult.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/10.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import "YCGitHubUtils.h"
#import "YCReposResult.h"

@implementation YCReposResult

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"ID" : @"id",
        @"name" : @"name",
        @"full_name" : @"full_name",
        @"owner" : @"owner",
        @"pvt" : @"private",
        @"html_url" : @"html_url",
        @"desc" : @"description",
        @"url" : @"url",
        @"created_at" : @"created_at",
        @"updated_at" : @"updated_at",
        @"pushed_at" : @"pushed_at",
        @"homepage" : @"homepage",
        @"size" : @"size",
        @"stargazers_count" : @"stargazers_count",
        @"watchers_count" : @"watchers_count",
        @"language" : @"language",
        @"has_issues" : @"has_issues",
        @"has_downloads" : @"has_downloads",
        @"forks_count" : @"forks_count",
        @"open_issues_count" : @"open_issues_count",
        @"parent" : @"parent"
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

+ (NSValueTransformer *)pushed_atJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [YCGitHubUtils.dateFormatter dateFromString:dateString];
    }
        reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
            return [YCGitHubUtils.dateFormatter stringFromDate:date];
        }];
}

@end
