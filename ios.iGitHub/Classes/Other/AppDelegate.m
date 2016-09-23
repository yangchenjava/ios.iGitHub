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

- (void)setupShortcutItems {
    if (iOS9_OR_Later) {
        UIApplicationShortcutIcon *scanShortcutIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"3DTouch_scan"];
        UIApplicationShortcutItem *scanShortcutItem =
            [[UIApplicationShortcutItem alloc] initWithType:kShortcutItemType localizedTitle:@"扫一扫" localizedSubtitle:nil icon:scanShortcutIcon userInfo:nil];
        [UIApplication sharedApplication].shortcutItems = @[ scanShortcutItem ];
    }
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    if ([shortcutItem.type isEqualToString:kShortcutItemType]) {
        dispatch_queue_t queue = dispatch_queue_create("3DTouch", DISPATCH_QUEUE_SERIAL);
        dispatch_async(queue, ^{
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
