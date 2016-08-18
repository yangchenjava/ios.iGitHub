//
//  YCUserAccessViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/6.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <YCHelpKit/UIView+Category.h>

#import "YCOAuthViewController.h"
#import "YCUserAccessButton.h"
#import "YCUserAccessViewController.h"

@interface YCUserAccessViewController ()

@end

@implementation YCUserAccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"New Account";
    [self setupUserAccessButton];
}

- (void)setupUserAccessButton {
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navigationBarHeight = self.navigationController.navigationBar.height;

    YCUserAccessButton *dotcomButton = [YCUserAccessButton buttonWithType:UIButtonTypeCustom];
    CGFloat dotcomX = 0;
    CGFloat dotcomY = 0;
    CGFloat dotcomW = self.view.width;
    CGFloat dotcomH = (self.view.height - statusBarHeight - navigationBarHeight) * 0.5;
    dotcomButton.frame = CGRectMake(dotcomX, dotcomY, dotcomW, dotcomH);
    [dotcomButton setImage:[UIImage imageNamed:@"dotcom-mascot"] forState:UIControlStateNormal];
    [dotcomButton setTitle:@"GitHub.com" forState:UIControlStateNormal];
    [dotcomButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    dotcomButton.backgroundColor = YC_COLOR(240, 239, 245);
    [dotcomButton addTarget:self action:@selector(clickDotcomButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dotcomButton];

    YCUserAccessButton *enterpriseButton = [YCUserAccessButton buttonWithType:UIButtonTypeCustom];
    CGFloat enterpriseX = 0;
    CGFloat enterpriseY = CGRectGetMaxY(dotcomButton.frame);
    CGFloat enterpriseW = dotcomW;
    CGFloat enterpriseH = dotcomH;
    enterpriseButton.frame = CGRectMake(enterpriseX, enterpriseY, enterpriseW, enterpriseH);
    [enterpriseButton setImage:[UIImage imageNamed:@"enterprise-mascot"] forState:UIControlStateNormal];
    [enterpriseButton setTitle:@"Enterprise" forState:UIControlStateNormal];
    [enterpriseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    enterpriseButton.backgroundColor = YC_COLOR(50, 50, 50);
    [self.view addSubview:enterpriseButton];
}

- (void)clickDotcomButton {
    [self.navigationController pushViewController:[[YCOAuthViewController alloc] init] animated:YES];
}

@end
