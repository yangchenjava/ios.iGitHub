//
//  YCContentTableViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/8.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

#import "YCContentTableViewCell.h"
#import "YCContentTableViewController.h"
#import "YCReposBiz.h"
#import "YCSourceViewController.h"

@interface YCContentTableViewController ()

@property (nonatomic, assign) int page;
@property (nonatomic, strong) NSMutableArray *contentArray;

@end

@implementation YCContentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupContent)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupContent {
    self.page = 1;
    if (self.tableView.mj_footer == nil) {
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(setupMoreContent)];
    }

    __weak typeof(self) this = self;
    [YCReposBiz reposContentWithUsername:self.username
        reposname:self.reposname
        path:self.path
        ref:self.ref
        page:self.page
        success:^(id result) {
            NSArray *array = result;
            this.contentArray = [NSMutableArray arrayWithArray:array];
            [this.tableView reloadData];
            [this.tableView.mj_header endRefreshing];
        }
        failure:^(NSError *error) {
            NSLog(@"%@", error.localizedDescription);
        }];
}

- (void)setupMoreContent {
    __weak typeof(self) this = self;
    [YCReposBiz reposContentWithUsername:self.username
        reposname:self.reposname
        path:self.path
        ref:self.ref
        page:++self.page
        success:^(id result) {
            NSArray *array = result;
            [this.contentArray addObjectsFromArray:array];
            [this.tableView reloadData];
            [this.tableView.mj_footer endRefreshing];
            if (array.count < YC_PerPage) {
                self.tableView.mj_footer = nil;
            }
        }
        failure:^(NSError *error) {
            NSLog(@"%@", error.localizedDescription);
        }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCContentTableViewCell *cell = [YCContentTableViewCell cellWithTableView:tableView];
    cell.content = self.contentArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    YCContentResult *content = self.contentArray[indexPath.row];
    if (content.type == ContentTypeDir) {
        YCContentTableViewController *vc = [[YCContentTableViewController alloc] init];
        vc.username = self.username;
        vc.reposname = self.reposname;
        vc.path = content.path;
        vc.ref = self.ref;
        vc.navigationItem.title = content.name;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        YCSourceViewController *vc = [[YCSourceViewController alloc] init];
        vc.username = self.username;
        vc.reposname = self.reposname;
        vc.path = content.path;
        vc.ref = self.ref;
        vc.navigationItem.title = content.name;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
