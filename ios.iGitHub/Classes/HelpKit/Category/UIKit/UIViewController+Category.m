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

static const void *key_statusBarStyle = &key_statusBarStyle;

@implementation UIViewController (Category)

- (void)presentWebViewControllerWithURL:(NSURL *)URL animated:(BOOL)animated completion:(void (^)())completion {
#ifdef __IPHONE_9_0
    self.statusBarStyle = @([UIApplication sharedApplication].statusBarStyle);
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    SFSafariViewController *vc = [[SFSafariViewController alloc] initWithURL:URL];
    vc.delegate = self;
#else
    SVModalWebViewController *vc = [[SVModalWebViewController alloc] initWithURL:URL];
#endif
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
