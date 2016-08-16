//
//  YCIssuesBodyTableViewCell.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/29.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YCIssuesResult.h"

@class YCIssuesBodyTableViewCell;

@protocol YCIssuesBodyTableViewCellDelegate <NSObject>

@optional
- (void)tableViewCellDidChangeHeight:(YCIssuesBodyTableViewCell *)tableViewCell;

@end

@interface YCIssuesBodyTableViewCell : UITableViewCell

@property (nonatomic, weak) id<YCIssuesBodyTableViewCellDelegate> delegate;

@property (nonatomic, strong) YCIssuesResult *issues;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
