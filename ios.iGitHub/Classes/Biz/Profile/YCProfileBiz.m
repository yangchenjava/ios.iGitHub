//
//  YCProfileBiz.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/7.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <YCHelpKit/YCHttpUtils.h>

#import "YCProfileBiz.h"

@implementation YCProfileBiz

+ (void)profileWithAccessToken:(NSString *)accessToken success:(void (^)(YCProfileResult *))success failure:(void (^)(NSError *))failure {
    [YCHttpUtils sendGet:[NSString stringWithFormat:@"https://api.github.com/user?access_token=%@", accessToken]
        params:YC_OAuth
        success:^(NSHTTPURLResponse *response, id responseObject) {
            if (success) {
                YCProfileResult *result = [MTLJSONAdapter modelOfClass:[YCProfileResult class] fromJSONDictionary:responseObject error:NULL];
                success(result.copy);
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
                YCProfileResult *result = [MTLJSONAdapter modelOfClass:[YCProfileResult class] fromJSONDictionary:responseObject error:NULL];
                success(result.copy);
            }
        }
        failure:^(NSHTTPURLResponse *response, NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
}

@end
