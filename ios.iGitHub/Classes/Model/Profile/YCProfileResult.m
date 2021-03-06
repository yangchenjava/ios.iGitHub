//
//  YCProfileResult.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/7.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJExtension/MJExtension.h>

#import "YCGitHubUtils.h"
#import "YCProfileResult.h"

@implementation YCProfileResult

MJExtensionCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{ @"ID" : @"id" };
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (property.type.typeClass == [NSDate class]) {
        return [YCGitHubUtils.dateFormatter dateFromString:oldValue];
    }
    return oldValue;
}

- (NSString *)highlighter {
    return _highlighter.length ? _highlighter : @"default";
}

@end
