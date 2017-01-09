//
//  YCOAuthBiz.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/6.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <YCHelpKit/YCHttpUtils.h>

#import "YCOAuthBiz.h"
#import "YCOAuthParam.h"
#import "YCOAuthResult.h"

@implementation YCOAuthBiz

+ (void)oauthWithParam:(YCOAuthParam *)param success:(void (^)(YCOAuthResult *))success failure:(void (^)(NSError *))failure {
    NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:param error:NULL];
    [YCHttpUtils sendPost:@"https://github.com/login/oauth/access_token"
        params:params
        success:^(NSHTTPURLResponse *response, id responseObject) {
            if (success) {
                YCOAuthResult *result = [MTLJSONAdapter modelOfClass:[YCOAuthResult class] fromJSONDictionary:responseObject error:NULL];
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
