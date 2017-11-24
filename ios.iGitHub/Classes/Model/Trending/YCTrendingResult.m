//
//  YCTrendingResult.m
//  ios.iGitHub
//
//  Created by yangc on 2017/11/21.
//  Copyright © 2017年 yangc. All rights reserved.
//

#import <MJExtension/MJExtension.h>

#import "YCTrendingResult.h"

@implementation YCTrendingResult

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"stars"] || [property.name isEqualToString:@"forks"]) {
        return [oldValue stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
    return oldValue;
}

@end
