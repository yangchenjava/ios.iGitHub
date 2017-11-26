//
//  YCEventsTableViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/9.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>
#import <YCHelpKit/MBProgressHUD+Category.h>

#import "YCEventsBiz.h"
#import "YCEventsResult.h"
#import "YCEventsResultF.h"
#import "YCEventsTableViewCell.h"
#import "YCEventsTableViewController.h"
#import "YCGitHubUtils.h"
#import "YCProfileResult.h"

@interface YCEventsTableViewController ()

@property (nonatomic, assign) int page;
@property (nonatomic, strong) NSMutableArray *eventsFArray;

@end

@implementation YCEventsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupEvents)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(setupMoreEvents)];
    [self.tableView.mj_header beginRefreshing];
}

- (NSString *)username {
    if (_username == nil) {
        _username = [YCGitHubUtils profile].login;
    }
    return _username;
}

- (void)setupEvents {
    [self.tableView.mj_footer resetNoMoreData];
    self.page = 1;

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
            self.eventsFArray = eventsFArray;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
        failure:^(NSError *error) {
            [MBProgressHUD showError:error.localizedDescription];
            [self.tableView.mj_header endRefreshing];
        }];
}

- (void)setupMoreEvents {
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
            [self.eventsFArray addObjectsFromArray:eventsFArray];
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

#pragma mark - tableView代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.eventsFArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCEventsTableViewCell *cell = [YCEventsTableViewCell cellWithTableView:tableView];
    cell.eventsF = self.eventsFArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCEventsResultF *eventsF = self.eventsFArray[indexPath.row];
    return eventsF.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    YCEventsResultF *eventsF = self.eventsFArray[indexPath.row];
    YCEventsTableViewCell *cell = (YCEventsTableViewCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
    [cell attributedLabel:nil didSelectLinkWithURL:eventsF.events.attrURL];
}

@end
