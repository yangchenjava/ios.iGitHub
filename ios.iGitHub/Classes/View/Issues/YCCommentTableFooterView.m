//
//  YCCommentTableFooterView.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/30.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MMMarkdown/MMMarkdown.h>
#import <YCHelpKit/UIImage+Category.h>
#import <YCHelpKit/UIImageView+SDWebImageCategory.h>
#import <YCHelpKit/UIView+Category.h>

#import "YCCommentResult.h"
#import "YCCommentResultF.h"
#import "YCCommentTableFooterView.h"
#import "YCGitHubUtils.h"
#import "YCProfileResult.h"

@interface YCCommentTableFooterView () <UIWebViewDelegate>

@end

@implementation YCCommentTableFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setCommentFArray:(NSArray *)commentFArray {
    _commentFArray = commentFArray;

    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < self.commentFArray.count; i++) {
        YCCommentResultF *commentF = self.commentFArray[i];

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YC_ScreenWidth, kMargin)];

        UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:commentF.avatarF];
        UIImage *image = [UIImage imageNamed:@"avatar"];
        [avatarImageView sd_setImageCircleWithURL:[NSURL URLWithString:commentF.comment.user.avatar_url] placeholderImage:[image imageWithCircle:image.size]];
        [view addSubview:avatarImageView];

        UILabel *nameLabel = [[UILabel alloc] initWithFrame:commentF.nameF];
        nameLabel.textColor = YC_Color_RGB(65, 132, 192);
        nameLabel.font = kFontName;
        nameLabel.text = commentF.comment.user.login;
        [view addSubview:nameLabel];

        UILabel *dateLabel = [[UILabel alloc] initWithFrame:commentF.dateF];
        dateLabel.textColor = [UIColor blackColor];
        dateLabel.font = kFontDate;
        dateLabel.text = [YCGitHubUtils dateStringWithDate:commentF.comment.created_at];
        [view addSubview:dateLabel];

        UIWebView *contentWebView = [[UIWebView alloc] initWithFrame:commentF.contentF];
        contentWebView.delegate = self;
        contentWebView.backgroundColor = [UIColor whiteColor];
        contentWebView.scrollView.bounces = NO;
        contentWebView.tag = i;
        contentWebView.hidden = YES;
        [view addSubview:contentWebView];

        UIView *separatorView = [[UIView alloc] initWithFrame:commentF.separatorF];
        separatorView.backgroundColor = YC_Color_RGB(224, 223, 226);
        [view addSubview:separatorView];

        [self addSubview:view];

        NSString *HTMLString = [MMMarkdown HTMLStringWithMarkdown:commentF.comment.body extensions:MMMarkdownExtensionsGitHubFlavored error:NULL];
        [contentWebView loadHTMLString:YC_HTMLString(HTMLString) baseURL:[NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath]];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // 设置每个子view内部webview的高度和分割线的位置
    webView.height = webView.scrollView.contentSize.height;
    UIView *view = self.subviews[webView.tag];
    UIView *separatorView = view.subviews.lastObject;
    separatorView.y = CGRectGetMaxY(webView.frame) + kMargin;
    view.height = CGRectGetMaxY(separatorView.frame);

    webView.hidden = NO;

    // 重新计算每个子view
    NSUInteger count = self.subviews.count;
    for (int i = 0; i < count; i++) {
        UIView *view = self.subviews[i];
        if (i == 0) {
            view.y = 0;
        } else {
            UIView *prevView = self.subviews[i - 1];
            view.y = prevView.y + prevView.height;
        }
    }
    // 重新设置当前view的frame
    self.frame = CGRectMake(0, 0, YC_ScreenWidth, CGRectGetMaxY(self.subviews.lastObject.frame));

    if ([self.delegate respondsToSelector:@selector(tableFooterViewDidChangeHeight:)]) {
        [self.delegate tableFooterViewDidChangeHeight:self];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked && [self.delegate respondsToSelector:@selector(tableFooterView:didActiveLinkWithURL:)]) {
        [self.delegate tableFooterView:self didActiveLinkWithURL:request.URL];
    }
    return navigationType != UIWebViewNavigationTypeLinkClicked;
}

@end
