//
//  YCContentTableViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/8.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>
#import <YCHelpKit/MBProgressHUD+Category.h>

#import "YCContentResult.h"
#import "YCContentTableViewCell.h"
#import "YCContentTableViewController.h"
#import "YCReposBiz.h"
#import "YCSourceViewController.h"

@interface YCContentTableViewController ()

@property (nonatomic, strong) NSArray *contentArray;

@end

@implementation YCContentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupContent)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupContent {
    [YCReposBiz reposContentWithUsername:self.username
        reposname:self.reposname
        path:self.path
        ref:self.ref
        success:^(id result) {
            self.contentArray = result;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
        failure:^(NSError *error) {
            [MBProgressHUD showError:error.localizedDescription];
            [self.tableView.mj_header endRefreshing];
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
        vc.download_url = content.download_url;
        vc.ref = self.ref;
        vc.navigationItem.title = content.name;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
