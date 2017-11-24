//
//  YCCommitBiz.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/3.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJExtension/MJExtension.h>
#import <YCHelpKit/YCHttpUtils.h>

#import "YCCommitBiz.h"
#import "YCCommitResult.h"

@implementation YCCommitBiz

+ (void)commitWithUsername:(NSString *)username reposname:(NSString *)reposname page:(int)page success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    [YCHttpUtils sendGet:[NSString stringWithFormat:@"https://api.github.com/repos/%@/%@/commits?page=%d&per_page=%d", username, reposname, page, YC_PerPage]
        params:YC_OAuth
        success:^(NSHTTPURLResponse *response, id responseObject) {
            if (success) {
                NSArray *results = [YCCommitResult mj_objectArrayWithKeyValuesArray:responseObject];
                success(results);
            }
        }
        failure:^(NSHTTPURLResponse *response, NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
}

+ (void)commitWithUsername:(NSString *)username reposname:(NSString *)reposname sha:(NSString *)sha success:(void (^)(YCCommitResult *))success failure:(void (^)(NSError *))failure {
    [YCHttpUtils sendGet:[NSString stringWithFormat:@"https://api.github.com/repos/%@/%@/commits/%@", username, reposname, sha]
        params:YC_OAuth
        success:^(NSHTTPURLResponse *response, id responseObject) {
            if (success) {
                YCCommitResult *result = [YCCommitResult mj_objectWithKeyValues:responseObject];
                success(result);
            }
        }
        failure:^(NSHTTPURLResponse *response, NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
}

+ (void)commitWithUsername:(NSString *)username
                 reposname:(NSString *)reposname
                    number:(long)number
                      page:(int)page
                   success:(void (^)(NSArray *results))success
                   failure:(void (^)(NSError *error))failure {
    [YCHttpUtils sendGet:[NSString stringWithFormat:@"https://api.github.com/repos/%@/%@/pulls/%ld/commits?page=%d&per_page=%d", username, reposname, number, page, YC_PerPage]
        params:YC_OAuth
        success:^(NSHTTPURLResponse *response, id responseObject) {
            if (success) {
                NSArray *results = [YCCommitResult mj_objectArrayWithKeyValuesArray:responseObject];
                success(results);
            }
        }
        failure:^(NSHTTPURLResponse *response, NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
}

@end
