//
//  YCPayloadResult.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/18.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Mantle/Mantle.h>

@class YCReposResult;
@class YCIssuesResult;
@class YCCommentResult;

typedef enum { RefTypeRepository, RefTypeBranch, RefTypeTag } RefType;

@interface YCPayloadResult : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *ref;
@property (nonatomic, assign) RefType ref_type;
@property (nonatomic, copy) NSString *master_branch;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *pusher_type;

@property (nonatomic, strong) YCReposResult *forkee;

@property (nonatomic, assign) long push_id;
@property (nonatomic, assign) long size;
@property (nonatomic, assign) long distinct_size;
@property (nonatomic, copy) NSString *head;
@property (nonatomic, copy) NSString *before;
@property (nonatomic, strong) NSArray *commits;

@property (nonatomic, copy) NSString *action;
@property (nonatomic, strong) YCIssuesResult *issue;
@property (nonatomic, strong) YCCommentResult *comment;
@property (nonatomic, strong) YCIssuesResult *pull_request;

@end
