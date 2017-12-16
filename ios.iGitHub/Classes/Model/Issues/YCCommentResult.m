//
//  YCCommentResult.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/27.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJExtension/MJExtension.h>

#import "YCCommentResult.h"
#import "YCGitHubUtils.h"

@implementation YCCommentResult

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{ @"ID" : @"id" };
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (property.type.typeClass == [NSDate class]) {
        return [YCGitHubUtils.dateFormatter dateFromString:oldValue];
    }
    return oldValue;
}

@end
