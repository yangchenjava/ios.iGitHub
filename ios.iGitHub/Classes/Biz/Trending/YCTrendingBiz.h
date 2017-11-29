//
//  YCTrendingBiz.h
//  ios.iGitHub
//
//  Created by yangc on 2017/11/23.
//  Copyright © 2017年 yangc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCTrendingBiz : NSObject

+ (void)trendingDailyWithLanguage:(NSString *)language success:(void (^)(NSArray *results))success failure:(void (^)(NSError *error))failure;

+ (void)trendingWeeklyWithLanguage:(NSString *)language success:(void (^)(NSArray *results))success failure:(void (^)(NSError *error))failure;

+ (void)trendingMonthlyWithLanguage:(NSString *)language success:(void (^)(NSArray *results))success failure:(void (^)(NSError *error))failure;

+ (void)trendingLanguageWithSuccess:(void (^)(NSArray *results))success failure:(void (^)(NSError *error))failure;

@end
