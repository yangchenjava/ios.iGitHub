//
//  YCEventsTableViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/9.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

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
            NSLog(@"%@", error.localizedDescription);
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
            [self.tableView.mj_footer endRefreshing];
            if (results.count < YC_PerPage) {
                self.tableView.mj_footer = nil;
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
