//
//  YCCommitTableViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/3.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>
#import <YCHelpKit/MBProgressHUD+Category.h>

#import "YCCommitBiz.h"
#import "YCCommitDetailTableViewController.h"
#import "YCCommitResult.h"
#import "YCCommitTableViewCell.h"
#import "YCCommitTableViewController.h"

@interface YCCommitTableViewController ()

@property (nonatomic, assign) int page;
@property (nonatomic, strong) NSMutableArray *commitArray;

@end

@implementation YCCommitTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 动态控制cell高度
    self.tableView.estimatedRowHeight = YC_CellDefaultHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupCommit)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(setupMoreCommit)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupCommit {
    [self.tableView.mj_footer resetNoMoreData];
    self.page = 1;

    if (self.number) {
        [YCCommitBiz commitWithUsername:self.username
            reposname:self.reposname
            number:self.number.longValue
            page:self.page
            success:^(NSArray *results) {
                self.commitArray = [NSMutableArray arrayWithArray:results];
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            }
            failure:^(NSError *error) {
                [MBProgressHUD showError:error.localizedDescription];
                [self.tableView.mj_header endRefreshing];
            }];
    } else {
        [YCCommitBiz commitWithUsername:self.username
            reposname:self.reposname
            page:self.page
            success:^(NSArray *results) {
                self.commitArray = [NSMutableArray arrayWithArray:results];
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            }
            failure:^(NSError *error) {
                [MBProgressHUD showError:error.localizedDescription];
                [self.tableView.mj_header endRefreshing];
            }];
    }
}

- (void)setupMoreCommit {
    if (self.number) {
        [YCCommitBiz commitWithUsername:self.username
            reposname:self.reposname
            number:self.number.longValue
            page:++self.page
            success:^(NSArray *results) {
                [self.commitArray addObjectsFromArray:results];
                [self.tableView reloadData];
                if (results.count < YC_PerPage) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.tableView.mj_footer endRefreshing];
                }
            }
            failure:^(NSError *error) {
                [MBProgressHUD showError:error.localizedDescription];
                [self.tableView.mj_footer endRefreshing];
            }];
    } else {
        [YCCommitBiz commitWithUsername:self.username
            reposname:self.reposname
            page:++self.page
            success:^(NSArray *results) {
                [self.commitArray addObjectsFromArray:results];
                [self.tableView reloadData];
                if (results.count < YC_PerPage) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.tableView.mj_footer endRefreshing];
                }
            }
            failure:^(NSError *error) {
                [MBProgressHUD showError:error.localizedDescription];
                [self.tableView.mj_footer endRefreshing];
            }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commitArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCCommitTableViewCell *cell = [YCCommitTableViewCell cellWithTableView:tableView];
    cell.commit = self.commitArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    YCCommitResult *commit = self.commitArray[indexPath.row];

    YCCommitDetailTableViewController *vc = [[YCCommitDetailTableViewController alloc] init];
    vc.username = self.username;
    vc.reposname = self.reposname;
    vc.sha = commit.sha;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
