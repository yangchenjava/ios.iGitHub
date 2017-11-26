//
//  YCProfileTableViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/9.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <DateTools/DateTools.h>
#import <MJRefresh/MJRefresh.h>
#import <YCHelpKit/MBProgressHUD+Category.h>
#import <YCHelpKit/UIAlertController+Category.h>

#import "YCBaseTableHeaderModel.h"
#import "YCBaseTableViewCell.h"
#import "YCBaseTableViewCellGroup.h"
#import "YCBaseTableViewCellItem.h"
#import "YCEventsTableViewController.h"
#import "YCGitHubUtils.h"
#import "YCProfileBiz.h"
#import "YCProfileResult.h"
#import "YCProfileTableFooterView.h"
#import "YCProfileTableViewCell.h"
#import "YCProfileTableViewController.h"
#import "YCReposTableViewController.h"

@interface YCProfileTableViewController () <YCProfileTableFooterViewDelegate>

@property (nonatomic, weak) YCProfileTableFooterView *tableFooterView;

@property (nonatomic, strong) YCProfileResult *profile;

@end

@implementation YCProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
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
        CGRect frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.estimatedRowHeight);
        YCProfileTableFooterView *tableFooterView = [[YCProfileTableFooterView alloc] initWithFrame:frame];
        tableFooterView.delegate = self;
        self.tableView.tableFooterView = tableFooterView;
        _tableFooterView = tableFooterView;
    }
    return _tableFooterView;
}

- (NSString *)username {
    if (_username == nil) {
        _username = [YCGitHubUtils profile].login;
    }
    return _username;
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
            
            if ([self.username isEqualToString:[YCGitHubUtils profile].login]) {
                self.tableView.tableFooterView = self.tableFooterView;
            }
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
        failure:^(NSError *error) {
            [MBProgressHUD showError:error.localizedDescription];
            [self.tableView.mj_header endRefreshing];
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
        [itemArray addObject:[YCBaseTableViewCellItem itemWithTitle:[self.profile.created_at formattedDateWithFormat:@"'Joined on' d MMM yyyy" locale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]] icon:@"octicon-clock"]];
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

- (void)tableFooterViewDidClick:(YCProfileTableFooterView *)tableFooterView {
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"注销" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [YCGitHubUtils setOAuth:nil];
        [YCGitHubUtils setProfile:nil];
        [YCGitHubUtils setupRootViewController];
    }];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定注销吗？" message:nil preferredStyle:UIAlertControllerStyleActionSheet alertActions:@[ action ]];

    [self presentViewController:alertController animated:YES completion:nil];
}

@end
