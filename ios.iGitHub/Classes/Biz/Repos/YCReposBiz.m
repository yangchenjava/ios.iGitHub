//
//  YCReposBiz.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/10.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Mantle/Mantle.h>

#import "YCHttpUtils.h"
#import "YCReposBiz.h"

@implementation YCReposBiz

+ (void)reposWithUsername:(NSString *)username page:(int)page success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    [YCHttpUtils sendGet:[NSString stringWithFormat:@"https://api.github.com/users/%@/repos?type=all&page=%d&per_page=%d", username, page, YC_PerPage]
        params:YC_OAuth
        success:^(NSHTTPURLResponse *response, id responseObject) {
            if (success) {
                NSArray *results = [MTLJSONAdapter modelsOfClass:[YCReposResult class] fromJSONArray:responseObject error:NULL];
                success(results.copy);
            }
        }
        failure:^(NSHTTPURLResponse *response, NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
}

+ (void)reposWithUsername:(NSString *)username reposname:(NSString *)reposname success:(void (^)(YCReposResult *))success failure:(void (^)(NSError *))failure {
    [YCHttpUtils sendGet:[NSString stringWithFormat:@"https://api.github.com/repos/%@/%@", username, reposname]
        params:YC_OAuth
        success:^(NSHTTPURLResponse *response, id responseObject) {
            if (success) {
                YCReposResult *result = [MTLJSONAdapter modelOfClass:[YCReposResult class] fromJSONDictionary:responseObject error:NULL];
                success(result.copy);
            }
        }
        failure:^(NSHTTPURLResponse *response, NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
}

+ (void)reposBranchOrTagWithUsername:(NSString *)username
                           reposname:(NSString *)reposname
                               state:(NSString *)state
                                page:(int)page
                             success:(void (^)(NSArray *))success
                             failure:(void (^)(NSError *))failure {
    if (state == nil) {
        state = @"branches";
    }
    [YCHttpUtils sendGet:[NSString stringWithFormat:@"https://api.github.com/repos/%@/%@/%@?page=%d&per_page=%d", username, reposname, state, page, YC_PerPage]
        params:YC_OAuth
        success:^(NSHTTPURLResponse *response, id responseObject) {
            if (success) {
                NSArray *results = [MTLJSONAdapter modelsOfClass:[YCBranchResult class] fromJSONArray:responseObject error:NULL];
                success(results);
            }
        }
        failure:^(NSHTTPURLResponse *response, NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
}

+ (void)reposReadmeWithUsername:(NSString *)username reposname:(NSString *)reposname success:(void (^)(YCReadmeResult *))success failure:(void (^)(NSError *))failure {
    [YCHttpUtils sendGet:[NSString stringWithFormat:@"https://api.github.com/repos/%@/%@/readme", username, reposname]
        params:YC_OAuth
        success:^(NSHTTPURLResponse *response, id responseObject) {
            if (success) {
                YCReadmeResult *result = [MTLJSONAdapter modelOfClass:[YCReadmeResult class] fromJSONDictionary:responseObject error:NULL];
                success(result);
            }
        }
        failure:^(NSHTTPURLResponse *response, NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
}

+ (void)reposContentWithUsername:(NSString *)username
                       reposname:(NSString *)reposname
                            path:(NSString *)path
                             ref:(NSString *)ref
                            page:(int)page
                         success:(void (^)(id))success
                         failure:(void (^)(NSError *))failure {
    path = path.length ? [NSString stringWithFormat:@"/%@", path] : @"";
    [YCHttpUtils sendGet:[NSString stringWithFormat:@"https://api.github.com/repos/%@/%@/contents%@?ref=%@&page=%d&per_page=%d", username, reposname, path, ref, page, YC_PerPage]
        params:YC_OAuth
        success:^(NSHTTPURLResponse *response, id responseObject) {
            if (success) {
                id result;
                if ([responseObject isKindOfClass:[NSArray class]]) {
                    result = [MTLJSONAdapter modelsOfClass:[YCContentResult class] fromJSONArray:responseObject error:NULL];
                } else {
                    result = [MTLJSONAdapter modelOfClass:[YCContentResult class] fromJSONDictionary:responseObject error:NULL];
                }
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
