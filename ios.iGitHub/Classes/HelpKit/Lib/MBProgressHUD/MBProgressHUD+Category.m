//
//  MBProgressHUD+Category.m
//  ios_utils
//
//  Created by yangc on 16-2-6.
//  Copyright (c) 2016年 yangc. All rights reserved.
//

#import "MBProgressHUD+Category.h"

@implementation MBProgressHUD (Category)

#pragma mark - 显示成功
+ (void)showSuccess:(NSString *)success {
    [self showSuccess:success toView:nil];
}
+ (void)showSuccess:(NSString *)success toView:(UIView *)view {
    [self showSuccessOrError:@"MBProgressHUD.bundle/success" message:success toView:view];
}

#pragma mark - 显示失败
+ (void)showError:(NSString *)error {
    [self showError:error toView:nil];
}
+ (void)showError:(NSString *)error toView:(UIView *)view {
    [self showSuccessOrError:@"MBProgressHUD.bundle/error" message:error toView:view];
}

#pragma mark - 显示成功或失败
+ (void)showSuccessOrError:(NSString *)icon message:(NSString *)message toView:(UIView *)view {
    if (view == nil) {
        view = [UIApplication sharedApplication].windows.lastObject;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.dimBackground = YES;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    hud.labelText = message;
    hud.mode = MBProgressHUDModeCustomView;
    [hud hide:YES afterDelay:1];
}

#pragma mark - 显示消息，带返回值
+ (MBProgressHUD *)showMessage:(NSString *)message {
    return [self showMessage:message toView:nil];
}
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) {
        view = [UIApplication sharedApplication].windows.lastObject;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.dimBackground = YES;
    hud.labelText = message;
    return hud;
}

#pragma mark - 隐藏(移除)
+ (void)hideHUD {
    [self hideHUDForView:nil];
}
+ (void)hideHUDForView:(UIView *)view {
    if (view == nil) {
        view = [UIApplication sharedApplication].windows.lastObject;
    }
    [MBProgressHUD hideHUDForView:view animated:YES];
}

@end
