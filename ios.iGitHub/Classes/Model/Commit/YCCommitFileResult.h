//
//  YCCommitFileResult.h
//  ios.iGitHub
//
//  Created by yangc on 16/8/5.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface YCCommitFileResult : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *sha;
@property (nonatomic, copy) NSString *filename;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, assign) long additions;
@property (nonatomic, assign) long deletions;
@property (nonatomic, copy) NSString *patch;

@end
