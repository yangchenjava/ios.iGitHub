//
//  YCBaseTableViewCell.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/26.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import "FontAwesomeKit.h"
#import "YCBaseTableViewCell.h"

#define kIconSize 20

@implementation YCBaseTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"YCBaseTableViewCell";
    YCBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[YCBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.numberOfLines = 0;
    }
    return self;
}

- (void)setItem:(YCBaseTableViewCellItem *)item {
    _item = item;

    if (self.item.icon.length) {
        FAKOcticons *icon = [FAKOcticons iconWithIdentifier:self.item.icon size:kIconSize error:NULL];
        [icon addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]];
        self.imageView.image = [icon imageWithSize:CGSizeMake(kIconSize, kIconSize)];
    } else {
        self.imageView.image = nil;
    }
    if (self.item.title.length) {
        self.textLabel.text = self.item.title;
    } else {
        self.textLabel.text = nil;
    }
    if (self.item.subtitle.length) {
        self.detailTextLabel.text = self.item.subtitle;
    } else {
        self.detailTextLabel.text = nil;
    }

    if (self.item.operation || self.item.destClass) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

@end
