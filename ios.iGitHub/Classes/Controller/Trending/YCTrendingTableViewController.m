//
//  YCTrendingTableViewController.m
//  ios.iGitHub
//
//  Created by yangc on 2017/11/24.
//  Copyright © 2017年 yangc. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>
#import <YCHelpKit/MBProgressHUD+Category.h>

#import "YCNavigationController.h"
#import "YCTrendingTableViewController.h"
#import "YCTrendingLanguageTableViewController.h"
#import "YCReposDetailTableViewController.h"
#import "YCTrendingBiz.h"
#import "YCReposResult.h"
#import "YCProfileResult.h"
#import "YCTrendingLanguageResult.h"
#import "YCTrendingLanguageButton.h"
#import "YCTrendingTableViewHeaderFooterView.h"
#import "YCTrendingTableViewCell.h"

@interface YCTrendingTableViewController ()

@property (nonatomic, weak) YCTrendingLanguageButton *button;

@property (nonatomic, strong, readonly) NSArray <NSString *> *trendingTitleArray;
@property (nonatomic, strong, readonly) NSMutableDictionary <NSString *, NSArray <YCReposResult *> *> *trendingDictionary;
@property (nonatomic, strong) YCTrendingLanguageResult *trendingLanguage;

@end

@implementation YCTrendingTableViewController

- (instancetype)init {
    if (self = [super init]) {
        _trendingTitleArray = @[ @"Daily", @"Weekly", @"Monthly" ];
        _trendingDictionary = [NSMutableDictionary dictionaryWithCapacity:_trendingTitleArray.count];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self setupTableView];
}

- (void)setupNavi {
    // 设置不透明，去掉下边黑线
    UINavigationBar *naviBar = self.navigationController.navigationBar;
    naviBar.barTintColor = YC_Color_RGB(50, 50, 50);
    naviBar.translucent = NO;
    [naviBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [naviBar setShadowImage:[[UIImage alloc] init]];
    // 设置navi button
    YCTrendingLanguageButton *button = [YCTrendingLanguageButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"All Languages" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickLanguageButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = button;
    self.button = button;
}

- (void)clickLanguageButton {
    YCTrendingLanguageTableViewController *vc = [[YCTrendingLanguageTableViewController alloc] init];
    vc.language = self.button.titleLabel.text;
    vc.callback = ^(YCTrendingLanguageResult *trendingLanguage) {
        self.trendingLanguage = trendingLanguage;
        [self.button setTitle:self.trendingLanguage.name forState:UIControlStateNormal];
        [self.tableView.mj_header beginRefreshing];
    };
    [self presentViewController:[[YCNavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

- (void)setupTableView {
    // 动态控制cell高度
    self.tableView.estimatedRowHeight = YC_CellDefaultHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupTrending)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupTrending {
    // 日
    [YCTrendingBiz trendingDailyWithLanguage:self.trendingLanguage.slug success:^(NSArray *results) {
        [self.trendingDictionary setValue:results forKey:self.trendingTitleArray[0]];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:error.localizedDescription];
        [self.tableView.mj_header endRefreshing];
    }];
    // 周
    [YCTrendingBiz trendingWeeklyWithLanguage:self.trendingLanguage.slug success:^(NSArray *results) {
        [self.trendingDictionary setValue:results forKey:self.trendingTitleArray[1]];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:error.localizedDescription];
        [self.tableView.mj_header endRefreshing];
    }];
    // 月
    [YCTrendingBiz trendingMonthlyWithLanguage:self.trendingLanguage.slug success:^(NSArray *results) {
        [self.trendingDictionary setValue:results forKey:self.trendingTitleArray[2]];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:error.localizedDescription];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.trendingDictionary.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.trendingDictionary[self.trendingTitleArray[section]].count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YCTrendingTableViewHeaderFooterView *view = [YCTrendingTableViewHeaderFooterView viewWithTableView:tableView];
    view.title = self.trendingTitleArray[section];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [YCTrendingTableViewHeaderFooterView height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCTrendingTableViewCell *cell = [YCTrendingTableViewCell cellWithTableView:tableView];
    cell.repos = self.trendingDictionary[self.trendingTitleArray[indexPath.section]][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YCReposResult *repos = self.trendingDictionary[self.trendingTitleArray[indexPath.section]][indexPath.row];
    
    YCReposDetailTableViewController *vc = [[YCReposDetailTableViewController alloc] init];
    vc.username = repos.owner.login;
    vc.reposname = repos.name;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
