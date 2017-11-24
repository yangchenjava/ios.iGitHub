//
//  YCNewsResult.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/18.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJExtension/MJExtension.h>

#import "YCGitHubUtils.h"
#import "YCNewsResult.h"

@implementation YCNewsResult

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{ @"ID" : @"id", @"pbc" : @"public" };
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"type"]) {
        static NSDictionary *newsType;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            newsType = @{
                @"ForkEvent" : @(NewsTypeForkEvent),
                @"IssuesEvent" : @(NewsTypeIssuesEvent),
                @"WatchEvent" : @(NewsTypeWatchEvent)
            };
        });
        return newsType[oldValue];
    } else if (property.type.typeClass == [NSDate class]) {
        return [YCGitHubUtils.dateFormatter dateFromString:oldValue];
    }
    return oldValue;
}

@end
