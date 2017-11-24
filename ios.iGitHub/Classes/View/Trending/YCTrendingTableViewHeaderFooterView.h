//
//  YCTrendingTableViewHeaderFooterView.h
//  ios.iGitHub
//
//  Created by 杨晨 on 2017/11/24.
//  Copyright © 2017年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCTrendingTableViewHeaderFooterView : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *title;

+ (instancetype)viewWithTableView:(UITableView *)tableView;
+ (CGFloat)height;

@end
