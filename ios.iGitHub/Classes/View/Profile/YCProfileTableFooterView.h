//
//  YCProfileTableFooterView.h
//  ios.iGitHub
//
//  Created by yangc on 17/1/24.
//  Copyright © 2017年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCProfileTableFooterView;

@protocol YCProfileTableFooterViewDelegate <NSObject>

@optional
- (void)tableFooterViewDidClick:(YCProfileTableFooterView *)tableFooterView;

@end

@interface YCProfileTableFooterView : UIView

@property (nonatomic, weak) id<YCProfileTableFooterViewDelegate> delegate;

@end
