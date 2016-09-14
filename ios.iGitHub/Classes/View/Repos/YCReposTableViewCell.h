//
//  YCReposTableViewCell.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/11.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCReposResult;

@interface YCReposTableViewCell : UITableViewCell

@property (nonatomic, strong) YCReposResult *repos;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
