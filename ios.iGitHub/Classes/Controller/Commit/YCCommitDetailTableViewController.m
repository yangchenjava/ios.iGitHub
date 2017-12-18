//
//  YCCommitDetailTableViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/5.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>
#import <YCHelpKit/MBProgressHUD+Category.h>

#import "YCBaseTableHeaderModel.h"
#import "YCBaseTableViewCellGroup.h"
#import "YCCommitBiz.h"
#import "YCCommitBodyTableViewCell.h"
#import "YCCommitDetailResult.h"
#import "YCCommitDetailTableViewCell.h"
#import "YCCommitDetailTableViewController.h"
#import "YCCommitFileResult.h"
#import "YCCommitPatchViewController.h"
#import "YCCommitResult.h"
#import "YCCommitTableViewCellItem.h"
#import "YCGitHubUtils.h"
#import "YCProfileResult.h"

@interface YCCommitDetailTableViewController ()

@property (nonatomic, strong) YCCommitResult *commit;

@end

@implementation YCCommitDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.sectionHeaderHeight = 20;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    // 刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupCommit)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 初始化tableHeaderView数据
    if (self.tableHeaderModel == nil) {
        YCBaseTableHeaderModel *tableHeaderModel = [[YCBaseTableHeaderModel alloc] init];
        tableHeaderModel.name = [NSString stringWithFormat:@"Commited %@", [self.sha substringToIndex:6]];
        self.tableHeaderModel = tableHeaderModel;
    }
}

- (void)setupCommit {
    [YCCommitBiz commitWithUsername:self.username
        reposname:self.reposname
        sha:self.sha
        success:^(YCCommitResult *result) {
            self.commit = result;

            YCBaseTableHeaderModel *tableHeaderModel = [[YCBaseTableHeaderModel alloc] init];
            tableHeaderModel.avatar = self.commit.committer.avatar_url;
            tableHeaderModel.name = self.commit.commit.message;
            tableHeaderModel.desc = [NSString stringWithFormat:@"Commited %@", [YCGitHubUtils dateStringWithDate:self.commit.commit.committer.date]];
            self.tableHeaderModel = tableHeaderModel;

            [self setupGroupArray];

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
    group_0.itemArray = @[ [[YCCommitTableViewCellItem alloc] init] ];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (YCCommitFileResult *commitFile in self.commit.files) {
        YCCommitTableViewCellItem *item = [YCCommitTableViewCellItem itemWithTitle:commitFile.filename.lastPathComponent
                                                                              icon:nil
                                                                          subtitle:commitFile.status
                                                                         destClass:[YCCommitPatchViewController class]
                                                                 instanceVariables:@{
                                                                     @"rawURL" : commitFile.raw_url.length ? commitFile.raw_url : [NSNull null],
                                                                     @"patch" : commitFile.patch.length ? commitFile.patch : [NSNull null]
                                                                 }];
        item.additions = commitFile.additions;
        item.deletions = commitFile.deletions;

        NSString *key = [NSString stringWithFormat:@"/%@", commitFile.filename.stringByDeletingLastPathComponent.uppercaseString];
        NSMutableArray *value = [dict valueForKey:key];
        if (value) {
            [value addObject:item];
        } else {
            value = [NSMutableArray arrayWithObject:item];
            [dict setValue:value forKey:key];
        }
    }

    NSMutableArray *groupArray = [NSMutableArray arrayWithObject:group_0];
    for (NSString *key in [dict.allKeys sortedArrayUsingSelector:@selector(compare:)]) {
        YCBaseTableViewCellGroup *group = [[YCBaseTableViewCellGroup alloc] init];
        group.header = key;
        group.itemArray = [dict valueForKey:key];
        [groupArray addObject:group];
    }
    [dict removeAllObjects];

    self.groupArray = groupArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0 && indexPath.row == 0) {
        YCCommitDetailTableViewCell *tableViewCell = [YCCommitDetailTableViewCell cellWithTableView:tableView];
        tableViewCell.commit = self.commit;
        cell = tableViewCell;
    } else {
        YCBaseTableViewCellGroup *group = self.groupArray[indexPath.section];
        YCCommitTableViewCellItem *item = group.itemArray[indexPath.row];

        YCCommitBodyTableViewCell *tableViewCell = [YCCommitBodyTableViewCell cellWithTableView:tableView];
        tableViewCell.item = item;
        cell = tableViewCell;
    }
    return cell;
}

@end
