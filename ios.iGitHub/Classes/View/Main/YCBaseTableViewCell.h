//
//  YCBaseTableViewCell.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/26.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCBaseTableViewCellItem;

@interface YCBaseTableViewCell : UITableViewCell

@property (nonatomic, strong) YCBaseTableViewCellItem *item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
