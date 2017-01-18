//
//  YCNewsBiz.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/18.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <YCHelpKit/YCHttpUtils.h>

#import "YCNewsBiz.h"
#import "YCNewsResult.h"

@implementation YCNewsBiz

+ (void)newsWithUsername:(NSString *)username success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    [YCHttpUtils sendGet:[NSString stringWithFormat:@"https://api.github.com/users/%@/received_events?per_page=%d", username, YC_PerPage]
        params:YC_OAuth
        success:^(NSHTTPURLResponse *response, id responseObject) {
            if (success) {
                NSArray *results = [MTLJSONAdapter modelsOfClass:[YCNewsResult class] fromJSONArray:responseObject error:NULL];
                success(results.copy);
            }
        }
        failure:^(NSHTTPURLResponse *response, NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
}

@end
