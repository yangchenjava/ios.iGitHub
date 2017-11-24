//
//  YCCommentResult.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/27.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YCProfileResult;

@interface YCCommentResult : NSObject

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *issue_url;
@property (nonatomic, assign) long ID;
@property (nonatomic, strong) YCProfileResult *user;
@property (nonatomic, copy) NSString *commit_id;
@property (nonatomic, strong) NSDate *created_at;
@property (nonatomic, strong) NSDate *updated_at;
@property (nonatomic, copy) NSString *body;

@end
