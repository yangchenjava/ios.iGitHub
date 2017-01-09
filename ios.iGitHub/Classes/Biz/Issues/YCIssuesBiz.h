//
//  YCIssuesBiz.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/26.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YCIssuesResult;

@interface YCIssuesBiz : NSObject

+ (void)issuesWithUsername:(NSString *)username
                 reposname:(NSString *)reposname
                     state:(NSString *)state
                      page:(int)page
                   success:(void (^)(NSArray *results))success
                   failure:(void (^)(NSError *error))failure;

+ (void)issuesWithUsername:(NSString *)username reposname:(NSString *)reposname number:(long)number success:(void (^)(YCIssuesResult *result))success failure:(void (^)(NSError *error))failure;

+ (void)issuesCommentsWithUsername:(NSString *)username reposname:(NSString *)reposname number:(long)number success:(void (^)(NSArray *results))success failure:(void (^)(NSError *error))failure;

@end
