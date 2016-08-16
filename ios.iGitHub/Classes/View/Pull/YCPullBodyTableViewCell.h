//
//  YCPullBodyTableViewCell.h
//  ios.iGitHub
//
//  Created by yangc on 16/8/4.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YCPullResult.h"

@class YCPullBodyTableViewCell;

@protocol YCPullBodyTableViewCellDelegate <NSObject>

@optional
- (void)tableViewCellDidChangeHeight:(YCPullBodyTableViewCell *)tableViewCell;
- (void)tableViewCell:(YCPullBodyTableViewCell *)tableViewCell didActiveLinkWithURL:(NSURL *)URL;

@end

@interface YCPullBodyTableViewCell : UITableViewCell

@property (nonatomic, weak) id<YCPullBodyTableViewCellDelegate> delegate;

@property (nonatomic, strong) YCPullResult *pull;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
