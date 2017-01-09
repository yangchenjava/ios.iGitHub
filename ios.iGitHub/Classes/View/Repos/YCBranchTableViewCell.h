//
//  YCBranchTableViewCell.h
//  ios.iGitHub
//
//  Created by yangc on 16/8/9.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCBranchResult;

@interface YCBranchTableViewCell : UITableViewCell

@property (nonatomic, strong) YCBranchResult *branch;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
