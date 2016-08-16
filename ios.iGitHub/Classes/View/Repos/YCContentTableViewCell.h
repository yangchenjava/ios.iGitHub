//
//  YCContentTableViewCell.h
//  ios.iGitHub
//
//  Created by yangc on 16/8/9.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YCContentResult.h"

@interface YCContentTableViewCell : UITableViewCell

@property (nonatomic, strong) YCContentResult *content;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
