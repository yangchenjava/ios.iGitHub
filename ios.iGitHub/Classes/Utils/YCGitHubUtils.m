//
//  YCGitHubUtils.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/7.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <DateTools/DateTools.h>

#import "YCGitHubUtils.h"
#import "YCLoginViewController.h"
#import "YCNavigationController.h"
#import "YCOAuthResult.h"
#import "YCProfileResult.h"
#import "YCTabBarController.h"
#import "YCUserAccessViewController.h"

@implementation YCGitHubUtils

static NSString *oauthPath;
static NSString *profilePath;

+ (YCOAuthResult *)oauth {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        oauthPath = [YC_Dir_Document stringByAppendingPathComponent:@"OAuth.data"];
    });
    return [NSKeyedUnarchiver unarchiveObjectWithFile:oauthPath];
}

+ (void)setOAuth:(YCOAuthResult *)oauth {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        oauthPath = [YC_Dir_Document stringByAppendingPathComponent:@"OAuth.data"];
    });
    [NSKeyedArchiver archiveRootObject:oauth toFile:oauthPath];
}

+ (YCProfileResult *)profile {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        profilePath = [YC_Dir_Document stringByAppendingPathComponent:@"Profile.data"];
    });
    return [NSKeyedUnarchiver unarchiveObjectWithFile:profilePath];
}

+ (void)setProfile:(YCProfileResult *)profile {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        profilePath = [YC_Dir_Document stringByAppendingPathComponent:@"Profile.data"];
    });
    [NSKeyedArchiver archiveRootObject:profile toFile:profilePath];
}

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    });
    return dateFormatter;
}

+ (NSString *)dateStringWithDate:(NSDate *)date {
    NSDate *currentDate = [NSDate date];
    if (date.year != currentDate.year) {
        return [date formattedDateWithFormat:@"MM/dd/yy"];
    } else {
        NSInteger days = [currentDate daysLaterThan:date];
        if (days > 30) {
            return [date formattedDateWithFormat:@"'on' d MMM" locale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        } else if (days == 0) {
            return [NSString stringWithFormat:@"%d hours ago", (int) round([currentDate hoursLaterThan:date])];
        } else {
            return [NSString stringWithFormat:@"%ld %@ ago", days, days == 1 ? @"day" : @"days"];
        }
    }
}

+ (void)setupRootViewController {
    UIViewController *rootViewController;
    if ([[UIApplication sharedApplication].keyWindow.rootViewController isMemberOfClass:[YCLoginViewController class]]) {
        [UIApplication sharedApplication].statusBarHidden = NO;
        rootViewController = [[YCTabBarController alloc] init];
    } else if ([self oauth]) {
        [UIApplication sharedApplication].statusBarHidden = YES;
        rootViewController = [[YCLoginViewController alloc] init];
    } else {
        [UIApplication sharedApplication].statusBarHidden = NO;
        rootViewController = [[YCNavigationController alloc] initWithRootViewController:[[YCUserAccessViewController alloc] init]];
    }
    [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
}

+ (void)pushViewController:(UIViewController *)vc {
    YCTabBarController *tabBarController = (YCTabBarController *) [UIApplication sharedApplication].keyWindow.rootViewController;
    YCNavigationController *navigationController = tabBarController.selectedViewController;
    [navigationController pushViewController:vc animated:YES];
}

@end
