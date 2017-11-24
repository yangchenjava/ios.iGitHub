//
//  YCCommitDetailResult.h
//  ios.iGitHub
//
//  Created by yangc on 16/8/3.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YCProfileResult;

@interface YCCommitDetailResult : NSObject

@property (nonatomic, strong) YCProfileResult *author;
@property (nonatomic, strong) YCProfileResult *committer;
@property (nonatomic, copy) NSString *message;

@end
