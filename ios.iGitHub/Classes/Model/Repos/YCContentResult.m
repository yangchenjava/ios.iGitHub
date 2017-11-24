//
//  YCContentResult.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/8.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJExtension/MJExtension.h>

#import "YCContentResult.h"

@implementation YCContentResult

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"type"]) {
        static NSDictionary *contentType;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            contentType = @{
                @"dir" : @(ContentTypeDir),
                @"file" : @(ContentTypeFile)
            };
        });
        return contentType[oldValue];
    }
    return oldValue;
}

@end
