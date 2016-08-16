//
//  YCPullDetailTableViewCell.h
//  ios.iGitHub
//
//  Created by yangc on 16/8/4.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YCPullResult.h"

@interface YCPullDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) YCPullResult *pull;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
