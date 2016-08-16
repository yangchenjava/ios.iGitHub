//
//  YCNewsTableViewCell.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/18.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YCNewsResult.h"

@class YCNewsTableViewCell;

@protocol YCNewsTableViewCellDelegate <NSObject>

@optional
- (void)tableViewCell:(YCNewsTableViewCell *)tableViewCell didClickUsername:(NSString *)username;
- (void)tableViewCell:(YCNewsTableViewCell *)tableViewCell didClickUsername:(NSString *)username reposname:(NSString *)reposname;
- (void)tableViewCell:(YCNewsTableViewCell *)tableViewCell didClickUsername:(NSString *)username forkeeReposname:(NSString *)forkeeReposname;
- (void)tableViewCell:(YCNewsTableViewCell *)tableViewCell didClickUsername:(NSString *)username reposname:(NSString *)reposname number:(long)number;

@end

@interface YCNewsTableViewCell : UITableViewCell

@property (nonatomic, weak) id<YCNewsTableViewCellDelegate> delegate;

@property (nonatomic, strong) YCNewsResult *news;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
