//
//  YCNewsTableViewCell.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/18.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import <UIKit/UIKit.h>

@class YCNewsResult;

@interface YCNewsTableViewCell : UITableViewCell

@property (nonatomic, strong) YCNewsResult *news;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url;

@end
