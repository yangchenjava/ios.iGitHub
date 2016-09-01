//
//  YCNewsTableViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/9.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

#import "YCGitHubUtils.h"
#import "YCNewsBiz.h"
#import "YCNewsResult.h"
#import "YCNewsTableViewCell.h"
#import "YCNewsTableViewController.h"

@interface YCNewsTableViewController ()

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
    [YCNewsBiz newsWithUsername:[YCGitHubUtils profile].login
        success:^(NSArray *results) {
            self.newsArray = results;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
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
    cell.news = self.newsArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    YCNewsResult *news = self.newsArray[indexPath.row];
    YCNewsTableViewCell *cell = (YCNewsTableViewCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
    [cell attributedLabel:nil didSelectLinkWithURL:news.attrURL];
}

@end
