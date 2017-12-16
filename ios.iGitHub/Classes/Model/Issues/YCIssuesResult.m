//
//  YCIssuesResult.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/18.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJExtension/MJExtension.h>

#import "YCGitHubUtils.h"
#import "YCIssuesResult.h"
#import "YCProfileResult.h"

@implementation YCIssuesResult

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{ @"ID" : @"id" };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{ @"assignees" : [YCProfileResult class] };
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (property.type.typeClass == [NSDate class] && ![oldValue isEqual:[NSNull null]]) {
        return [YCGitHubUtils.dateFormatter dateFromString:oldValue];
    }
    return oldValue;
}

@end
