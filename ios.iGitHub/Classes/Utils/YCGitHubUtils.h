//
//  YCGitHubUtils.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/7.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YCOAuthResult.h"
#import "YCProfileResult.h"

@interface YCGitHubUtils : NSObject

+ (YCOAuthResult *)oauth;
+ (void)setOAuth:(YCOAuthResult *)oauth;

+ (YCProfileResult *)profile;
+ (void)setProfile:(YCProfileResult *)profile;

+ (NSDateFormatter *)dateFormatter;

+ (NSString *)dateStringWithDate:(NSDate *)date;

+ (void)setupRootViewController;

+ (void)pushViewController:(UIViewController *)vc;

@end
