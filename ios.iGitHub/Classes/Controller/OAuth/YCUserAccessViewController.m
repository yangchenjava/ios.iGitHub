//
//  YCUserAccessViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/6.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <YCHelpKit/UIView+Category.h>

#import "YCOAuthViewController.h"
#import "YCUserAccessButton.h"
#import "YCUserAccessViewController.h"

@interface YCUserAccessViewController ()

@end

@implementation YCUserAccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // self.view.frame.origin.y会下移64个点至navigationBar下方
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"New Account";
    [self setupUserAccessButton];
}

- (void)setupUserAccessButton {
    YCUserAccessButton *dotcomButton = [YCUserAccessButton buttonWithType:UIButtonTypeCustom];
    [dotcomButton setImage:[UIImage imageNamed:@"dotcom-mascot"] forState:UIControlStateNormal];
    [dotcomButton setTitle:@"GitHub.com" forState:UIControlStateNormal];
    [dotcomButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    dotcomButton.backgroundColor = YC_Color_RGB(240, 239, 245);
    [dotcomButton addTarget:self action:@selector(clickDotcomButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dotcomButton];

    YCUserAccessButton *enterpriseButton = [YCUserAccessButton buttonWithType:UIButtonTypeCustom];
    [enterpriseButton setImage:[UIImage imageNamed:@"enterprise-mascot"] forState:UIControlStateNormal];
    [enterpriseButton setTitle:@"Enterprise" forState:UIControlStateNormal];
    [enterpriseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    enterpriseButton.backgroundColor = YC_Color_RGB(50, 50, 50);
    [self.view addSubview:enterpriseButton];

    [dotcomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        make.height.mas_equalTo(self.view.mas_height).multipliedBy(0.5);
    }];

    [enterpriseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(dotcomButton.mas_bottom);
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        make.height.mas_equalTo(dotcomButton.mas_height);
    }];
}

- (void)clickDotcomButton {
    [self.navigationController pushViewController:[[YCOAuthViewController alloc] init] animated:YES];
}

@end
