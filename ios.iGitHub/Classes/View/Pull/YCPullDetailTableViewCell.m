//
//  YCPullDetailTableViewCell.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/4.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <YCHelpKit/UIView+Category.h>

#import "FontAwesomeKit.h"
#import "YCPullDetailTableViewCell.h"

@interface YCPullDetailTableViewCell () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *additionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *deletionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *changesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *usernameImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mergedImageView;
@property (weak, nonatomic) IBOutlet UILabel *mergedLabel;

@end

@implementation YCPullDetailTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"YCPullDetailTableViewCell";
    YCPullDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"YCPullDetailTableViewCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)setPull:(YCPullResult *)pull {
    _pull = pull;

    self.additionsLabel.text = [NSString stringWithFormat:@"%ld", self.pull.additions];
    self.deletionsLabel.text = [NSString stringWithFormat:@"%ld", self.pull.deletions];
    self.changesLabel.text = [NSString stringWithFormat:@"%ld", self.pull.changed_files];

    FAKOcticons *personIcon = [FAKOcticons personIconWithSize:MIN(self.usernameImageView.width, self.usernameImageView.height)];
    [personIcon addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]];
    self.usernameImageView.image = [personIcon imageWithSize:self.usernameImageView.size];
    self.usernameLabel.text = self.pull.user.login;

    FAKOcticons *gitMergeIcon = [FAKOcticons gitMergeIconWithSize:MIN(self.mergedImageView.width, self.mergedImageView.height)];
    [gitMergeIcon addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]];
    self.mergedImageView.image = [gitMergeIcon imageWithSize:self.mergedImageView.size];
    self.mergedLabel.text = self.pull.merged ? @"Merged" : @"Not Merged";
}

@end
