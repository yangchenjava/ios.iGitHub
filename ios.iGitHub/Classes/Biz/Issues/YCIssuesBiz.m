//
//  YCIssuesBiz.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/26.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <YCHelpKit/YCHttpUtils.h>

#import "YCCommentResult.h"
#import "YCIssuesBiz.h"

@implementation YCIssuesBiz

+ (void)issuesWithUsername:(NSString *)username reposname:(NSString *)reposname state:(NSString *)state page:(int)page success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    if (state == nil) {
        state = @"open";
    }
    [YCHttpUtils sendGet:[NSString stringWithFormat:@"https://api.github.com/repos/%@/%@/issues?state=%@&page=%d&per_page=%d", username, reposname, state, page, YC_PerPage]
        params:YC_OAuth
        success:^(NSHTTPURLResponse *response, id responseObject) {
            if (success) {
                NSArray *results = [MTLJSONAdapter modelsOfClass:[YCIssuesResult class] fromJSONArray:responseObject error:NULL];
                success(results);
            }
        }
        failure:^(NSHTTPURLResponse *response, NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
}

+ (void)issuesWithUsername:(NSString *)username reposname:(NSString *)reposname number:(long)number success:(void (^)(YCIssuesResult *))success failure:(void (^)(NSError *))failure {
    [YCHttpUtils sendGet:[NSString stringWithFormat:@"https://api.github.com/repos/%@/%@/issues/%ld", username, reposname, number]
        params:YC_OAuth
        success:^(NSHTTPURLResponse *response, id responseObject) {
            if (success) {
                YCIssuesResult *result = [MTLJSONAdapter modelOfClass:[YCIssuesResult class] fromJSONDictionary:responseObject error:NULL];
                success(result);
            }
        }
        failure:^(NSHTTPURLResponse *response, NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
}

+ (void)issuesCommentsWithUsername:(NSString *)username reposname:(NSString *)reposname number:(long)number success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    [YCHttpUtils sendGet:[NSString stringWithFormat:@"https://api.github.com/repos/%@/%@/issues/%ld/comments", username, reposname, number]
        params:YC_OAuth
        success:^(NSHTTPURLResponse *response, id responseObject) {
            if (success) {
                NSArray *results = [MTLJSONAdapter modelsOfClass:[YCCommentResult class] fromJSONArray:responseObject error:NULL];
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
