//
//  YCIssuesTableViewCell.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/26.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YCIssuesResult.h"

@interface YCIssuesTableViewCell : UITableViewCell

@property (nonatomic, strong) YCIssuesResult *issues;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
