//
//  YCTrendingLanguageResult.m
//  ios.iGitHub
//
//  Created by yangc on 2017/11/27.
//  Copyright © 2017年 yangc. All rights reserved.
//

#import "YCTrendingLanguageResult.h"

@implementation YCTrendingLanguageResult

- (instancetype)initWithName:(NSString *)name slug:(NSString *)slug {
    if (self = [super init]) {
        self.name = name;
        self.slug = slug;
    }
    return self;
}

@end
