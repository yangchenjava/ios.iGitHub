//
//  YCProfileResult.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/7.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <DateTools/DateTools.h>

#import "YCGitHubUtils.h"
#import "YCProfileResult.h"

@implementation YCProfileResult

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"login" : @"login",
        @"ID" : @"id",
        @"avatar_url" : @"avatar_url",
        @"name" : @"name",
        @"company" : @"company",
        @"blog" : @"blog",
        @"location" : @"location",
        @"email" : @"email",
        @"bio" : @"bio",
        @"public_repos" : @"public_repos",
        @"public_gists" : @"public_gists",
        @"followers" : @"followers",
        @"following" : @"following",
        @"created_at" : @"created_at",
        @"updated_at" : @"updated_at",
        @"date" : @"date"
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

+ (NSValueTransformer *)dateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [YCGitHubUtils.dateFormatter dateFromString:dateString];
    }
        reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
            return [YCGitHubUtils.dateFormatter stringFromDate:date];
        }];
}

@end
