//
//  YCTabBarController.m
//  ios.iGitHub
//
//  Created by yangc on 16/6/23.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import "FontAwesomeKit.h"
#import "YCBaseTableViewController.h"
#import "YCEventsTableViewController.h"
#import "YCNavigationController.h"
#import "YCNewsTableViewController.h"
#import "YCProfileTableViewController.h"
#import "YCReposTableViewController.h"
#import "YCTabBar.h"
#import "YCTabBarController.h"

@interface YCTabBarController () <YCTabBarDelegate>

@property (nonatomic, weak) YCTabBar *mTabBar;

@end

@implementation YCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTabBar];
    [self setupTabBarItem];
}
// ios10
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    // 清空原有TabBar
//    for (UIView *view in self.tabBar.subviews) {
//        if ([view isKindOfClass:[UIControl class]]) {
//            [view removeFromSuperview];
//        }
//    }
//}

// ios11
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    // 清空原有TabBar
    for (UIView *view in self.tabBar.subviews) {
        if ([view isKindOfClass:[UIControl class]]) {
            [view removeFromSuperview];
        }
    }
}

/**
 *  @author yangc, 16-06-23 15:06:32
 *
 *  初始化TabBar
 */
- (void)setupTabBar {
    YCTabBar *mTabBar = [[YCTabBar alloc] initWithFrame:self.tabBar.bounds];
    mTabBar.delegate = self;
    [self.tabBar addSubview:mTabBar];
    self.mTabBar = mTabBar;
}

/**
 *  @author yangc, 16-06-23 15:06:53
 *
 *  初始化TabBarItem
 */
- (void)setupTabBarItem {
    YCReposTableViewController *reposVC = [[YCReposTableViewController alloc] init];
    [self addChildVC:reposVC title:@"Repos" imageName:@"octicon-repo" selectedImageName:@"octicon-repo" badgeValue:nil];

    YCNewsTableViewController *newsVC = [[YCNewsTableViewController alloc] init];
    [self addChildVC:newsVC title:@"News" imageName:@"octicon-radio-tower" selectedImageName:@"octicon-radio-tower" badgeValue:nil];

    YCEventsTableViewController *eventsVC = [[YCEventsTableViewController alloc] init];
    [self addChildVC:eventsVC title:@"Events" imageName:@"octicon-rss" selectedImageName:@"octicon-rss" badgeValue:nil];

    YCProfileTableViewController *profileVC = [[YCProfileTableViewController alloc] init];
    [self addChildVC:profileVC title:@"Profiles" imageName:@"octicon-person" selectedImageName:@"octicon-person" badgeValue:nil];
}

- (void)addChildVC:(UIViewController *)vc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName badgeValue:(NSString *)badgeValue {
    if (![vc isKindOfClass:[YCBaseTableViewController class]]) vc.navigationItem.title = title;
    vc.tabBarItem.title = title;

    FAKOcticons *icon = [FAKOcticons iconWithIdentifier:imageName size:25 error:NULL];
    [icon addAttribute:NSForegroundColorAttributeName value:YC_Color_RGB(130, 130, 130)];
    // vc.tabBarItem.image = [[icon imageWithSize:CGSizeMake(25, 25)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.image = [icon imageWithSize:CGSizeMake(25, 25)];

    FAKOcticons *selectedIcon = [FAKOcticons iconWithIdentifier:selectedImageName size:25 error:NULL];
    [selectedIcon addAttribute:NSForegroundColorAttributeName value:YC_Color_RGB(50, 50, 50)];
    vc.tabBarItem.selectedImage = [selectedIcon imageWithSize:CGSizeMake(25, 25)];

    vc.tabBarItem.badgeValue = badgeValue;
    YCNavigationController *navi = [[YCNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:navi];

    [self.mTabBar addTabBarItem:vc.tabBarItem];
}

- (void)tabBar:(YCTabBar *)tabBar didClickTabBarButtonFrom:(NSInteger)from to:(NSInteger)to {
    self.selectedIndex = to;
}

@end
