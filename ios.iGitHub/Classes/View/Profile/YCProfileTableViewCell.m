//
//  YCProfileTableViewCell.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/22.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import "YCProfileResult.h"
#import "YCProfileTableViewCell.h"

@interface YCProfileTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;

@end

@implementation YCProfileTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"YCProfileTableViewCell";
    YCProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"YCProfileTableViewCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)setProfile:(YCProfileResult *)profile {
    _profile = profile;

    self.followersLabel.text = [NSString stringWithFormat:@"%ld", self.profile.followers];
    self.followingLabel.text = [NSString stringWithFormat:@"%ld", self.profile.following];
}

@end
