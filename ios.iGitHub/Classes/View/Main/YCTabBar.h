//
//  YCTabBar.h
//  ios.iGitHub
//
//  Created by yangc on 16-3-28.
//  Copyright (c) 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCTabBar;

@protocol YCTabBarDelegate <NSObject>

@optional
- (void)tabBar:(YCTabBar *)tabBar didClickTabBarButtonFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface YCTabBar : UIView

@property (nonatomic, weak) id<YCTabBarDelegate> delegate;

- (void)addTabBarItem:(UITabBarItem *)tabBarItem;

@end
