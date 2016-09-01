//
//  YCProfileTableViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/9.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <DateTools/DateTools.h>
#import <MJRefresh/MJRefresh.h>
#import <YCHelpKit/UIImage+Category.h>
#import <YCHelpKit/UIView+Category.h>

#import "YCBaseTableViewCell.h"
#import "YCBaseTableViewCellGroup.h"
#import "YCBaseTableViewCellItem.h"
#import "YCEventsTableViewController.h"
#import "YCGitHubUtils.h"
#import "YCProfileBiz.h"
#import "YCProfileTableViewCell.h"
#import "YCProfileTableViewController.h"
#import "YCReposTableViewController.h"

@interface YCProfileTableViewController ()

@property (nonatomic, weak) UIView *tableFooterView;

@property (nonatomic, strong) YCProfileResult *profile;

@end

@implementation YCProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    self.tableView.tableFooterView = self.tableFooterView;
    // 刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupProfile)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 初始化tableHeaderView数据
    if (self.tableHeaderModel == nil) {
        YCBaseTableHeaderModel *tableHeaderModel = [[YCBaseTableHeaderModel alloc] init];
        tableHeaderModel.name = self.username;
        self.tableHeaderModel = tableHeaderModel;
    }
}

- (UIView *)tableFooterView {
    if (_tableFooterView == nil) {
        CGRect frame = CGRectMake(0, 0, self.tableView.width, self.tableView.estimatedRowHeight);

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        [button setTitle:@"Sign Out" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:YC_Color_RGB(217, 217, 217)] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(signout) forControlEvents:UIControlEventTouchUpInside];

        UIView *tableFooterView = [[UIView alloc] initWithFrame:frame];
        tableFooterView.hidden = YES;
        [tableFooterView addSubview:button];
        self.tableView.tableFooterView = tableFooterView;
        _tableFooterView = tableFooterView;
    } else {
        _tableFooterView.hidden = NO;
    }
    return _tableFooterView;
}

- (NSString *)username {
    if (_username == nil) {
        _username = [YCGitHubUtils profile].login;
    }
    return _username;
}

- (void)signout {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"sure to sign out?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

#warning AttributedTitle is a private API
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:@"sure to sign out?"];
    [attributedTitle addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, attributedTitle.length)];
    [attributedTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22] range:NSMakeRange(0, attributedTitle.length)];
    [alertController setValue:attributedTitle forKey:@"attributedTitle"];

    UIAlertAction *signout = [UIAlertAction actionWithTitle:@"Sign Out"
                                                      style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction *action) {
                                                        [YCGitHubUtils setOAuth:nil];
                                                        [YCGitHubUtils setProfile:nil];
                                                        [YCGitHubUtils setupRootViewController];
                                                    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:signout];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)setupProfile {
    [YCProfileBiz profileWithUserName:self.username
        success:^(YCProfileResult *result) {
            self.profile = result;

            YCBaseTableHeaderModel *tableHeaderModel = [[YCBaseTableHeaderModel alloc] init];
            tableHeaderModel.avatar = self.profile.avatar_url;
            tableHeaderModel.name = self.profile.login;
            tableHeaderModel.desc = self.profile.name;
            self.tableHeaderModel = tableHeaderModel;

            [self setupGroupArray];

            [self.tableView reloadData];
            self.tableView.tableFooterView = self.tableFooterView;
            [self.tableView.mj_header endRefreshing];
        }
        failure:^(NSError *error) {
            NSLog(@"%@", error.localizedDescription);
        }];
}

- (void)setupGroupArray {
    YCBaseTableViewCellGroup *group_0 = [[YCBaseTableViewCellGroup alloc] init];
    group_0.itemArray = @[ [[YCBaseTableViewCellItem alloc] init] ];

    NSMutableArray *itemArray = [NSMutableArray array];
    if (self.profile.company.length) {
        [itemArray addObject:[YCBaseTableViewCellItem itemWithTitle:self.profile.company icon:@"octicon-organization"]];
    }
    if (self.profile.location.length) {
        [itemArray addObject:[YCBaseTableViewCellItem itemWithTitle:self.profile.location icon:@"octicon-location"]];
    }
    if (self.profile.email.length) {
        [itemArray addObject:[YCBaseTableViewCellItem itemWithTitle:self.profile.email icon:@"octicon-mail"]];
    }
    if (self.profile.created_at) {
        [itemArray addObject:[YCBaseTableViewCellItem
                                 itemWithTitle:[self.profile.created_at formattedDateWithFormat:@"'Joined on' d MMM yyyy" locale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]]
                                          icon:@"octicon-clock"]];
    }
    YCBaseTableViewCellGroup *group_1 = [[YCBaseTableViewCellGroup alloc] init];
    group_1.itemArray = itemArray;

    YCBaseTableViewCellItem *item_2_0 =
        [YCBaseTableViewCellItem itemWithTitle:@"Repos" icon:@"octicon-repo" subtitle:nil destClass:[YCReposTableViewController class] instanceVariables:@{
            @"username" : self.username
        }];
    YCBaseTableViewCellItem *item_2_1 =
        [YCBaseTableViewCellItem itemWithTitle:@"Events" icon:@"octicon-rss" subtitle:nil destClass:[YCEventsTableViewController class] instanceVariables:@{
            @"username" : self.username
        }];
    YCBaseTableViewCellGroup *group_2 = [[YCBaseTableViewCellGroup alloc] init];
    group_2.itemArray = @[ item_2_0, item_2_1 ];

    self.groupArray = @[ group_0, group_1, group_2 ];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        YCProfileTableViewCell *tableViewCell = [YCProfileTableViewCell cellWithTableView:tableView];
        tableViewCell.profile = self.profile;
        cell = tableViewCell;
    } else {
        YCBaseTableViewCellGroup *group = self.groupArray[indexPath.section];
        YCBaseTableViewCellItem *item = group.itemArray[indexPath.row];

        YCBaseTableViewCell *tableViewCell = [YCBaseTableViewCell cellWithTableView:tableView];
        tableViewCell.item = item;
        cell = tableViewCell;
    }
    return cell;
}

@end
