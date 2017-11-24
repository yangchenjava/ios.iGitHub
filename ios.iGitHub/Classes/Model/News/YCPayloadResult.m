//
//  YCPayloadResult.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/18.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJExtension/MJExtension.h>

#import "YCCommitResult.h"
#import "YCPayloadResult.h"

@implementation YCPayloadResult

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{ @"desc" : @"description" };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{ @"commits" : [YCCommitResult class] };
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"ref_type"]) {
        static NSDictionary *refType;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            refType = @{
                @"repository" : @(RefTypeRepository),
                @"branch" : @(RefTypeBranch),
                @"tag" : @(RefTypeTag)
            };
        });
        return refType[oldValue];
    }
    return oldValue;
}

@end
