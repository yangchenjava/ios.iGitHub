//
//  YCProfileBiz.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/7.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YCProfileResult.h"

@interface YCProfileBiz : NSObject

+ (void)profileWithAccessToken:(NSString *)accessToken success:(void (^)(YCProfileResult *result))success failure:(void (^)(NSError *error))failure;

+ (void)profileWithUserName:(NSString *)username success:(void (^)(YCProfileResult *result))success failure:(void (^)(NSError *error))failure;

@end
