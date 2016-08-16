//
//  YCCommitTableViewCell.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/3.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import "UIImage+Category.h"
#import "UIImageView+SDWebImageCategory.h"
#import "UIView+Category.h"
#import "YCCommitTableViewCell.h"
#import "YCGitHubUtils.h"

@interface YCCommitTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation YCCommitTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"YCCommitTableViewCell";
    YCCommitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"YCCommitTableViewCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setSeparatorInset:UIEdgeInsetsMake(0, self.nameLabel.x, 0, 0)];
}

- (void)setCommit:(YCCommitResult *)commit {
    _commit = commit;

    UIImage *image = [UIImage imageNamed:@"avatar"];
    [self.avatarImageView sd_setImageCircleWithURL:[NSURL URLWithString:self.commit.committer.avatar_url] placeholderImage:[image imageWithCircle:image.size]];
    self.nameLabel.text = self.commit.committer.login;
    self.dateLabel.text = [YCGitHubUtils dateStringWithDate:self.commit.commit.committer.date];
    self.contentLabel.text = self.commit.commit.message;
}

@end
