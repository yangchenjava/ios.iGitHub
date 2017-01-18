//
//  YCNewsResult.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/18.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Mantle/Mantle.h>

@class YCProfileResult;
@class YCReposResult;
@class YCPayloadResult;

typedef enum { NewsTypeForkEvent, NewsTypeIssuesEvent, NewsTypeWatchEvent } NewsType;

@interface YCNewsResult : MTLModel <MTLJSONSerializing>

/**
 *  @author yangc, 16-07-10 17:07:00
 *
 *  4250692314
 */
@property (nonatomic, copy) NSString *ID;

@property (nonatomic, assign) NewsType type;

@property (nonatomic, strong) YCProfileResult *actor;

@property (nonatomic, strong) YCReposResult *repo;

@property (nonatomic, strong) YCPayloadResult *payload;

@property (nonatomic, assign) BOOL pbc;

@property (nonatomic, strong) NSDate *created_at;

@property (nonatomic, strong) NSURL *attrURL;

@end
