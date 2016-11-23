//
//  AppDelegate.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/1.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <SDWebImage/SDImageCache.h>
#import <YCHelpKit/SVModalWebViewController.h>
#import <YCHelpKit/UIAlertController+Category.h>

#import "AppDelegate.h"
#import "YCGitHubUtils.h"
#import "YCLoginViewController.h"
#import "YCScannerViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

static NSString *const kShortcutItemType = @"ios.iGitHub.scan";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 发起网络请求时状态栏菊花提示
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    // 显示状态栏
    [UIApplication sharedApplication].statusBarHidden = NO;
    // 设置3DTouch
    [self setupShortcutItems];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = YC_Color_RGB(87, 87, 87);
    [self.window makeKeyAndVisible];
    [YCGitHubUtils setupRootViewController];

    if (iOS8_OR_Later) {
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    return YES;
}


/**
 内存警告(清空SDWebImage图片缓存)

 @param application
 */
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[SDImageCache sharedImageCache] clearMemory];
}


/**
 设置3DTouch
 */
- (void)setupShortcutItems {
    if (iOS9_OR_Later) {
        UIApplicationShortcutIcon *scanShortcutIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3DTouch_scan"];
        UIApplicationShortcutItem *scanShortcutItem =
            [[UIApplicationShortcutItem alloc] initWithType:kShortcutItemType localizedTitle:@"扫一扫" localizedSubtitle:nil icon:scanShortcutIcon userInfo:nil];
        [UIApplication sharedApplication].shortcutItems = @[ scanShortcutItem ];
    }
}


/**
 3DTouch点击回调

 @param application
 @param shortcutItem
 @param completionHandler
 */
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    if ([shortcutItem.type isEqualToString:kShortcutItemType]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            while (true) {
                if (![self.window.rootViewController isKindOfClass:[YCLoginViewController class]]) {
                    break;
                }
                [NSThread sleepForTimeInterval:0.5];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                UIViewController *rootViewController = self.window.rootViewController;
                if ([YCScannerViewController isAvailable]) {
                    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
                        UINavigationController *navi = (UINavigationController *) rootViewController;
                        [navi pushViewController:[self scannerViewControllerWithNavigationController:navi] animated:YES];
                    } else if ([rootViewController isKindOfClass:[UITabBarController class]]) {
                        UINavigationController *navi = (UINavigationController *) ((UITabBarController *) rootViewController).selectedViewController;
                        [navi pushViewController:[self scannerViewControllerWithNavigationController:navi] animated:YES];
                    }
                } else {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"该设备不支持二维码扫描" message:nil preferredStyle:UIAlertControllerStyleAlert alertActions:nil];
                    [rootViewController presentViewController:alert animated:YES completion:nil];
                }
            });
        });
    }
}

- (YCScannerViewController *)scannerViewControllerWithNavigationController:(UINavigationController *)navigationController {
    YCWeakSelf(navigationController);
    YCScannerViewController *scannerVC = [[YCScannerViewController alloc] init];
    scannerVC.success = ^(YCScannerViewController *scannerVC, NSString *result) {
        [scannerVC.navigationController popViewControllerAnimated:YES];

        UIViewController *vc;
        if ([result hasPrefix:@"http"]) {
            vc = [[SVModalWebViewController alloc] initWithURL:[NSURL URLWithString:result]];
        } else {
            vc = [UIAlertController alertControllerWithTitle:result message:nil preferredStyle:UIAlertControllerStyleAlert alertActions:nil];
        }
        [weaknavigationController presentViewController:vc animated:YES completion:nil];
    };
    return scannerVC;
}

@end
