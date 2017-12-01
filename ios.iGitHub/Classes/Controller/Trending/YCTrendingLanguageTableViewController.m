//
//  YCTrendingLanguageTableViewController.m
//  ios.iGitHub
//
//  Created by yangc on 2017/11/27.
//  Copyright © 2017年 yangc. All rights reserved.
//

#import <YCHelpKit/MBProgressHUD+Category.h>

#import "YCTrendingLanguageTableViewController.h"
#import "YCTrendingBiz.h"
#import "YCTrendingLanguageResult.h"

@interface YCTrendingLanguageTableViewController () <UISearchResultsUpdating>

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) NSArray <YCTrendingLanguageResult *> *trendingLanguageArray;
@property (nonatomic, strong) NSArray <YCTrendingLanguageResult *> *searchTrendingLanguageArray;

@end

@implementation YCTrendingLanguageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self setupSearch];
    [self setupTrendingLanguage];
}

- (void)setupNavi {
    self.navigationItem.title = @"Languages";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
}

- (void)setupSearch {
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.searchResultsUpdater = self;
    searchController.dimsBackgroundDuringPresentation = NO;
    searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController = searchController;
    self.definesPresentationContext = YES;
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (void)setupTrendingLanguage {
    [YCTrendingBiz trendingLanguageWithSuccess:^(NSArray *results) {
        self.trendingLanguageArray = results;
        NSUInteger row = [self.trendingLanguageArray indexOfObjectPassingTest:^BOOL(YCTrendingLanguageResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [obj.name isEqualToString:self.language];
        }];
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:error.localizedDescription];
    }];
}

- (NSArray <YCTrendingLanguageResult *> *)dataArray {
    return (self.searchController.active && self.searchController.searchBar.text.length) ? self.searchTrendingLanguageArray : self.trendingLanguageArray;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.name contains[cd] %@", searchController.searchBar.text];
    self.searchTrendingLanguageArray = [self.trendingLanguageArray filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"YCTrendingLanguageTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.tintColor = YC_Color_RGB(50, 50, 50);
    }
    cell.textLabel.text = self.dataArray[indexPath.row].name;
    if ([cell.textLabel.text isEqualToString:self.language]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.callback(self.dataArray[indexPath.row]);
    [self dismissVC];
}

- (void)dismissVC {
    if (self.searchController.active) {
        [self.searchController dismissViewControllerAnimated:NO completion:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
