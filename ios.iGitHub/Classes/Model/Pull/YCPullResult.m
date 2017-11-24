//
//  YCPullResult.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/4.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJExtension/MJExtension.h>

#import "YCGitHubUtils.h"
#import "YCProfileResult.h"
#import "YCPullResult.h"

@implementation YCPullResult

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{ @"ID" : @"id" };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{ @"assignees" : [YCProfileResult class] };
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (property.type.class == [NSDate class]) {
        return [YCGitHubUtils.dateFormatter dateFromString:oldValue];
    }
    return oldValue;
}

@end
