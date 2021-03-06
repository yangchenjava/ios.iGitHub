//
//  YCBaseTableHeaderView.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/12.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <YCHelpKit/NSString+Emojize.h>
#import <YCHelpKit/UIImage+Category.h>
#import <YCHelpKit/UIImageView+SDWebImageCategory.h>
#import <YCHelpKit/UIView+Category.h>

#import "YCBaseTableHeaderModel.h"
#import "YCBaseTableHeaderModelF.h"
#import "YCBaseTableHeaderView.h"

@interface YCBaseTableHeaderView ()

@property (nonatomic, weak) UIImageView *avatarImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *descLabel;

@end

@implementation YCBaseTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *avatarImageView = [[UIImageView alloc] init];
        [self addSubview:avatarImageView];
        self.avatarImageView = avatarImageView;

        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = kFontName;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.numberOfLines = 0;
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;

        UILabel *descLabel = [[UILabel alloc] init];
        descLabel.textColor = YC_Color_RGB(205, 205, 205);
        descLabel.font = kFontDesc;
        descLabel.textAlignment = NSTextAlignmentCenter;
        descLabel.numberOfLines = 0;
        [self addSubview:descLabel];
        self.descLabel = descLabel;
    }
    return self;
}

- (void)setTableHeaderModelF:(YCBaseTableHeaderModelF *)tableHeaderModelF {
    _tableHeaderModelF = tableHeaderModelF;

    YCBaseTableHeaderModel *tableHeaderModel = self.tableHeaderModelF.tableHeaderModel;

    self.avatarImageView.frame = self.tableHeaderModelF.avatarF;
    UIImage *image = [UIImage imageNamed:@"avatar"];
    image = [image imageWithCircle:image.size borderWidth:image.size.width * 0.05];
    if (tableHeaderModel.avatar.length) {
        YCWeakSelf(self);
        [self.avatarImageView sd_setImageCircleWithURL:[NSURL URLWithString:tableHeaderModel.avatar]
                                      placeholderImage:image
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                 weakself.avatarImageView.image = [image imageWithCircle:image.size borderWidth:image.size.width * 0.05];
                                             }];
    } else {
        self.avatarImageView.image = image;
    }

    self.nameLabel.frame = self.tableHeaderModelF.nameF;
    self.nameLabel.text = tableHeaderModel.name;

    self.descLabel.frame = self.tableHeaderModelF.descF;
    if (tableHeaderModel.desc.length) {
        self.descLabel.hidden = NO;
        self.descLabel.text = [tableHeaderModel.desc emojizedString];
    } else {
        self.descLabel.hidden = YES;
        self.descLabel.text = nil;
    }

    self.frame = CGRectMake(0, 0, self.tableHeaderModelF.tableHeaderViewWidth, self.tableHeaderModelF.tableHeaderViewHeight);
}

@end
