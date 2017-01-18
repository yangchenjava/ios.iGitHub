//
//  YCReposDetailTableViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/14.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>
#import <YCHelpKit/UIView+Category.h>

#import "YCBaseTableHeaderModel.h"
#import "YCBaseTableViewCell.h"
#import "YCBaseTableViewCellGroup.h"
#import "YCBaseTableViewCellItem.h"
#import "YCBranchTableViewController.h"
#import "YCCommitTableViewController.h"
#import "YCEventsTableViewController.h"
#import "YCIssuesViewController.h"
#import "YCProfileResult.h"
#import "YCProfileTableViewController.h"
#import "YCPullViewController.h"
#import "YCReadmeViewController.h"
#import "YCReposBiz.h"
#import "YCReposDetailTableViewCell.h"
#import "YCReposDetailTableViewController.h"
#import "YCReposResult.h"

@interface YCReposDetailTableViewController ()

@property (nonatomic, strong) YCReposResult *repos;
@property (nonatomic, strong) YCReadmeResult *readme;

@end

@implementation YCReposDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupReadme)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 初始化tableHeaderView数据
    if (self.tableHeaderModel == nil) {
        YCBaseTableHeaderModel *tableHeaderModel = [[YCBaseTableHeaderModel alloc] init];
        tableHeaderModel.name = self.reposname;
        self.tableHeaderModel = tableHeaderModel;
    }
}

- (void)setupReadme {
    [YCReposBiz reposReadmeWithUsername:self.username
        reposname:self.reposname
        success:^(YCReadmeResult *result) {
            self.readme = result;
            [self setupRepos];
        }
        failure:^(NSError *error) {
            NSLog(@"%@", error.localizedDescription);
            [self setupRepos];
        }];
}

- (void)setupRepos {
    [YCReposBiz reposWithUsername:self.username
        reposname:self.reposname
        success:^(YCReposResult *result) {
            self.repos = result;

            YCBaseTableHeaderModel *tableHeaderModel = [[YCBaseTableHeaderModel alloc] init];
            tableHeaderModel.avatar = self.repos.owner.avatar_url;
            tableHeaderModel.name = self.repos.name;
            tableHeaderModel.desc = self.repos.desc;
            self.tableHeaderModel = tableHeaderModel;

            [self setupGroupArray];

            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
        failure:^(NSError *error) {
            NSLog(@"%@", error.localizedDescription);
        }];
}

- (void)setupGroupArray {
    NSMutableArray *itemArray_0 = [NSMutableArray array];
    [itemArray_0 addObject:[[YCBaseTableViewCellItem alloc] init]];
    [itemArray_0 addObject:[YCBaseTableViewCellItem itemWithTitle:@"Owner"
                                                             icon:@"octicon-person"
                                                         subtitle:self.repos.owner.login
                                                        destClass:[YCProfileTableViewController class]
                                                instanceVariables:@{
                                                    @"username" : self.repos.owner.login
                                                }]];
    if (self.repos.parent) {
        [itemArray_0 addObject:[YCBaseTableViewCellItem itemWithTitle:@"Forked From"
                                                                 icon:@"octicon-repo-forked"
                                                             subtitle:nil
                                                            destClass:[YCReposDetailTableViewController class]
                                                    instanceVariables:@{
                                                        @"username" : self.repos.parent.owner.login,
                                                        @"reposname" : self.repos.parent.name
                                                    }]];
    }
    YCBaseTableViewCellGroup *group_0 = [[YCBaseTableViewCellGroup alloc] init];
    group_0.itemArray = itemArray_0;

    NSMutableArray *itemArray_1 = [NSMutableArray array];
    [itemArray_1 addObject:[YCBaseTableViewCellItem itemWithTitle:@"Events"
                                                             icon:@"octicon-rss"
                                                         subtitle:nil
                                                        destClass:[YCEventsTableViewController class]
                                                instanceVariables:@{
                                                    @"username" : self.repos.owner.login,
                                                    @"reposname" : self.repos.name
                                                }]];
    [itemArray_1 addObject:[YCBaseTableViewCellItem itemWithTitle:@"Issues"
                                                             icon:@"octicon-issue-opened"
                                                         subtitle:nil
                                                        destClass:[YCIssuesViewController class]
                                                instanceVariables:@{
                                                    @"username" : self.repos.owner.login,
                                                    @"reposname" : self.repos.name
                                                }]];
    if (self.readme) {
        [itemArray_1
            addObject:[YCBaseTableViewCellItem itemWithTitle:@"Readme" icon:@"octicon-book" subtitle:nil destClass:[YCReadmeViewController class] instanceVariables:@{
                @"readme" : self.readme
            }]];
    }
    YCBaseTableViewCellGroup *group_1 = [[YCBaseTableViewCellGroup alloc] init];
    group_1.itemArray = itemArray_1;

    YCBaseTableViewCellItem *item_2_0 = [YCBaseTableViewCellItem itemWithTitle:@"Commits"
                                                                          icon:@"octicon-git-commit"
                                                                      subtitle:nil
                                                                     destClass:[YCCommitTableViewController class]
                                                             instanceVariables:@{
                                                                 @"username" : self.repos.owner.login,
                                                                 @"reposname" : self.repos.name
                                                             }];
    YCBaseTableViewCellItem *item_2_1 = [YCBaseTableViewCellItem itemWithTitle:@"Pull Requests"
                                                                          icon:@"octicon-git-pull-request"
                                                                      subtitle:nil
                                                                     destClass:[YCPullViewController class]
                                                             instanceVariables:@{
                                                                 @"username" : self.repos.owner.login,
                                                                 @"reposname" : self.repos.name
                                                             }];
    YCBaseTableViewCellItem *item_2_2 = [YCBaseTableViewCellItem itemWithTitle:@"Source"
                                                                          icon:@"octicon-code"
                                                                      subtitle:nil
                                                                     destClass:[YCBranchTableViewController class]
                                                             instanceVariables:@{
                                                                 @"username" : self.repos.owner.login,
                                                                 @"reposname" : self.repos.name
                                                             }];
    YCBaseTableViewCellGroup *group_2 = [[YCBaseTableViewCellGroup alloc] init];
    group_2.itemArray = @[ item_2_0, item_2_1, item_2_2 ];

    self.groupArray = @[ group_0, group_1, group_2 ];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0 && indexPath.row == 0) {
        YCReposDetailTableViewCell *tableViewCell = [YCReposDetailTableViewCell cellWithTableView:tableView];
        tableViewCell.repos = self.repos;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 201;
    }
    return 44;
}

@end
