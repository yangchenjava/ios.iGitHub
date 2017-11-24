//
//  YCCommitResult.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/19.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YCCommitDetailResult;
@class YCProfileResult;

@interface YCCommitResult : NSObject

@property (nonatomic, copy) NSString *sha;
@property (nonatomic, strong) YCCommitDetailResult *commit;
@property (nonatomic, strong) YCProfileResult *author;
@property (nonatomic, strong) YCProfileResult *committer;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) BOOL distinct;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSArray *parents;
@property (nonatomic, assign) long total;
@property (nonatomic, assign) long additions;
@property (nonatomic, assign) long deletions;
@property (nonatomic, strong) NSArray *files;

@end
