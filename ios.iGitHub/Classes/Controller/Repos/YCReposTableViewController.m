//
//  YCReposTableViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/9.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

#import "YCGitHubUtils.h"
#import "YCProfileResult.h"
#import "YCReposBiz.h"
#import "YCReposDetailTableViewController.h"
#import "YCReposResult.h"
#import "YCReposTableViewCell.h"
#import "YCReposTableViewController.h"

@interface YCReposTableViewController ()

@property (nonatomic, assign) int page;
@property (nonatomic, strong) NSMutableArray *reposArray;

@end

@implementation YCReposTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (iOS11_OR_Later && self.navigationController.childViewControllers.count > 1) {
        do {
            _Pragma("clang diagnostic push")
            _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")
            if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {
                [self.tableView performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@2];
            }
            _Pragma("clang diagnostic pop")
        } while (0);
    }
    // 动态控制cell高度
    self.tableView.estimatedRowHeight = YC_CellDefaultHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupRepos)];
    [self.tableView.mj_header beginRefreshing];
}

- (NSString *)username {
    if (_username == nil) {
        _username = [YCGitHubUtils profile].login;
    }
    return _username;
}

- (void)setupRepos {
    self.page = 1;
    if (self.tableView.mj_footer == nil) {
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(setupMoreRepos)];
    }

    [YCReposBiz reposWithUsername:self.username
        page:self.page
        success:^(NSArray *results) {
            self.reposArray = [NSMutableArray arrayWithArray:results];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
        failure:^(NSError *error) {
            NSLog(@"%@", error.localizedDescription);
        }];
}

- (void)setupMoreRepos {
    [YCReposBiz reposWithUsername:self.username
        page:++self.page
        success:^(NSArray *results) {
            [self.reposArray addObjectsFromArray:results];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            if (results.count < YC_PerPage) {
                self.tableView.mj_footer = nil;
            }
        }
        failure:^(NSError *error) {
            NSLog(@"%@", error.localizedDescription);
        }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reposArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCReposTableViewCell *cell = [YCReposTableViewCell cellWithTableView:tableView];
    cell.repos = self.reposArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    YCReposResult *repos = self.reposArray[indexPath.row];

    YCReposDetailTableViewController *vc = [[YCReposDetailTableViewController alloc] init];
    vc.username = repos.owner.login;
    vc.reposname = repos.name;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
