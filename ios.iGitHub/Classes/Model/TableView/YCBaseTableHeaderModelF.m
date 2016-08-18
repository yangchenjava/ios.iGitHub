//
//  YCBaseTableHeaderModelF.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/28.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <YCHelpKit/NSString+Category.h>

#import "YCBaseTableHeaderModelF.h"

#define kMargin 10

@implementation YCBaseTableHeaderModelF

- (void)setTableHeaderModel:(YCBaseTableHeaderModel *)tableHeaderModel {
    _tableHeaderModel = tableHeaderModel;

    CGFloat tableHeaderViewWidth = YC_ScreenWidth;

    CGFloat avatarWH = 80;
    _avatarF = CGRectMake((tableHeaderViewWidth - avatarWH) * 0.5, kMargin, avatarWH, avatarWH);

    CGFloat nameX = kMargin;
    CGFloat nameY = CGRectGetMaxY(_avatarF) + kMargin;
    CGFloat nameW = tableHeaderViewWidth - kMargin * 2;
    CGFloat nameH = [self.tableHeaderModel.name sizeWithFont:kFontName size:CGSizeMake(nameW, MAXFLOAT)].height;
    _nameF = CGRectMake(nameX, nameY, nameW, nameH);

    CGFloat descX = nameX;
    CGFloat descY = CGRectGetMaxY(_nameF) + kMargin;
    CGFloat descW = nameW;
    CGFloat descH = [self.tableHeaderModel.desc sizeWithFont:kFontDesc size:CGSizeMake(descW, MAXFLOAT)].height;
    _descF = CGRectMake(descX, descY, descW, descH);

    _tableHeaderViewWidth = tableHeaderViewWidth;
    _tableHeaderViewHeight = (self.tableHeaderModel.desc ? CGRectGetMaxY(_descF) : CGRectGetMaxY(_nameF)) + kMargin;
}

@end
