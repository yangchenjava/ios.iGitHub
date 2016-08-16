//
//  UIViewController+Category.h
//  ios.iGitHub
//
//  Created by yangc on 16/8/16.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <SafariServices/SafariServices.h>
#import <UIKit/UIKit.h>

@interface UIViewController (Category) <SFSafariViewControllerDelegate>

@property (nonatomic, strong, readonly) NSNumber *statusBarStyle;

- (void)presentWebViewControllerWithURL:(NSURL *)URL animated:(BOOL)animated completion:(void (^)())completion;

@end
