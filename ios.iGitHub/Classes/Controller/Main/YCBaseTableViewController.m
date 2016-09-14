//
//  YCBaseTableViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/15.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <YCHelpKit/UIView+Category.h>
#import <objc/runtime.h>

#import "YCBaseTableHeaderModel.h"
#import "YCBaseTableHeaderModelF.h"
#import "YCBaseTableHeaderView.h"
#import "YCBaseTableViewCellGroup.h"
#import "YCBaseTableViewCellItem.h"
#import "YCBaseTableViewController.h"

@interface YCBaseTableViewController ()

@property (nonatomic, weak) UIButton *titleButton;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置titleView
    UINavigationBar *naviBar = self.navigationController.navigationBar;
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.userInteractionEnabled = NO;
    titleButton.frame = CGRectMake(60, 0, naviBar.width - 120, naviBar.height);
    titleButton.hidden = YES;
    [titleButton setTitle:self.tableHeaderModel.name forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [naviBar addSubview:titleButton];
    self.titleButton = titleButton;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self scrollViewDidScroll:self.tableView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.titleButton removeFromSuperview];
}

- (void)setupBackground {
    self.tableView.backgroundColor = YC_Color_RGB(50, 50, 50);
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, self.tableView.width, self.tableView.height)];
    backgroundView.backgroundColor = YC_Color_RGB(239, 239, 244);
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

    [self.titleButton setTitle:self.tableHeaderModel.name forState:UIControlStateNormal];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.backgroundView.height = self.tableView.height + scrollView.contentOffset.y;

    // title所在位置的Y值
    CGFloat position = 105;
    if (scrollView.contentOffset.y >= position) {
        CGFloat top = self.titleButton.height - (scrollView.contentOffset.y - position);
        self.titleButton.hidden = NO;
        [UIView animateWithDuration:0.5
                         animations:^{
                             self.titleButton.alpha = 1;
                             self.titleButton.contentEdgeInsets = UIEdgeInsetsMake(top > 0 ? top : 0, 0, 0, 0);
                         }];
    } else {
        [UIView animateWithDuration:0.5
            animations:^{
                self.titleButton.alpha = 0;
            }
            completion:^(BOOL finished) {
                if (finished) {
                    self.titleButton.hidden = YES;
                }
            }];
    }
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
            NSString *key = [[NSString stringWithUTF8String:ivar_getName(ivar)] substringFromIndex:1];
            id value = [item.instanceVariables valueForKey:key];
            if (value && ![value isEqual:[NSNull null]]) {
                [destViewController setValue:value forKey:key];
            }
        }
        // 如果目标vc不继承自YCBaseTableViewController，则主动设置navi的title
        if (![destViewController isKindOfClass:[YCBaseTableViewController class]]) {
            destViewController.navigationItem.title = item.title;
        }
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
