//
//  YCProfileBiz.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/7.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJExtension/MJExtension.h>
#import <YCHelpKit/YCHttpUtils.h>

#import "YCProfileBiz.h"
#import "YCProfileResult.h"

@implementation YCProfileBiz

+ (void)profileWithAccessToken:(NSString *)accessToken success:(void (^)(YCProfileResult *))success failure:(void (^)(NSError *))failure {
    [YCHttpUtils sendGet:[NSString stringWithFormat:@"https://api.github.com/user?access_token=%@", accessToken]
        params:YC_OAuth
        success:^(NSHTTPURLResponse *response, id responseObject) {
            if (success) {
                YCProfileResult *result = [YCProfileResult mj_objectWithKeyValues:responseObject];
                success(result);
            }
        }
        failure:^(NSHTTPURLResponse *response, NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
}

+ (void)profileWithUserName:(NSString *)username success:(void (^)(YCProfileResult *))success failure:(void (^)(NSError *))failure {
    [YCHttpUtils sendGet:[NSString stringWithFormat:@"https://api.github.com/users/%@", username]
        params:YC_OAuth
        success:^(NSHTTPURLResponse *response, id responseObject) {
            if (success) {
                YCProfileResult *result = [YCProfileResult mj_objectWithKeyValues:responseObject];
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
