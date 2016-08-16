//
//  YCNewsResult.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/18.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import "YCGitHubUtils.h"
#import "YCNewsResult.h"

@implementation YCNewsResult

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @"ID" : @"id", @"type" : @"type", @"actor" : @"actor", @"repo" : @"repo", @"payload" : @"payload", @"pbc" : @"public", @"created_at" : @"created_at" };
}

+ (NSValueTransformer *)typeJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"ForkEvent" : @(NewsTypeForkEvent), @"IssuesEvent" : @(NewsTypeIssuesEvent), @"WatchEvent" : @(NewsTypeWatchEvent) }];
}

+ (NSValueTransformer *)created_atJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [YCGitHubUtils.dateFormatter dateFromString:dateString];
    }
        reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
            return [YCGitHubUtils.dateFormatter stringFromDate:date];
        }];
}

@end
