//
//  YCPullBiz.h
//  ios.iGitHub
//
//  Created by yangc on 16/8/4.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YCPullResult.h"

@interface YCPullBiz : NSObject

+ (void)pullWithUsername:(NSString *)username
               reposname:(NSString *)reposname
                   state:(NSString *)state
                    page:(int)page
                 success:(void (^)(NSArray *results))success
                 failure:(void (^)(NSError *error))failure;

+ (void)pullWithUsername:(NSString *)username reposname:(NSString *)reposname number:(long)number success:(void (^)(YCPullResult *result))success failure:(void (^)(NSError *error))failure;

@end
