//
//  YCIssuesDetailTableViewCell.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/27.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YCIssuesResult.h"

@interface YCIssuesDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) YCIssuesResult *issues;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
