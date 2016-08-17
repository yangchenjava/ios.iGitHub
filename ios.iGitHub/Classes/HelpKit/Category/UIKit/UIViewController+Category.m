//
//  UIViewController+Category.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/16.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <objc/runtime.h>

#import "SVModalWebViewController.h"
#import "UIViewController+Category.h"

#define iOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

static const void *key_statusBarStyle = &key_statusBarStyle;

@implementation UIViewController (Category)

- (void)presentWebViewControllerWithURL:(NSURL *)URL animated:(BOOL)animated completion:(void (^)())completion {
    UIViewController *vc;
    if (iOS9) {
        self.statusBarStyle = @([UIApplication sharedApplication].statusBarStyle);
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
#ifdef __IPHONE_9_0
        SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:URL];
        safariViewController.delegate = self;
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:safariViewController];
        navi.navigationBarHidden = YES;
        vc = navi;
#endif
    } else {
        SVModalWebViewController *modalWebViewController = [[SVModalWebViewController alloc] initWithURL:URL];
        vc = modalWebViewController;
    }
    [self presentViewController:vc animated:animated completion:completion];
}

#ifdef __IPHONE_9_0
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    [UIApplication sharedApplication].statusBarStyle = self.statusBarStyle.longValue;
    [controller dismissViewControllerAnimated:YES completion:nil];
}
#endif

- (NSNumber *)statusBarStyle {
    return objc_getAssociatedObject(self, key_statusBarStyle);
}

- (void)setStatusBarStyle:(NSNumber *)statusBarStyle {
    objc_setAssociatedObject(self, key_statusBarStyle, statusBarStyle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
