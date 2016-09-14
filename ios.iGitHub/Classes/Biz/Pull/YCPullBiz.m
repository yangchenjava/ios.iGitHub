//
//  YCPullBiz.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/4.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <YCHelpKit/YCHttpUtils.h>

#import "YCPullBiz.h"
#import "YCPullResult.h"

@implementation YCPullBiz

+ (void)pullWithUsername:(NSString *)username
               reposname:(NSString *)reposname
                   state:(NSString *)state
                    page:(int)page
                 success:(void (^)(NSArray *results))success
                 failure:(void (^)(NSError *error))failure {
    if (state == nil) {
        state = @"open";
    }
    [YCHttpUtils sendGet:[NSString stringWithFormat:@"https://api.github.com/repos/%@/%@/pulls?state=%@&page=%d&per_page=%d", username, reposname, state, page, YC_PerPage]
        params:YC_OAuth
        success:^(NSHTTPURLResponse *response, id responseObject) {
            if (success) {
                NSArray *results = [MTLJSONAdapter modelsOfClass:[YCPullResult class] fromJSONArray:responseObject error:NULL];
                success(results);
            }
        }
        failure:^(NSHTTPURLResponse *response, NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
}

+ (void)pullWithUsername:(NSString *)username reposname:(NSString *)reposname number:(long)number success:(void (^)(YCPullResult *result))success failure:(void (^)(NSError *error))failure {
    [YCHttpUtils sendGet:[NSString stringWithFormat:@"https://api.github.com/repos/%@/%@/pulls/%ld", username, reposname, number]
        params:YC_OAuth
        success:^(NSHTTPURLResponse *response, id responseObject) {
            if (success) {
                YCPullResult *result = [MTLJSONAdapter modelOfClass:[YCPullResult class] fromJSONDictionary:responseObject error:NULL];
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
