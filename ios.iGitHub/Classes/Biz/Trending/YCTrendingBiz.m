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
#import "YCTrendingResult.h"

@implementation YCTrendingBiz

+ (void)trendingDailyWithLanguage:(NSString *)language success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    language = language.length ? language : @"";
    [YCHttpUtils sendGet:[NSString stringWithFormat:@"https://trendings.herokuapp.com/repo/%@?since=daily", language] params:nil success:^(NSHTTPURLResponse *response, id responseObject) {
        if (success) {
            NSArray *results = [YCTrendingResult mj_objectArrayWithKeyValuesArray:responseObject[@"items"]];
            success(results);
        }
    } failure:^(NSHTTPURLResponse *response, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)trendingWeeklyWithLanguage:(NSString *)language success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    language = language.length ? language : @"";
    [YCHttpUtils sendGet:[NSString stringWithFormat:@"https://trendings.herokuapp.com/repo/%@?since=weekly", language] params:nil success:^(NSHTTPURLResponse *response, id responseObject) {
        if (success) {
            NSArray *results = [YCTrendingResult mj_objectArrayWithKeyValuesArray:responseObject[@"items"]];
            success(results);
        }
    } failure:^(NSHTTPURLResponse *response, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)trendingMonthlyWithLanguage:(NSString *)language success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    language = language.length ? language : @"";
    [YCHttpUtils sendGet:[NSString stringWithFormat:@"https://trendings.herokuapp.com/repo/%@?since=monthly", language] params:nil success:^(NSHTTPURLResponse *response, id responseObject) {
        if (success) {
            NSArray *results = [YCTrendingResult mj_objectArrayWithKeyValuesArray:responseObject[@"items"]];
            success(results);
        }
    } failure:^(NSHTTPURLResponse *response, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
