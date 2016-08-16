//
//  YCCommitTableViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/3.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

#import "YCCommitBiz.h"
#import "YCCommitDetailTableViewController.h"
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
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupCommit)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupCommit {
    self.page = 1;
    if (self.tableView.mj_footer == nil) {
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(setupMoreCommit)];
    }

    __weak typeof(self) this = self;
    if (self.number) {
        [YCCommitBiz commitWithUsername:self.username
            reposname:self.reposname
            number:self.number.longValue
            page:self.page
            success:^(NSArray *results) {
                this.commitArray = [NSMutableArray arrayWithArray:results];
                [this.tableView reloadData];
                [this.tableView.mj_header endRefreshing];
            }
            failure:^(NSError *error) {
                NSLog(@"%@", error.localizedDescription);
            }];
    } else {
        [YCCommitBiz commitWithUsername:self.username
            reposname:self.reposname
            page:self.page
            success:^(NSArray *results) {
                this.commitArray = [NSMutableArray arrayWithArray:results];
                [this.tableView reloadData];
                [this.tableView.mj_header endRefreshing];
            }
            failure:^(NSError *error) {
                NSLog(@"%@", error.localizedDescription);
            }];
    }
}

- (void)setupMoreCommit {
    __weak typeof(self) this = self;
    if (self.number) {
        [YCCommitBiz commitWithUsername:self.username
            reposname:self.reposname
            number:self.number.longValue
            page:++self.page
            success:^(NSArray *results) {
                [this.commitArray addObjectsFromArray:results];
                [this.tableView reloadData];
                [this.tableView.mj_footer endRefreshing];
                if (results.count < YC_PerPage) {
                    this.tableView.mj_footer = nil;
                }
            }
            failure:^(NSError *error) {
                NSLog(@"%@", error.localizedDescription);
            }];
    } else {
        [YCCommitBiz commitWithUsername:self.username
            reposname:self.reposname
            page:++self.page
            success:^(NSArray *results) {
                [this.commitArray addObjectsFromArray:results];
                [this.tableView reloadData];
                [this.tableView.mj_footer endRefreshing];
                if (results.count < YC_PerPage) {
                    this.tableView.mj_footer = nil;
                }
            }
            failure:^(NSError *error) {
                NSLog(@"%@", error.localizedDescription);
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
