//
//  YCReposBiz.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/10.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YCBranchResult.h"
#import "YCContentResult.h"
#import "YCReadmeResult.h"
#import "YCReposResult.h"

@interface YCReposBiz : NSObject

+ (void)reposWithUsername:(NSString *)username page:(int)page success:(void (^)(NSArray *results))success failure:(void (^)(NSError *error))failure;

+ (void)reposWithUsername:(NSString *)username reposname:(NSString *)reposname success:(void (^)(YCReposResult *result))success failure:(void (^)(NSError *error))failure;

+ (void)reposBranchOrTagWithUsername:(NSString *)username
                           reposname:(NSString *)reposname
                               state:(NSString *)state
                                page:(int)page
                             success:(void (^)(NSArray *results))success
                             failure:(void (^)(NSError *error))failure;

+ (void)reposReadmeWithUsername:(NSString *)username reposname:(NSString *)reposname success:(void (^)(YCReadmeResult *result))success failure:(void (^)(NSError *error))failure;

+ (void)reposContentWithUsername:(NSString *)username
                       reposname:(NSString *)reposname
                            path:(NSString *)path
                             ref:(NSString *)ref
                            page:(int)page
                         success:(void (^)(id result))success
                         failure:(void (^)(NSError *error))failure;

@end
