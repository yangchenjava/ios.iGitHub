//
//  YCGitHubUtils.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/7.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YCOAuthResult.h"
#import "YCProfileResult.h"

@interface YCGitHubUtils : NSObject

+ (void)setOAuth:(YCOAuthResult *)oauth;
+ (YCOAuthResult *)oauth;

+ (void)setProfile:(YCProfileResult *)profile;
+ (YCProfileResult *)profile;

+ (NSDateFormatter *)dateFormatter;

+ (NSString *)dateStringWithDate:(NSDate *)date;

+ (void)setupRootViewController;

@end
