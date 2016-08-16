//
//  MBProgressHUD+Category.h
//  ios_utils
//
//  Created by yangc on 16-2-6.
//  Copyright (c) 2016年 yangc. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Category)

/** 显示成功 */
+ (void)showSuccess:(NSString *)success;
/** 显示成功 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

/** 显示失败 */
+ (void)showError:(NSString *)error;
/** 显示失败 */
+ (void)showError:(NSString *)error toView:(UIView *)view;

/** 显示消息，带返回值 */
+ (MBProgressHUD *)showMessage:(NSString *)message;
/** 显示消息，带返回值 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

/** 隐藏(移除) */
+ (void)hideHUD;
/** 隐藏(移除) */
+ (void)hideHUDForView:(UIView *)view;

@end
