//
//  YCContentResult.h
//  ios.iGitHub
//
//  Created by yangc on 16/8/8.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Mantle/Mantle.h>

typedef enum { ContentTypeDir, ContentTypeFile } ContentType;

@interface YCContentResult : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign) ContentType type;
@property (nonatomic, copy) NSString *encoding;
@property (nonatomic, assign) long size;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *sha;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *download_url;

@end
