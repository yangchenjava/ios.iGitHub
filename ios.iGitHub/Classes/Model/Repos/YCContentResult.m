//
//  YCContentResult.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/8.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import "YCContentResult.h"

@implementation YCContentResult

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"type" : @"type",
        @"encoding" : @"encoding",
        @"size" : @"size",
        @"name" : @"name",
        @"path" : @"path",
        @"content" : @"content",
        @"sha" : @"sha",
        @"url" : @"url",
        @"download_url" : @"download_url"
    };
}

+ (NSValueTransformer *)typeJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{ @"dir" : @(ContentTypeDir), @"file" : @(ContentTypeFile) }];
}

@end
