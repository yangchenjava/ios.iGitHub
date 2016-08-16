//
//  YCNewsTableViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/9.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

#import "YCGitHubUtils.h"
#import "YCIssuesDetailTableViewController.h"
#import "YCNewsBiz.h"
#import "YCNewsResult.h"
#import "YCNewsTableViewCell.h"
#import "YCNewsTableViewController.h"
#import "YCProfileTableViewController.h"
#import "YCReposDetailTableViewController.h"

@interface YCNewsTableViewController () <YCNewsTableViewCellDelegate>

@property (nonatomic, strong) NSArray *newsArray;

@end

@implementation YCNewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 动态控制cell高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupNews)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupNews {
    __weak typeof(self) this = self;
    [YCNewsBiz newsWithUsername:[YCGitHubUtils profile].login
        success:^(NSArray *results) {
            this.newsArray = results;
            [this.tableView reloadData];
            [this.tableView.mj_header endRefreshing];
        }
        failure:^(NSError *error) {
            NSLog(@"%@", error.localizedDescription);
        }];
}

#pragma mark - tableView代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCNewsTableViewCell *cell = [YCNewsTableViewCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.news = self.newsArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    YCNewsResult *news = self.newsArray[indexPath.row];
    switch (news.type) {
        case NewsTypeForkEvent: {
            NSString *fullName = news.payload.forkee.full_name;
            NSUInteger index = [fullName rangeOfString:@"/"].location;
            [self tableViewCell:nil didClickUsername:[fullName substringToIndex:index] forkeeReposname:[fullName substringFromIndex:index + 1]];
            break;
        }
        case NewsTypeIssuesEvent: {
            NSString *fullName = news.repo.name;
            NSUInteger index = [fullName rangeOfString:@"/"].location;
            [self tableViewCell:nil didClickUsername:[fullName substringToIndex:index] reposname:[fullName substringFromIndex:index + 1] number:news.payload.issue.number];
            break;
        }
        case NewsTypeWatchEvent: {
            NSString *fullName = news.repo.name;
            NSUInteger index = [fullName rangeOfString:@"/"].location;
            [self tableViewCell:nil didClickUsername:[fullName substringToIndex:index] reposname:[fullName substringFromIndex:index + 1]];
            break;
        }
    }
}

#pragma mark - cell内连接代理

- (void)tableViewCell:(YCNewsTableViewCell *)tableViewCell didClickUsername:(NSString *)username {
    YCProfileTableViewController *vc = [[YCProfileTableViewController alloc] init];
    vc.username = username;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableViewCell:(YCNewsTableViewCell *)tableViewCell didClickUsername:(NSString *)username reposname:(NSString *)reposname {
    YCReposDetailTableViewController *vc = [[YCReposDetailTableViewController alloc] init];
    vc.username = username;
    vc.reposname = reposname;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableViewCell:(YCNewsTableViewCell *)tableViewCell didClickUsername:(NSString *)username forkeeReposname:(NSString *)forkeeReposname {
    YCReposDetailTableViewController *vc = [[YCReposDetailTableViewController alloc] init];
    vc.username = username;
    vc.reposname = forkeeReposname;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableViewCell:(YCNewsTableViewCell *)tableViewCell didClickUsername:(NSString *)username reposname:(NSString *)reposname number:(long)number {
    YCIssuesDetailTableViewController *vc = [[YCIssuesDetailTableViewController alloc] init];
    vc.username = username;
    vc.reposname = reposname;
    vc.number = number;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
