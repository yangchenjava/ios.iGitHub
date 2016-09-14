//
//  YCCommitDetailTableViewCell.h
//  ios.iGitHub
//
//  Created by yangc on 16/8/5.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCCommitResult;

@interface YCCommitDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) YCCommitResult *commit;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
