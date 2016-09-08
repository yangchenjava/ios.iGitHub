//
//  AppDelegate.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/1.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <SDWebImage/SDImageCache.h>

#import "AppDelegate.h"
#import "YCGitHubUtils.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 发起网络请求时状态栏菊花提示
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    // 显示状态栏
    [UIApplication sharedApplication].statusBarHidden = NO;

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = YC_Color_RGB(87, 87, 87);
    [self.window makeKeyAndVisible];
    [YCGitHubUtils setupRootViewController];

    //    float systemVersion = [UIDevice currentDevice].systemVersion.floatValue;
    //    if (systemVersion >= 8.0) {
    //        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    //        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    //        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    //    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the
    // user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is
    // terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// 内存警告(清空SDWebImage图片缓存)
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[SDImageCache sharedImageCache] clearMemory];
}

@end
