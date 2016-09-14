//
//  YCIssuesDetailTableViewCell.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/27.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import "YCIssuesDetailTableViewCell.h"
#import "YCIssuesResult.h"

@interface YCIssuesDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *participantsLabel;

@end

@implementation YCIssuesDetailTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"YCIssuesDetailTableViewCell";
    YCIssuesDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"YCIssuesDetailTableViewCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)setIssues:(YCIssuesResult *)issues {
    _issues = issues;

    self.commentsLabel.text = [NSString stringWithFormat:@"%ld", self.issues.number];
    self.participantsLabel.text = [NSString stringWithFormat:@"%ld", self.issues.assignees.count];
}

@end
