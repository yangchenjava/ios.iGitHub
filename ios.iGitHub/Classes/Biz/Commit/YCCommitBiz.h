//
//  YCCommitBiz.h
//  ios.iGitHub
//
//  Created by yangc on 16/8/3.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YCCommitResult;

@interface YCCommitBiz : NSObject

+ (void)commitWithUsername:(NSString *)username reposname:(NSString *)reposname page:(int)page success:(void (^)(NSArray *results))success failure:(void (^)(NSError *error))failure;

+ (void)commitWithUsername:(NSString *)username reposname:(NSString *)reposname sha:(NSString *)sha success:(void (^)(YCCommitResult *result))success failure:(void (^)(NSError *error))failure;

+ (void)commitWithUsername:(NSString *)username
                 reposname:(NSString *)reposname
                    number:(long)number
                      page:(int)page
                   success:(void (^)(NSArray *results))success
                   failure:(void (^)(NSError *error))failure;

@end
