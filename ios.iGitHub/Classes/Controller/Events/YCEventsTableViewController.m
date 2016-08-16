//
//  YCEventsTableViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/9.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

#import "YCBranchTableViewController.h"
#import "YCCommitDetailTableViewController.h"
#import "YCEventsBiz.h"
#import "YCEventsTableViewCell.h"
#import "YCEventsTableViewController.h"
#import "YCGitHubUtils.h"
#import "YCIssuesDetailTableViewController.h"
#import "YCProfileTableViewController.h"
#import "YCPullDetailTableViewController.h"
#import "YCReposDetailTableViewController.h"

@interface YCEventsTableViewController () <YCEventsTableViewCellDelegate>

@property (nonatomic, assign) int page;
@property (nonatomic, strong) NSMutableArray *eventsFArray;

@end

@implementation YCEventsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupEvents)];
    [self.tableView.mj_header beginRefreshing];
}

- (NSString *)username {
    if (_username == nil) {
        _username = [YCGitHubUtils profile].login;
    }
    return _username;
}

- (void)setupEvents {
    self.page = 1;
    if (self.tableView.mj_footer == nil) {
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(setupMoreEvents)];
    }

    __weak typeof(self) this = self;
    [YCEventsBiz eventsWithUsername:self.username
        reposname:self.reposname
        page:self.page
        success:^(NSArray *results) {
            NSMutableArray *eventsFArray = [NSMutableArray arrayWithCapacity:results.count];
            for (YCEventsResult *result in results) {
                YCEventsResultF *eventsF = [[YCEventsResultF alloc] init];
                eventsF.events = result;
                [eventsFArray addObject:eventsF];
            }
            this.eventsFArray = eventsFArray;
            [this.tableView reloadData];
            [this.tableView.mj_header endRefreshing];
        }
        failure:^(NSError *error) {
            NSLog(@"%@", error.localizedDescription);
        }];
}

- (void)setupMoreEvents {
    __weak typeof(self) this = self;
    [YCEventsBiz eventsWithUsername:self.username
        reposname:self.reposname
        page:++self.page
        success:^(NSArray *results) {
            NSMutableArray *eventsFArray = [NSMutableArray arrayWithCapacity:results.count];
            for (YCEventsResult *result in results) {
                YCEventsResultF *eventsF = [[YCEventsResultF alloc] init];
                eventsF.events = result;
                [eventsFArray addObject:eventsF];
            }
            [this.eventsFArray addObjectsFromArray:eventsFArray];
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

#pragma mark - tableView代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.eventsFArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCEventsTableViewCell *cell = [YCEventsTableViewCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.eventsF = self.eventsFArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCEventsResultF *eventsF = self.eventsFArray[indexPath.row];
    return eventsF.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - cell内连接代理

- (void)tableViewCell:(YCEventsTableViewCell *)tableViewCell didClickUsername:(NSString *)username {
    YCProfileTableViewController *vc = [[YCProfileTableViewController alloc] init];
    vc.username = username;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableViewCell:(YCEventsTableViewCell *)tableViewCell didClickUsername:(NSString *)username reposname:(NSString *)reposname {
    YCReposDetailTableViewController *vc = [[YCReposDetailTableViewController alloc] init];
    vc.username = username;
    vc.reposname = reposname;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableViewCell:(YCEventsTableViewCell *)tableViewCell didClickUsername:(NSString *)username forkeeReposname:(NSString *)forkeeReposname {
    YCReposDetailTableViewController *vc = [[YCReposDetailTableViewController alloc] init];
    vc.username = username;
    vc.reposname = forkeeReposname;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableViewCell:(YCEventsTableViewCell *)tableViewCell didClickUsername:(NSString *)username reposname:(NSString *)reposname issueNumber:(long)issueNumber {
    YCIssuesDetailTableViewController *vc = [[YCIssuesDetailTableViewController alloc] init];
    vc.username = username;
    vc.reposname = reposname;
    vc.number = issueNumber;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableViewCell:(YCEventsTableViewCell *)tableViewCell didClickUsername:(NSString *)username reposname:(NSString *)reposname pullRequestNumber:(long)pullRequestNumber {
    YCPullDetailTableViewController *vc = [[YCPullDetailTableViewController alloc] init];
    vc.username = username;
    vc.reposname = reposname;
    vc.number = pullRequestNumber;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableViewCell:(YCEventsTableViewCell *)tableViewCell didClickUsername:(NSString *)username reposname:(NSString *)reposname branch:(NSString *)branch {
    YCBranchTableViewController *vc = [[YCBranchTableViewController alloc] init];
    vc.username = username;
    vc.reposname = reposname;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableViewCell:(YCEventsTableViewCell *)tableViewCell didClickUsername:(NSString *)username reposname:(NSString *)reposname sha:(NSString *)sha {
    YCCommitDetailTableViewController *vc = [[YCCommitDetailTableViewController alloc] init];
    vc.username = username;
    vc.reposname = reposname;
    vc.sha = sha;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
