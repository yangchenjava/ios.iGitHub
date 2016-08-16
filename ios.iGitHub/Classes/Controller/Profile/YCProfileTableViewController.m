//
//  YCProfileTableViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/9.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <DateTools/DateTools.h>
#import <MJRefresh/MJRefresh.h>

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

@property (nonatomic, strong) YCProfileResult *profile;

@end

@implementation YCProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (NSString *)username {
    if (_username == nil) {
        _username = [YCGitHubUtils profile].login;
    }
    return _username;
}

- (void)setupProfile {
    __weak typeof(self) this = self;
    [YCProfileBiz profileWithUserName:self.username
        success:^(YCProfileResult *result) {
            this.profile = result;

            YCBaseTableHeaderModel *tableHeaderModel = [[YCBaseTableHeaderModel alloc] init];
            tableHeaderModel.avatar = this.profile.avatar_url;
            tableHeaderModel.name = this.profile.login;
            tableHeaderModel.desc = this.profile.name;
            this.tableHeaderModel = tableHeaderModel;

            [this setupGroupArray];

            [this.tableView reloadData];
            [this.tableView.mj_header endRefreshing];
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
            @"_username" : self.username
        }];
    YCBaseTableViewCellItem *item_2_1 =
        [YCBaseTableViewCellItem itemWithTitle:@"Events" icon:@"octicon-rss" subtitle:nil destClass:[YCEventsTableViewController class] instanceVariables:@{
            @"_username" : self.username
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
