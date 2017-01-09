//
//  YCCommentResultF.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/30.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <YCHelpKit/NSString+Category.h>

#import "YCCommentResult.h"
#import "YCCommentResultF.h"
#import "YCGitHubUtils.h"
#import "YCProfileResult.h"

@implementation YCCommentResultF

- (void)setComment:(YCCommentResult *)comment {
    _comment = comment;

    CGFloat viewWidth = YC_ScreenWidth;

    CGFloat avatarXY = kMargin;
    CGFloat avatarWH = 35;
    _avatarF = CGRectMake(avatarXY, avatarXY, avatarWH, avatarWH);

    CGFloat nameX = CGRectGetMaxX(_avatarF) + kMargin;
    CGFloat nameY = kMargin;
    CGFloat nameW = viewWidth - nameX - kMargin;

    CGFloat nameH = [self.comment.user.login sizeWithFont:kFontName size:CGSizeMake(nameW, MAXFLOAT)].height;
    _nameF = CGRectMake(nameX, nameY, nameW, nameH);

    CGFloat dateX = nameX;
    CGFloat dateY = CGRectGetMaxY(_nameF) + kMargin;
    CGFloat dateW = nameW;
    CGFloat dateH = [[YCGitHubUtils dateStringWithDate:self.comment.created_at] sizeWithFont:kFontDate size:CGSizeMake(dateW, MAXFLOAT)].height;
    _dateF = CGRectMake(dateX, dateY, dateW, dateH);

    CGFloat contentX = dateX;
    CGFloat contentY = CGRectGetMaxY(_dateF) + kMargin;
    CGFloat contentW = dateW;
    CGFloat contentH = kMargin;
    _contentF = CGRectMake(contentX, contentY, contentW, contentH);

    CGFloat separatorX = 0;
    CGFloat separatorY = CGRectGetMaxY(_contentF) + kMargin;
    CGFloat separatorW = viewWidth;
    CGFloat separatorH = 1;
    _separatorF = CGRectMake(separatorX, separatorY, separatorW, separatorH);
}

@end
