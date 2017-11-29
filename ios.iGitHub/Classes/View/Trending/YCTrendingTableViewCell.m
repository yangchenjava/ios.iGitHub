//
//  YCTrendingTableViewCell.m
//  ios.iGitHub
//
//  Created by 杨晨 on 2017/11/24.
//  Copyright © 2017年 yangc. All rights reserved.
//

#import <FontAwesomeKit/FontAwesomeKit.h>
#import <YCHelpKit/NSString+Emojize.h>
#import <YCHelpKit/UIImage+Category.h>
#import <YCHelpKit/UIImageView+SDWebImageCategory.h>
#import <YCHelpKit/UIView+Category.h>

#import "YCTrendingTableViewCell.h"
#import "YCReposResult.h"
#import "YCProfileResult.h"

@interface YCTrendingTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UILabel *starCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *forkImageView;
@property (weak, nonatomic) IBOutlet UILabel *forkCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation YCTrendingTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"YCTrendingTableViewCell";
    YCTrendingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"YCTrendingTableViewCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setSeparatorInset:UIEdgeInsetsMake(0, self.nameLabel.x, 0, 0)];
}

- (void)setRepos:(YCReposResult *)repos {
    _repos = repos;
    
    UIImage *image = [UIImage imageNamed:@"avatar"];
    [self.avatarImageView sd_setImageCircleWithURL:[NSURL URLWithString:self.repos.owner.avatar_url] placeholderImage:[image imageWithCircle:image.size]];
    self.nameLabel.text = self.repos.name;
    
    if (self.repos.desc.length) {
        self.descLabel.text = [self.repos.desc emojizedString];
    } else {
        self.descLabel.text = @"";
    }
    
    FAKOcticons *starIcon = [FAKOcticons starIconWithSize:MIN(self.starImageView.width, self.starImageView.height)];
    [starIcon addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]];
    self.starImageView.image = [starIcon imageWithSize:self.starImageView.size];
    
    self.starCountLabel.text = [NSString stringWithFormat:@"%ld", self.repos.stargazers_count];
    
    FAKOcticons *forkIcon = [FAKOcticons repoForkedIconWithSize:MIN(self.forkImageView.width, self.forkImageView.height)];
    [forkIcon addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]];
    self.forkImageView.image = [forkIcon imageWithSize:self.forkImageView.size];
    
    self.forkCountLabel.text = [NSString stringWithFormat:@"%ld", self.repos.forks_count];
    
    FAKOcticons *personIcon = [FAKOcticons personIconWithSize:MIN(self.userImageView.width, self.userImageView.height)];
    [personIcon addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]];
    self.userImageView.image = [personIcon imageWithSize:self.userImageView.size];
    
    self.userNameLabel.text = self.repos.owner.login;
}

@end
