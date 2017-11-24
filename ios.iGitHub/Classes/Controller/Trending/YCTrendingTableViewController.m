//
//  YCTrendingTableViewController.m
//  ios.iGitHub
//
//  Created by yangc on 2017/11/24.
//  Copyright © 2017年 yangc. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

#import "YCTrendingTableViewController.h"
#import "YCTrendingBiz.h"
#import "YCTrendingResult.h"
#import "YCTrendingTableViewHeaderFooterView.h"

@interface YCTrendingTableViewController ()

@property (nonatomic, strong, readonly) NSArray <NSString *> *trendingTitleArray;
@property (nonatomic, strong, readonly) NSMutableDictionary <NSString *, NSArray *> *trendingDictionary;
@property (nonatomic, copy) NSString *language;

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
    // 设置不透明，去掉下边黑线
    UINavigationBar *naviBar = self.navigationController.navigationBar;
    naviBar.barTintColor = YC_Color_RGB(50, 50, 50);
    naviBar.translucent = NO;
    [naviBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [naviBar setShadowImage:[[UIImage alloc] init]];
    // 动态控制cell高度
    self.tableView.estimatedRowHeight = YC_CellDefaultHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupTrending)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupTrending {
    // 日
    [YCTrendingBiz trendingDailyWithLanguage:self.language success:^(NSArray *results) {
        [self.trendingDictionary setValue:results forKey:self.trendingTitleArray[0]];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    // 周
    [YCTrendingBiz trendingWeeklyWithLanguage:self.language success:^(NSArray *results) {
        [self.trendingDictionary setValue:results forKey:self.trendingTitleArray[1]];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    // 月
    [YCTrendingBiz trendingMonthlyWithLanguage:self.language success:^(NSArray *results) {
        [self.trendingDictionary setValue:results forKey:self.trendingTitleArray[2]];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"%@", error.localizedDescription);
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
    static NSString *ID = @"YCTrendingTableViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = [self.trendingDictionary[self.trendingTitleArray[indexPath.section]][indexPath.row] repo];
    return cell;
}

@end
