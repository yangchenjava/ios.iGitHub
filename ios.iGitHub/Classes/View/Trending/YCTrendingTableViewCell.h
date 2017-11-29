//
//  YCTrendingTableViewCell.h
//  ios.iGitHub
//
//  Created by 杨晨 on 2017/11/24.
//  Copyright © 2017年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCReposResult;

@interface YCTrendingTableViewCell : UITableViewCell

@property (nonatomic, strong) YCReposResult *repos;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
