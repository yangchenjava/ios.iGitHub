//
//  YCPullTableViewCell.h
//  ios.iGitHub
//
//  Created by yangc on 16/8/4.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCPullResult;

@interface YCPullTableViewCell : UITableViewCell

@property (nonatomic, strong) YCPullResult *pull;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
