//
//  YCTrendingTableViewCell.h
//  ios.iGitHub
//
//  Created by 杨晨 on 2017/11/24.
//  Copyright © 2017年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCTrendingResult;

@interface YCTrendingTableViewCell : UITableViewCell

@property (nonatomic, strong) NSMutableDictionary <NSString *, NSString *> *avatarDictionary;
@property (nonatomic, strong) YCTrendingResult *trending;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
