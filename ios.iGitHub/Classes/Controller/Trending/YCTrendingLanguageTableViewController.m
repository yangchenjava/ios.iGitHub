//
//  YCTrendingLanguageTableViewController.m
//  ios.iGitHub
//
//  Created by yangc on 2017/11/27.
//  Copyright © 2017年 yangc. All rights reserved.
//

#import <MJExtension/MJExtension.h>
#import <YCHelpKit/MBProgressHUD+Category.h>

#import "YCTrendingLanguageTableViewController.h"
#import "YCTrendingBiz.h"
#import "YCTrendingLanguageResult.h"

@interface YCTrendingLanguageTableViewController ()

@property (nonatomic, strong) NSArray <YCTrendingLanguageResult *> *trendingLanguageArray;

@end

@implementation YCTrendingLanguageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    [YCTrendingBiz trendingLanguageWithSuccess:^(NSArray *results) {
        self.trendingLanguageArray = results;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:error.localizedDescription];
    }];
}

- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.trendingLanguageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"YCTrendingLanguageTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.tintColor = YC_Color_RGB(50, 50, 50);
    }
    cell.textLabel.text = self.trendingLanguageArray[indexPath.row].name;
    if ([cell.textLabel.text isEqualToString:self.language]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.callback(self.trendingLanguageArray[indexPath.row]);
    [self dismissVC];
}

@end
