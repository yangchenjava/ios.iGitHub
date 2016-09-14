//
//  YCProfileTableViewCell.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/22.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCProfileResult;

@interface YCProfileTableViewCell : UITableViewCell

@property (nonatomic, strong) YCProfileResult *profile;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
