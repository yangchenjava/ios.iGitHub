//
//  YCIssuesTableViewCell.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/26.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <YCHelpKit/UIView+Category.h>

#import "FontAwesomeKit.h"
#import "YCGitHubUtils.h"
#import "YCIssuesResult.h"
#import "YCIssuesTableViewCell.h"
#import "YCProfileResult.h"

@interface YCIssuesTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *assigneeImageView;
@property (weak, nonatomic) IBOutlet UILabel *assigneeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dateImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation YCIssuesTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"YCIssuesTableViewCell";
    YCIssuesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"YCIssuesTableViewCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)setIssues:(YCIssuesResult *)issues {
    _issues = issues;

    self.numberLabel.text = [NSString stringWithFormat:@"#%ld", self.issues.number];
    self.titleLabel.text = self.issues.title;

    FAKOcticons *settingsIcon = [FAKOcticons gearIconWithSize:MIN(self.stateImageView.width, self.stateImageView.height)];
    [settingsIcon addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]];
    self.stateImageView.image = [settingsIcon imageWithSize:self.stateImageView.size];
    self.stateLabel.text = self.issues.state;

    FAKOcticons *personIcon = [FAKOcticons personIconWithSize:MIN(self.assigneeImageView.width, self.assigneeImageView.height)];
    [personIcon addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]];
    self.assigneeImageView.image = [personIcon imageWithSize:self.assigneeImageView.size];
    self.assigneeLabel.text = self.issues.assignee ? self.issues.assignee.login : @"unassigned";

    FAKOcticons *commentIcon = [FAKOcticons commentDiscussionIconWithSize:MIN(self.commentImageView.width, self.commentImageView.height)];
    [commentIcon addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]];
    self.commentImageView.image = [commentIcon imageWithSize:self.commentImageView.size];
    self.commentLabel.text = self.issues.comments > 1 ? [NSString stringWithFormat:@"%ld comments", self.issues.comments] : [NSString stringWithFormat:@"%ld comment", self.issues.comments];

    FAKOcticons *pencilIcon = [FAKOcticons pencilIconWithSize:MIN(self.dateImageView.width, self.dateImageView.height)];
    [pencilIcon addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]];
    self.dateImageView.image = [pencilIcon imageWithSize:self.dateImageView.size];
    self.dateLabel.text = [YCGitHubUtils dateStringWithDate:self.issues.created_at];
}

@end
