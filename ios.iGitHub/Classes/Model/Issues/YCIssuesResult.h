//
//  YCIssuesResult.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/18.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Mantle/Mantle.h>

#import "YCProfileResult.h"

@interface YCIssuesResult : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *repository_url;
@property (nonatomic, copy) NSString *comments_url;
@property (nonatomic, assign) long ID;
@property (nonatomic, assign) long number;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) YCProfileResult *user;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, assign) BOOL locked;
@property (nonatomic, strong) YCProfileResult *assignee;
@property (nonatomic, strong) NSArray *assignees;
@property (nonatomic, assign) long comments;
@property (nonatomic, strong) NSDate *created_at;
@property (nonatomic, strong) NSDate *updated_at;
@property (nonatomic, strong) NSDate *closed_at;
@property (nonatomic, copy) NSString *body;

@end
