//
//  YCPullDetailTableViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/4.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>
#import <YCHelpKit/MBProgressHUD+Category.h>
#import <YCHelpKit/UIView+Category.h>
#import <YCHelpKit/UIViewController+Category.h>

#import "YCBaseTableHeaderModel.h"
#import "YCBaseTableViewCell.h"
#import "YCBaseTableViewCellGroup.h"
#import "YCBaseTableViewCellItem.h"
#import "YCCommentResultF.h"
#import "YCCommentTableFooterView.h"
#import "YCCommitTableViewController.h"
#import "YCGitHubUtils.h"
#import "YCIssuesBiz.h"
#import "YCProfileResult.h"
#import "YCPullBiz.h"
#import "YCPullBodyTableViewCell.h"
#import "YCPullDetailTableViewCell.h"
#import "YCPullDetailTableViewController.h"
#import "YCPullResult.h"

@interface YCPullDetailTableViewController () <YCPullBodyTableViewCellDelegate, YCCommentTableFooterViewDelegate>

@property (nonatomic, weak) YCCommentTableFooterView *tableFooterView;

@property (nonatomic, strong) YCPullResult *pull;
@property (nonatomic, strong) NSNumber *pullBodyTableViewCellHeight;

@end

@implementation YCPullDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    // 刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupPull)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 初始化tableHeaderView数据
    if (self.tableHeaderModel == nil) {
        YCBaseTableHeaderModel *tableHeaderModel = [[YCBaseTableHeaderModel alloc] init];
        tableHeaderModel.name = [NSString stringWithFormat:@"Pull Request #%ld", self.number];
        self.tableHeaderModel = tableHeaderModel;
    }
}

- (YCCommentTableFooterView *)tableFooterView {
    if (_tableFooterView == nil) {
        YCCommentTableFooterView *tableFooterView = [[YCCommentTableFooterView alloc] init];
        tableFooterView.delegate = self;
        self.tableView.tableFooterView = tableFooterView;
        _tableFooterView = tableFooterView;
    }
    return _tableFooterView;
}

- (void)setupPull {
    [YCPullBiz pullWithUsername:self.username
        reposname:self.reposname
        number:self.number
        success:^(YCPullResult *result) {
            self.pull = result;

            YCBaseTableHeaderModel *tableHeaderModel = [[YCBaseTableHeaderModel alloc] init];
            tableHeaderModel.avatar = self.pull.user.avatar_url;
            tableHeaderModel.name = self.pull.title;
            tableHeaderModel.desc = [NSString stringWithFormat:@"updated %@", [YCGitHubUtils dateStringWithDate:self.pull.updated_at]];
            self.tableHeaderModel = tableHeaderModel;

            [self setupGroupArray];
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
        failure:^(NSError *error) {
            [MBProgressHUD showError:error.localizedDescription];
            [self.tableView.mj_header endRefreshing];
        }];
    [YCIssuesBiz issuesCommentsWithUsername:self.username
        reposname:self.reposname
        number:self.number
        success:^(NSArray *results) {
            if (results.count) {
                NSMutableArray *commentFArray = [NSMutableArray arrayWithCapacity:results.count];
                for (YCCommentResult *result in results) {
                    YCCommentResultF *commentF = [[YCCommentResultF alloc] init];
                    commentF.comment = result;
                    [commentFArray addObject:commentF];
                }
                self.tableFooterView.commentFArray = commentFArray;
            }
        }
        failure:^(NSError *error) {
            [MBProgressHUD showError:error.localizedDescription];
        }];
}

- (void)setupGroupArray {
    NSMutableArray *itemArray_0 = [NSMutableArray array];
    [itemArray_0 addObject:[[YCBaseTableViewCellItem alloc] init]];
    if (self.pull.body.length) {
        [itemArray_0 addObject:[[YCBaseTableViewCellItem alloc] init]];
    }
    [itemArray_0 addObject:[YCBaseTableViewCellItem itemWithTitle:@"State" icon:@"octicon-gear" subtitle:self.pull.state]];
    [itemArray_0 addObject:[YCBaseTableViewCellItem itemWithTitle:@"Assigned" icon:@"octicon-person" subtitle:self.pull.assignee ? self.pull.assignee.login : @"unassigned"]];
    [itemArray_0 addObject:[YCBaseTableViewCellItem itemWithTitle:@"Created At" icon:@"octicon-calendar" subtitle:[YCGitHubUtils dateStringWithDate:self.pull.created_at]]];
    YCBaseTableViewCellGroup *group_0 = [[YCBaseTableViewCellGroup alloc] init];
    group_0.itemArray = itemArray_0;

    YCBaseTableViewCellItem *item_1_0 = [YCBaseTableViewCellItem itemWithTitle:@"Commits" icon:@"octicon-git-commit" subtitle:nil destClass:[YCCommitTableViewController class] instanceVariables:@{ @"username": self.username, @"reposname": self.reposname, @"number": @(self.number) }];
    YCBaseTableViewCellGroup *group_1 = [[YCBaseTableViewCellGroup alloc] init];
    group_1.itemArray = @[ item_1_0 ];

    self.groupArray = @[ group_0, group_1 ];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0 && indexPath.row == 0) {
        YCPullDetailTableViewCell *tableViewCell = [YCPullDetailTableViewCell cellWithTableView:tableView];
        tableViewCell.pull = self.pull;
        cell = tableViewCell;
    } else if (indexPath.section == 0 && indexPath.row == 1 && self.pull.body.length) {
        YCPullBodyTableViewCell *tableViewCell = [YCPullBodyTableViewCell cellWithTableView:tableView];
        tableViewCell.delegate = self;
        tableViewCell.pull = self.pull;
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
        return 111;
    }
    if (indexPath.section == 0 && indexPath.row == 1 && self.pull.body.length) {
        return self.pullBodyTableViewCellHeight.floatValue;
    }
    return 44;
}

- (void)tableViewCellDidChangeHeight:(YCPullBodyTableViewCell *)tableViewCell {
    if (!self.pullBodyTableViewCellHeight || self.pullBodyTableViewCellHeight.floatValue != tableViewCell.height) {
        self.pullBodyTableViewCellHeight = [NSNumber numberWithFloat:tableViewCell.height];
        [self.tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:0 inSection:0] ] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)tableViewCell:(YCPullBodyTableViewCell *)tableViewCell didActiveLinkWithURL:(NSURL *)URL {
    [self presentWebViewControllerWithURL:URL animated:YES completion:nil];
}

- (void)tableFooterViewDidChangeHeight:(YCCommentTableFooterView *)tableFooterView {
    self.tableView.tableFooterView = self.tableFooterView;
    [self.tableView reloadData];
}

- (void)tableFooterView:(YCCommentTableFooterView *)tableFooterView didActiveLinkWithURL:(NSURL *)URL {
    [self presentWebViewControllerWithURL:URL animated:YES completion:nil];
}

@end
