//
//  YCReposTableViewCell.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/11.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <FontAwesomeKit/FontAwesomeKit.h>
#import <YCHelpKit/NSString+Emojize.h>
#import <YCHelpKit/UIImage+Category.h>
#import <YCHelpKit/UIImageView+SDWebImageCategory.h>
#import <YCHelpKit/UIView+Category.h>

#import "YCProfileResult.h"
#import "YCReposResult.h"
#import "YCReposTableViewCell.h"

@interface YCReposTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;
@property (weak, nonatomic) IBOutlet UILabel *starCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *forkImageView;
@property (weak, nonatomic) IBOutlet UILabel *forkCountLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameStarLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descStarLayoutConstraint;

@end

@implementation YCReposTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"YCReposTableViewCell";
    YCReposTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"YCReposTableViewCell" owner:nil options:nil].lastObject;
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
        self.descLabel.hidden = NO;
        self.descStarLayoutConstraint.priority = 999;
        self.nameStarLayoutConstraint.priority = UILayoutPriorityDefaultHigh;
    } else {
        self.descLabel.text = nil;
        self.descLabel.hidden = YES;
        self.descStarLayoutConstraint.priority = UILayoutPriorityDefaultHigh;
        self.nameStarLayoutConstraint.priority = 999;
    }

    FAKOcticons *starIcon = [FAKOcticons starIconWithSize:MIN(self.starImageView.width, self.starImageView.height)];
    [starIcon addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]];
    self.starImageView.image = [starIcon imageWithSize:self.starImageView.size];

    self.starCountLabel.text = [NSString stringWithFormat:@"%ld", self.repos.stargazers_count];

    FAKOcticons *forkIcon = [FAKOcticons repoForkedIconWithSize:MIN(self.forkImageView.width, self.forkImageView.height)];
    [forkIcon addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]];
    self.forkImageView.image = [forkIcon imageWithSize:self.forkImageView.size];

    self.forkCountLabel.text = [NSString stringWithFormat:@"%ld", self.repos.forks_count];
}

@end
