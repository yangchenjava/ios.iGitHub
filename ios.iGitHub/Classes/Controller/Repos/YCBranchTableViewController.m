//
//  YCBranchTableViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/9.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

#import "YCBranchTableViewCell.h"
#import "YCBranchTableViewController.h"
#import "YCContentTableViewController.h"
#import "YCReposBiz.h"

@interface YCBranchTableViewController ()

@property (nonatomic, weak) UISegmentedControl *segmentedControl;

@property (nonatomic, assign) int page;
@property (nonatomic, strong) NSMutableArray *branchArray;

@end

@implementation YCBranchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSegmentedControl];
    // 刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupBranch)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupSegmentedControl {
    NSArray *items = @[ @"Branches", @"Tags" ];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    segmentedControl.frame = CGRectMake(0, 0, 100, 26);
    segmentedControl.selectedSegmentIndex = [self.state isEqualToString:@"tags"] ? 1 : 0;
    [segmentedControl addTarget:self action:@selector(ChangeSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    self.segmentedControl = segmentedControl;
}

- (void)ChangeSegmentedControl:(UISegmentedControl *)segmentedControl {
    self.state = [segmentedControl titleForSegmentAtIndex:segmentedControl.selectedSegmentIndex].lowercaseString;
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupBranch {
    self.segmentedControl.enabled = NO;
    self.page = 1;
    if (self.tableView.mj_footer == nil) {
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(setupMoreBranch)];
    }

    [YCReposBiz reposBranchOrTagWithUsername:self.username
        reposname:self.reposname
        state:self.state
        page:self.page
        success:^(NSArray *results) {
            self.branchArray = [NSMutableArray arrayWithArray:results];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            self.segmentedControl.enabled = YES;
        }
        failure:^(NSError *error) {
            NSLog(@"%@", error.localizedDescription);
        }];
}

- (void)setupMoreBranch {
    self.segmentedControl.enabled = NO;

    [YCReposBiz reposBranchOrTagWithUsername:self.username
        reposname:self.reposname
        state:self.state
        page:++self.page
        success:^(NSArray *results) {
            [self.branchArray addObjectsFromArray:results];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            self.segmentedControl.enabled = YES;
            if (results.count < YC_PerPage) {
                self.tableView.mj_footer = nil;
            }
        }
        failure:^(NSError *error) {
            NSLog(@"%@", error.localizedDescription);
        }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.branchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCBranchTableViewCell *cell = [YCBranchTableViewCell cellWithTableView:tableView];
    cell.branch = self.branchArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    YCBranchResult *branch = self.branchArray[indexPath.row];

    YCContentTableViewController *vc = [[YCContentTableViewController alloc] init];
    vc.username = self.username;
    vc.reposname = self.reposname;
    vc.ref = branch.name;
    vc.navigationItem.title = self.reposname;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
