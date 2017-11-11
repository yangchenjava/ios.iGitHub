//
//  YCPullViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/4.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <MJRefresh/MJRefresh.h>

#import "FontAwesomeKit.h"
#import "YCPullBiz.h"
#import "YCPullDetailTableViewController.h"
#import "YCPullResult.h"
#import "YCPullTableViewCell.h"
#import "YCPullViewController.h"

@interface YCPullViewController () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomConstraint;

@property (nonatomic, copy) NSString *state;
@property (nonatomic, assign) int page;
@property (nonatomic, strong) NSMutableArray *pullArray;

@end

@implementation YCPullViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 动态控制cell高度
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = YC_CellDefaultHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;

    [self.segmentedControl addTarget:self action:@selector(ChangeSegmentedControl:) forControlEvents:UIControlEventValueChanged];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupPull)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(setupMorePull)];
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

- (void)setupPull {
    self.segmentedControl.enabled = NO;
    [self.tableView.mj_footer resetNoMoreData];
    self.page = 1;

    [YCPullBiz pullWithUsername:self.username
        reposname:self.reposname
        state:self.state
        page:self.page
        success:^(NSArray *results) {
            self.pullArray = [NSMutableArray arrayWithArray:results];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            self.segmentedControl.enabled = YES;
        }
        failure:^(NSError *error) {
            NSLog(@"%@", error.localizedDescription);
        }];
}

- (void)setupMorePull {
    self.segmentedControl.enabled = NO;

    [YCPullBiz pullWithUsername:self.username
        reposname:self.reposname
        state:self.state
        page:++self.page
        success:^(NSArray *results) {
            [self.pullArray addObjectsFromArray:results];
            [self.tableView reloadData];
            self.segmentedControl.enabled = YES;
            if (results.count < YC_PerPage) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
        }
        failure:^(NSError *error) {
            NSLog(@"%@", error.localizedDescription);
        }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    tableView.separatorStyle = self.pullArray.count ? UITableViewCellSeparatorStyleSingleLine : UITableViewCellSeparatorStyleNone;
    return self.pullArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCPullTableViewCell *cell = [YCPullTableViewCell cellWithTableView:tableView];
    cell.pull = self.pullArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    YCPullResult *pull = self.pullArray[indexPath.row];

    YCPullDetailTableViewController *vc = [[YCPullDetailTableViewController alloc] init];
    vc.username = self.username;
    vc.reposname = self.reposname;
    vc.number = pull.number;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    FAKOcticons *gitPullRequestIcon = [FAKOcticons gitPullRequestIconWithSize:60];
    [gitPullRequestIcon addAttribute:NSForegroundColorAttributeName value:YC_Color_RGB(50, 50, 50)];
    return [gitPullRequestIcon imageWithSize:CGSizeMake(60, 60)];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"There are no pull requests.";
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15], NSForegroundColorAttributeName : YC_Color_RGB(50, 50, 50)};
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

@end
