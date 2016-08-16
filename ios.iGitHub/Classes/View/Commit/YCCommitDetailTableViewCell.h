//
//  YCCommitDetailTableViewCell.h
//  ios.iGitHub
//
//  Created by yangc on 16/8/5.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YCCommitResult.h"

@interface YCCommitDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) YCCommitResult *commit;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
