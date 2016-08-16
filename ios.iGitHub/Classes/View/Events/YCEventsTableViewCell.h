//
//  YCEventsTableViewCell.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/19.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YCEventsResultF.h"

@class YCEventsTableViewCell;

@protocol YCEventsTableViewCellDelegate <NSObject>

@optional
- (void)tableViewCell:(YCEventsTableViewCell *)tableViewCell didClickUsername:(NSString *)username;
- (void)tableViewCell:(YCEventsTableViewCell *)tableViewCell didClickUsername:(NSString *)username reposname:(NSString *)reposname;
- (void)tableViewCell:(YCEventsTableViewCell *)tableViewCell didClickUsername:(NSString *)username forkeeReposname:(NSString *)forkeeReposname;
- (void)tableViewCell:(YCEventsTableViewCell *)tableViewCell didClickUsername:(NSString *)username reposname:(NSString *)reposname issueNumber:(long)issueNumber;
- (void)tableViewCell:(YCEventsTableViewCell *)tableViewCell didClickUsername:(NSString *)username reposname:(NSString *)reposname pullRequestNumber:(long)pullRequestNumber;
- (void)tableViewCell:(YCEventsTableViewCell *)tableViewCell didClickUsername:(NSString *)username reposname:(NSString *)reposname branch:(NSString *)branch;
- (void)tableViewCell:(YCEventsTableViewCell *)tableViewCell didClickUsername:(NSString *)username reposname:(NSString *)reposname sha:(NSString *)sha;

@end

@interface YCEventsTableViewCell : UITableViewCell

@property (nonatomic, weak) id<YCEventsTableViewCellDelegate> delegate;

@property (nonatomic, strong) YCEventsResultF *eventsF;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
