//
//  YCEventsTableViewCell.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/19.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import <UIKit/UIKit.h>

#import "YCEventsResultF.h"

@interface YCEventsTableViewCell : UITableViewCell

@property (nonatomic, strong) YCEventsResultF *eventsF;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url;

@end
