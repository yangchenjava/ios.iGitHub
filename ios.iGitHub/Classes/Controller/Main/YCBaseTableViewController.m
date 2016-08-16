//
//  YCBaseTableViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/15.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <objc/runtime.h>

#import "UIView+Category.h"
#import "YCBaseTableHeaderModelF.h"
#import "YCBaseTableHeaderView.h"
#import "YCBaseTableViewCellGroup.h"
#import "YCBaseTableViewCellItem.h"
#import "YCBaseTableViewController.h"

@interface YCBaseTableViewController ()

@property (nonatomic, weak) UIView *backgroundView;
@property (nonatomic, weak) YCBaseTableHeaderView *tableHeaderView;

@end

@implementation YCBaseTableViewController

- (instancetype)init {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 去掉下边黑线
    UINavigationBar *naviBar = self.navigationController.navigationBar;
    [naviBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [naviBar setShadowImage:[[UIImage alloc] init]];
    // 动态控制cell高度
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 20;
    self.tableView.showsVerticalScrollIndicator = NO;
    // 设置背景
    [self setupBackground];
}

- (void)setupBackground {
    self.tableView.backgroundColor = YC_COLOR(50, 50, 50);
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, self.tableView.width, self.tableView.height)];
    backgroundView.backgroundColor = YC_COLOR(239, 239, 244);
    [self.tableView addSubview:backgroundView];
    [self.tableView sendSubviewToBack:backgroundView];
    self.backgroundView = backgroundView;
}

- (YCBaseTableHeaderView *)tableHeaderView {
    if (_tableHeaderView == nil) {
        YCBaseTableHeaderView *tableHeaderView = [[YCBaseTableHeaderView alloc] init];
        self.tableView.tableHeaderView = tableHeaderView;
        _tableHeaderView = tableHeaderView;
    }
    return _tableHeaderView;
}

- (void)setTableHeaderModel:(YCBaseTableHeaderModel *)tableHeaderModel {
    _tableHeaderModel = tableHeaderModel;

    YCBaseTableHeaderModelF *tableHeaderModelF = [[YCBaseTableHeaderModelF alloc] init];
    tableHeaderModelF.tableHeaderModel = self.tableHeaderModel;

    self.tableHeaderView.tableHeaderModelF = tableHeaderModelF;
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.backgroundView.y = self.tableHeaderView.height;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.backgroundView.height = self.tableView.height + scrollView.contentOffset.y;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    YCBaseTableViewCellGroup *group = self.groupArray[indexPath.section];
    YCBaseTableViewCellItem *item = group.itemArray[indexPath.row];

    if (item.operation != nil) {
        item.operation(item);
    } else if (item.destClass != nil) {
        UIViewController *destViewController = [[item.destClass alloc] init];

        unsigned int count;
        Ivar *ivars = class_copyIvarList(item.destClass, &count);
        for (int i = 0; i < count; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            id value = [item.instanceVariables valueForKey:key];
            if (value && ![value isEqual:[NSNull null]]) {
                [destViewController setValue:value forKey:key];
            }
        }
        destViewController.navigationItem.title = item.title;
        [self.navigationController pushViewController:destViewController animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groupArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YCBaseTableViewCellGroup *group = self.groupArray[section];
    return group.itemArray.count;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *) view;
    header.textLabel.font = [UIFont systemFontOfSize:15];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *) view;
    footer.textLabel.font = [UIFont systemFontOfSize:15];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    YCBaseTableViewCellGroup *group = self.groupArray[section];
    return group.header;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    YCBaseTableViewCellGroup *group = self.groupArray[section];
    return group.footer;
}

@end
