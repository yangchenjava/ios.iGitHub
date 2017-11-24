//
//  YCEventsBiz.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/19.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJExtension/MJExtension.h>
#import <YCHelpKit/YCHttpUtils.h>

#import "YCEventsBiz.h"
#import "YCEventsResult.h"

@implementation YCEventsBiz

+ (void)eventsWithUsername:(NSString *)username reposname:(NSString *)reposname page:(int)page success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    NSString *URLString;
    if (reposname) {
        URLString = [NSString stringWithFormat:@"https://api.github.com/repos/%@/%@/events?page=%d&per_page=%d", username, reposname, page, YC_PerPage];
    } else {
        URLString = [NSString stringWithFormat:@"https://api.github.com/users/%@/events?page=%d&per_page=%d", username, page, YC_PerPage];
    }
    [YCHttpUtils sendGet:URLString
        params:YC_OAuth
        success:^(NSHTTPURLResponse *response, id responseObject) {
            if (success) {
                NSArray *results = [YCEventsResult mj_objectArrayWithKeyValuesArray:responseObject];
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
