//
//  YCTrendingTableViewHeaderFooterView.m
//  ios.iGitHub
//
//  Created by 杨晨 on 2017/11/24.
//  Copyright © 2017年 yangc. All rights reserved.
//

#import "YCTrendingTableViewHeaderFooterView.h"

@interface YCTrendingTableViewHeaderFooterView ()

@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation YCTrendingTableViewHeaderFooterView

+ (instancetype)viewWithTableView:(UITableView *)tableView {
    static NSString *ID = @"YCTrendingTableViewHeaderFooterView";
    YCTrendingTableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (view == nil) {
        view = [[YCTrendingTableViewHeaderFooterView alloc] initWithReuseIdentifier:ID];
    }
    return view;
}

+ (CGFloat)height {
    return 25;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YC_ScreenWidth, [YCTrendingTableViewHeaderFooterView height])];
        titleLabel.font = [UIFont boldSystemFontOfSize:13];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = YC_Color_RGB(50, 50, 50);
        titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = self.title;
}

@end
