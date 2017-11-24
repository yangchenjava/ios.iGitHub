//
//  YCOAuthBiz.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/6.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJExtension/MJExtension.h>
#import <YCHelpKit/YCHttpUtils.h>

#import "YCOAuthBiz.h"
#import "YCOAuthParam.h"
#import "YCOAuthResult.h"

@implementation YCOAuthBiz

+ (void)oauthWithParam:(YCOAuthParam *)param success:(void (^)(YCOAuthResult *))success failure:(void (^)(NSError *))failure {
    [YCHttpUtils sendPost:@"https://github.com/login/oauth/access_token"
        params:param.mj_keyValues
        success:^(NSHTTPURLResponse *response, id responseObject) {
            if (success) {
                YCOAuthResult *result = [YCOAuthResult mj_objectWithKeyValues:responseObject];
                success(result);
            }
        }
        failure:^(NSHTTPURLResponse *response, NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
}

@end
