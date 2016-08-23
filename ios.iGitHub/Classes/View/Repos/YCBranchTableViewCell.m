//
//  YCBranchTableViewCell.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/9.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import "YCBranchTableViewCell.h"

@implementation YCBranchTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"YCBranchTableViewCell";
    YCBranchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[YCBranchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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

- (void)setBranch:(YCBranchResult *)branch {
    _branch = branch;

    self.textLabel.text = self.branch.name;
}

@end
