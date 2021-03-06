//
//  YCIssuesViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/2.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>
#import <YCHelpKit/MBProgressHUD+Category.h>

#import "YCIssuesBiz.h"
#import "YCIssuesDetailTableViewController.h"
#import "YCIssuesResult.h"
#import "YCIssuesTableViewCell.h"
#import "YCIssuesViewController.h"

@interface YCIssuesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomConstraint;

@property (nonatomic, copy) NSString *state;
@property (nonatomic, assign) int page;
@property (nonatomic, strong) NSMutableArray *issuesArray;

@end

@implementation YCIssuesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 动态控制cell高度
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = YC_CellDefaultHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    [self.segmentedControl addTarget:self action:@selector(ChangeSegmentedControl:) forControlEvents:UIControlEventValueChanged];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupIssues)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(setupMoreIssues)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    self.viewBottomConstraint.constant = YC_TabBarBottomSafeMargin;
}

- (void)ChangeSegmentedControl:(UISegmentedControl *)segmentedControl {
    self.state = [segmentedControl titleForSegmentAtIndex:segmentedControl.selectedSegmentIndex].lowercaseString;
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupIssues {
    self.segmentedControl.enabled = NO;
    [self.tableView.mj_footer resetNoMoreData];
    self.page = 1;

    [YCIssuesBiz issuesWithUsername:self.username
        reposname:self.reposname
        state:self.state
        page:self.page
        success:^(NSArray *results) {
            self.issuesArray = [NSMutableArray arrayWithArray:results];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            self.segmentedControl.enabled = YES;
        }
        failure:^(NSError *error) {
            [MBProgressHUD showError:error.localizedDescription];
            [self.tableView.mj_header endRefreshing];
            self.segmentedControl.enabled = YES;
        }];
}

- (void)setupMoreIssues {
    self.segmentedControl.enabled = NO;

    [YCIssuesBiz issuesWithUsername:self.username
        reposname:self.reposname
        state:self.state
        page:++self.page
        success:^(NSArray *results) {
            [self.issuesArray addObjectsFromArray:results];
            [self.tableView reloadData];
            self.segmentedControl.enabled = YES;
            if (results.count < YC_PerPage) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
        }
        failure:^(NSError *error) {
            [MBProgressHUD showError:error.localizedDescription];
            [self.tableView.mj_footer endRefreshing];
            self.segmentedControl.enabled = YES;
        }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.issuesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCIssuesTableViewCell *cell = [YCIssuesTableViewCell cellWithTableView:tableView];
    cell.issues = self.issuesArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    YCIssuesResult *issues = self.issuesArray[indexPath.row];

    YCIssuesDetailTableViewController *vc = [[YCIssuesDetailTableViewController alloc] init];
    vc.username = self.username;
    vc.reposname = self.reposname;
    vc.number = issues.number;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
