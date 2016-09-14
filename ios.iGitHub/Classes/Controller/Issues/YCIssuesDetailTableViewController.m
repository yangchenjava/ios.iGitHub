//
//  YCIssuesDetailTableViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/27.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>
#import <YCHelpKit/UIView+Category.h>
#import <YCHelpKit/UIViewController+Category.h>

#import "YCBaseTableHeaderModel.h"
#import "YCBaseTableViewCell.h"
#import "YCBaseTableViewCellGroup.h"
#import "YCBaseTableViewCellItem.h"
#import "YCCommentResultF.h"
#import "YCCommentTableFooterView.h"
#import "YCGitHubUtils.h"
#import "YCIssuesBiz.h"
#import "YCIssuesBodyTableViewCell.h"
#import "YCIssuesDetailTableViewCell.h"
#import "YCIssuesDetailTableViewController.h"
#import "YCIssuesResult.h"
#import "YCProfileResult.h"

@interface YCIssuesDetailTableViewController () <YCIssuesBodyTableViewCellDelegate, YCCommentTableFooterViewDelegate>

@property (nonatomic, weak) YCCommentTableFooterView *tableFooterView;

@property (nonatomic, strong) YCIssuesResult *issues;
@property (nonatomic, strong) NSNumber *issuesBodyTableViewCellHeight;

@end

@implementation YCIssuesDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    // 刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupIssues)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 初始化tableHeaderView数据
    if (self.tableHeaderModel == nil) {
        YCBaseTableHeaderModel *tableHeaderModel = [[YCBaseTableHeaderModel alloc] init];
        tableHeaderModel.name = [NSString stringWithFormat:@"Issue #%ld", self.number];
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

- (void)setupIssues {
    [YCIssuesBiz issuesWithUsername:self.username
        reposname:self.reposname
        number:self.number
        success:^(YCIssuesResult *result) {
            self.issues = result;

            YCBaseTableHeaderModel *tableHeaderModel = [[YCBaseTableHeaderModel alloc] init];
            tableHeaderModel.avatar = self.issues.user.avatar_url;
            tableHeaderModel.name = self.issues.title;
            tableHeaderModel.desc = [NSString stringWithFormat:@"updated %@", [YCGitHubUtils dateStringWithDate:self.issues.updated_at]];
            self.tableHeaderModel = tableHeaderModel;

            [self setupGroupArray];

            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
        failure:^(NSError *error) {
            NSLog(@"%@", error.localizedDescription);
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
            NSLog(@"%@", error.localizedDescription);
        }];
}

- (void)setupGroupArray {
    YCBaseTableViewCellGroup *group_0 = [[YCBaseTableViewCellGroup alloc] init];
    group_0.itemArray = @[ [[YCBaseTableViewCellItem alloc] init] ];

    NSMutableArray *itemArray_1 = [NSMutableArray array];
    if (self.issues.body.length) {
        [itemArray_1 addObject:[[YCBaseTableViewCellItem alloc] init]];
    }
    [itemArray_1 addObject:[YCBaseTableViewCellItem itemWithTitle:@"State" icon:@"octicon-gear" subtitle:self.issues.state]];
    [itemArray_1 addObject:[YCBaseTableViewCellItem itemWithTitle:@"Assigned" icon:@"octicon-person" subtitle:self.issues.assignee ? self.issues.assignee.login : @"unassigned"]];
    [itemArray_1 addObject:[YCBaseTableViewCellItem itemWithTitle:@"Created At" icon:@"octicon-pencil" subtitle:[YCGitHubUtils dateStringWithDate:self.issues.created_at]]];
    YCBaseTableViewCellGroup *group_1 = [[YCBaseTableViewCellGroup alloc] init];
    group_1.itemArray = itemArray_1;

    self.groupArray = @[ group_0, group_1 ];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        YCIssuesDetailTableViewCell *tableViewCell = [YCIssuesDetailTableViewCell cellWithTableView:tableView];
        tableViewCell.issues = self.issues;
        cell = tableViewCell;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0 && self.issues.body.length) {
            YCIssuesBodyTableViewCell *tableViewCell = [YCIssuesBodyTableViewCell cellWithTableView:tableView];
            tableViewCell.delegate = self;
            tableViewCell.issues = self.issues;
            cell = tableViewCell;
        } else {
            YCBaseTableViewCellGroup *group = self.groupArray[indexPath.section];
            YCBaseTableViewCellItem *item = group.itemArray[indexPath.row];

            YCBaseTableViewCell *tableViewCell = [YCBaseTableViewCell cellWithTableView:tableView];
            tableViewCell.item = item;
            cell = tableViewCell;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0 && self.issues.body.length) {
        return self.issuesBodyTableViewCellHeight.floatValue;
    }
    return 44;
}

- (void)tableViewCellDidChangeHeight:(YCIssuesBodyTableViewCell *)tableViewCell {
    if (!self.issuesBodyTableViewCellHeight || self.issuesBodyTableViewCellHeight.floatValue != tableViewCell.height) {
        self.issuesBodyTableViewCellHeight = [NSNumber numberWithFloat:tableViewCell.height];
        [self.tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:0 inSection:1] ] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)tableViewCell:(YCIssuesBodyTableViewCell *)tableViewCell didActiveLinkWithURL:(NSURL *)URL {
    [self presentWebViewControllerWithURL:URL animated:YES completion:nil];
}

- (void)tableFooterViewDidChangeHeight:(YCCommentTableFooterView *)tableFooterView {
    self.tableView.tableFooterView = self.tableFooterView;
}

- (void)tableFooterView:(YCCommentTableFooterView *)tableFooterView didActiveLinkWithURL:(NSURL *)URL {
    [self presentWebViewControllerWithURL:URL animated:YES completion:nil];
}

@end
