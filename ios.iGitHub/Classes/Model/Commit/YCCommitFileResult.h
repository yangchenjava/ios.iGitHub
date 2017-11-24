//
//  YCCommitFileResult.h
//  ios.iGitHub
//
//  Created by yangc on 16/8/5.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCCommitFileResult : NSObject

@property (nonatomic, copy) NSString *sha;
@property (nonatomic, copy) NSString *filename;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, assign) long additions;
@property (nonatomic, assign) long deletions;
@property (nonatomic, copy) NSString *raw_url;
@property (nonatomic, copy) NSString *patch;

@end
