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
#import "YCTabBarController.h"
#import "YCUserAccessViewController.h"

@implementation YCGitHubUtils

+ (void)setOAuth:(YCOAuthResult *)oauth {
    static NSString *path;
    if (!path) {
        path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"OAuth.data"];
    }
    [NSKeyedArchiver archiveRootObject:oauth toFile:path];
}

+ (YCOAuthResult *)oauth {
    static NSString *path;
    if (!path) {
        path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"OAuth.data"];
    }
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

+ (void)setProfile:(YCProfileResult *)profile {
    static NSString *path;
    if (!path) {
        path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"Profile.data"];
    }
    [NSKeyedArchiver archiveRootObject:profile toFile:path];
}

+ (YCProfileResult *)profile {
    static NSString *path;
    if (!path) {
        path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"Profile.data"];
    }
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
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

@end
