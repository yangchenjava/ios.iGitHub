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
#import "YCProfileBiz.h"
#import "YCTrendingResult.h"
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

- (void)setTrending:(YCTrendingResult *)trending {
    _trending = trending;
    
    NSArray *array = [self.trending.repo componentsSeparatedByString:@"/"];
    NSString *userName = array[0], *name = array[1];
    
    UIImage *image = [UIImage imageNamed:@"avatar"];
    self.avatarImageView.image = [image imageWithCircle:image.size];
    if (self.avatarDictionary[userName].length) {
        [self.avatarImageView sd_setImageCircleWithURL:[NSURL URLWithString:self.avatarDictionary[userName]] placeholderImage:self.avatarImageView.image];
    } else {
        [YCProfileBiz profileWithUserName:userName success:^(YCProfileResult *result) {
            [self.avatarImageView sd_setImageCircleWithURL:[NSURL URLWithString:result.avatar_url] placeholderImage:self.avatarImageView.image];
            [self.avatarDictionary setValue:result.avatar_url forKey:userName];
        } failure:^(NSError *error) {
            YCLog(@"%@", error.localizedDescription);
        }];
    }
    
    self.nameLabel.text = name;
    
    if (self.trending.desc.length) {
        self.descLabel.text = [self.trending.desc emojizedString];
    } else {
        self.descLabel.text = @"";
    }
    
    FAKOcticons *starIcon = [FAKOcticons starIconWithSize:MIN(self.starImageView.width, self.starImageView.height)];
    [starIcon addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]];
    self.starImageView.image = [starIcon imageWithSize:self.starImageView.size];
    
    self.starCountLabel.text = self.trending.stars;
    
    FAKOcticons *forkIcon = [FAKOcticons repoForkedIconWithSize:MIN(self.forkImageView.width, self.forkImageView.height)];
    [forkIcon addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]];
    self.forkImageView.image = [forkIcon imageWithSize:self.forkImageView.size];
    
    self.forkCountLabel.text = self.trending.forks;
    
    FAKOcticons *personIcon = [FAKOcticons personIconWithSize:MIN(self.userImageView.width, self.userImageView.height)];
    [personIcon addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]];
    self.userImageView.image = [personIcon imageWithSize:self.userImageView.size];
    
    self.userNameLabel.text = userName;
}

@end
