//
//  YCContentTableViewCell.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/9.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <FontAwesomeKit/FontAwesomeKit.h>
#import <YCHelpKit/UIView+Category.h>

#import "YCContentResult.h"
#import "YCContentTableViewCell.h"

@implementation YCContentTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"YCContentTableViewCell";
    YCContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[YCContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.textColor = YC_Color_RGB(50, 50, 50);
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)setContent:(YCContentResult *)content {
    _content = content;

    FAKOcticons *icon;
    if (self.content.type == ContentTypeDir) {
        icon = [FAKOcticons fileDirectoryIconWithSize:25];
    } else {
        icon = [FAKOcticons fileCodeIconWithSize:25];
    }
    [icon addAttribute:NSForegroundColorAttributeName value:YC_Color_RGB(91, 97, 101)];
    self.imageView.image = [icon imageWithSize:CGSizeMake(25, 25)];
    self.textLabel.text = self.content.name;
}

@end
