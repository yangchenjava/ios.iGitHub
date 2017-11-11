//
//  YCTableViewController.m
//  ios.iGitHub
//
//  Created by 杨晨 on 2017/11/11.
//  Copyright © 2017年 yangc. All rights reserved.
//

#import "YCTableViewController.h"

@interface YCTableViewController ()

@end

@implementation YCTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (iOS11_OR_Later && self.hidesBottomBarWhenPushed) {
        do {
            _Pragma("clang diagnostic push")
            _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")
            if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {
                [self.tableView performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@2];
            }
            _Pragma("clang diagnostic pop")
        } while (0);
    }
}

@end
