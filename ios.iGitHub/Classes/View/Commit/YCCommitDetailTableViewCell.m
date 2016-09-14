//
//  YCCommitDetailTableViewCell.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/5.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import "YCCommitDetailResult.h"
#import "YCCommitDetailTableViewCell.h"
#import "YCCommitResult.h"
#import "YCProfileResult.h"

@interface YCCommitDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *additionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *deletionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *parentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation YCCommitDetailTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"YCCommitDetailTableViewCell";
    YCCommitDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"YCCommitDetailTableViewCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)setCommit:(YCCommitResult *)commit {
    _commit = commit;

    self.additionsLabel.text = [NSString stringWithFormat:@"%ld", self.commit.additions];
    self.deletionsLabel.text = [NSString stringWithFormat:@"%ld", self.commit.deletions];
    self.parentsLabel.text = [NSString stringWithFormat:@"%ld", self.commit.parents.count];
    self.usernameLabel.text = self.commit.committer.login;
    self.messageLabel.text = self.commit.commit.message;
}

@end
