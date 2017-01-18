//
//  YCCommitBodyTableViewCell.h
//  ios.iGitHub
//
//  Created by yangc on 16/8/5.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCCommitTableViewCellItem;

@interface YCCommitBodyTableViewCell : UITableViewCell

@property (nonatomic, strong) YCCommitTableViewCellItem *item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
