//
//  YCTrendingBiz.m
//  ios.iGitHub
//
//  Created by yangc on 2017/11/23.
//  Copyright © 2017年 yangc. All rights reserved.
//

#import <MJExtension/MJExtension.h>
#import <YCHelpKit/YCHttpUtils.h>

#import "YCTrendingBiz.h"
#import "YCReposResult.h"
#import "YCTrendingLanguageResult.h"

@implementation YCTrendingBiz

+ (void)trendingDailyWithLanguage:(NSString *)language success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    NSDictionary *params = @{ @"since" : @"daily", @"language" : (language.length ? language : @"") };
    [YCHttpUtils sendGet:@"http://trending.codehub-app.com/v2/trending" params:params success:^(NSHTTPURLResponse *response, id responseObject) {
        if (success) {
            NSArray *results = [YCReposResult mj_objectArrayWithKeyValuesArray:responseObject];
            success(results);
        }
    } failure:^(NSHTTPURLResponse *response, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)trendingWeeklyWithLanguage:(NSString *)language success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    NSDictionary *params = @{ @"since" : @"weekly", @"language" : (language.length ? language : @"") };
    [YCHttpUtils sendGet:@"http://trending.codehub-app.com/v2/trending" params:params success:^(NSHTTPURLResponse *response, id responseObject) {
        if (success) {
            NSArray *results = [YCReposResult mj_objectArrayWithKeyValuesArray:responseObject];
            success(results);
        }
    } failure:^(NSHTTPURLResponse *response, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)trendingMonthlyWithLanguage:(NSString *)language success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    NSDictionary *params = @{ @"since" : @"monthly", @"language" : (language.length ? language : @"") };
    [YCHttpUtils sendGet:@"http://trending.codehub-app.com/v2/trending" params:params success:^(NSHTTPURLResponse *response, id responseObject) {
        if (success) {
            NSArray *results = [YCReposResult mj_objectArrayWithKeyValuesArray:responseObject];
            success(results);
        }
    } failure:^(NSHTTPURLResponse *response, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)trendingLanguageWithSuccess:(void (^)(NSArray *results))success failure:(void (^)(NSError *error))failure {
    [YCHttpUtils sendGet:@"http://trending.codehub-app.com/v2/languages" params:nil success:^(NSHTTPURLResponse *response, id responseObject) {
        if (success) {
            NSMutableArray *results = [YCTrendingLanguageResult mj_objectArrayWithKeyValuesArray:responseObject];
            [results insertObject:[[YCTrendingLanguageResult alloc] initWithName:@"All Languages" slug:@""] atIndex:0];
            success(results);
        }
    } failure:^(NSHTTPURLResponse *response, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
