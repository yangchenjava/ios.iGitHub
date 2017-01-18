//
//  YCReposDetailTableViewCell.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/15.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCReposResult;

@interface YCReposDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) YCReposResult *repos;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
