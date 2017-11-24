//
//  YCPullResult.h
//  ios.iGitHub
//
//  Created by yangc on 16/8/4.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YCProfileResult;

@interface YCPullResult : NSObject

@property (nonatomic, assign) long ID;
@property (nonatomic, assign) long number;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, assign) BOOL locked;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) YCProfileResult *user;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, strong) NSDate *created_at;
@property (nonatomic, strong) NSDate *updated_at;
@property (nonatomic, strong) NSDate *closed_at;
@property (nonatomic, strong) NSDate *merged_at;
@property (nonatomic, strong) YCProfileResult *assignee;
@property (nonatomic, strong) NSArray *assignees;
@property (nonatomic, assign) BOOL merged;
@property (nonatomic, strong) YCProfileResult *merged_by;
@property (nonatomic, assign) long comments;
@property (nonatomic, assign) long commits;
@property (nonatomic, assign) long additions;
@property (nonatomic, assign) long deletions;
@property (nonatomic, assign) long changed_files;

@end
