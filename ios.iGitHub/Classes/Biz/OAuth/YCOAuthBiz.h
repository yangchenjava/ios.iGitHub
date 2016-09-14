//
//  YCOAuthBiz.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/6.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YCOAuthParam;
@class YCOAuthResult;

@interface YCOAuthBiz : NSObject

+ (void)oauthWithParam:(YCOAuthParam *)param success:(void (^)(YCOAuthResult *result))success failure:(void (^)(NSError *error))failure;

@end
