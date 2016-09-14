//
//  YCCommitBodyTableViewCell.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/5.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import "YCCommitBodyTableViewCell.h"
#import "YCCommitTableViewCellItem.h"

@interface YCCommitBodyTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statueLabel;
@property (weak, nonatomic) IBOutlet UILabel *additionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *deletionsLabel;

@end

@implementation YCCommitBodyTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"YCCommitBodyTableViewCell";
    YCCommitBodyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"YCCommitBodyTableViewCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.additionsLabel.layer.cornerRadius = 5;
    self.additionsLabel.clipsToBounds = YES;
    self.deletionsLabel.layer.cornerRadius = 5;
    self.deletionsLabel.clipsToBounds = YES;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.additionsLabel.backgroundColor = YC_Color_RGB(201, 255, 208);
    self.deletionsLabel.backgroundColor = YC_Color_RGB(255, 221, 221);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.additionsLabel.backgroundColor = YC_Color_RGB(201, 255, 208);
    self.deletionsLabel.backgroundColor = YC_Color_RGB(255, 221, 221);
}

- (void)setItem:(YCCommitTableViewCellItem *)item {
    _item = item;

    self.fileNameLabel.text = self.item.title;
    self.statueLabel.text = self.item.subtitle;
    self.additionsLabel.text = [NSString stringWithFormat:@"+%ld", self.item.additions];
    self.deletionsLabel.text = [NSString stringWithFormat:@"-%ld", self.item.deletions];
}

@end
