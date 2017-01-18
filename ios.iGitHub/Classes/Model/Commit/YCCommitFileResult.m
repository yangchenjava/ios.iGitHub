//
//  YCCommitFileResult.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/5.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import "YCCommitFileResult.h"

@implementation YCCommitFileResult

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @"sha" : @"sha", @"filename" : @"filename", @"status" : @"status", @"additions" : @"additions", @"deletions" : @"deletions", @"raw_url" : @"raw_url", @"patch" : @"patch" };
}

@end
