//
//  YCCommentTableFooterView.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/30.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCCommentTableFooterView;

@protocol YCCommentTableFooterViewDelegate <NSObject>

@optional
- (void)tableFooterViewDidChangeHeight:(YCCommentTableFooterView *)tableFooterView;
- (void)tableFooterView:(YCCommentTableFooterView *)tableFooterView didActiveLinkWithURL:(NSURL *)URL;

@end

@interface YCCommentTableFooterView : UIView

@property (nonatomic, weak) id<YCCommentTableFooterViewDelegate> delegate;

@property (nonatomic, strong) NSArray *commentFArray;

@end
