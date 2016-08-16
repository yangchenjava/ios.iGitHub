//
//  YCPullBodyTableViewCell.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/4.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MMMarkdown/MMMarkdown.h>

#import "UIView+Category.h"
#import "YCPullBodyTableViewCell.h"

#define kMarginVertical 10
#define kMarginHorizontal 16

@interface YCPullBodyTableViewCell () <UIWebViewDelegate>

@property (nonatomic, weak) UIWebView *webView;

@end

@implementation YCPullBodyTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"YCPullBodyTableViewCell";
    YCPullBodyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[YCPullBodyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        CGFloat x = kMarginHorizontal;
        CGFloat y = kMarginVertical;
        CGFloat width = YC_ScreenWidth - 2 * kMarginHorizontal;
        CGFloat height = kMarginVertical;
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        webView.delegate = self;
        webView.backgroundColor = [UIColor whiteColor];
        webView.scrollView.bounces = NO;
        [self addSubview:webView];
        self.webView = webView;
    }
    return self;
}

- (void)setPull:(YCPullResult *)pull {
    _pull = pull;

    if (self.pull.body.length) {
        self.webView.hidden = YES;

        NSString *HTMLString = [MMMarkdown HTMLStringWithMarkdown:self.pull.body extensions:MMMarkdownExtensionsGitHubFlavored error:NULL];
        [self.webView loadHTMLString:YC_HTMLString(HTMLString) baseURL:[NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath]];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // webView.height = [webView sizeThatFits:CGSizeZero].height;
    webView.height = webView.scrollView.contentSize.height;
    self.height = CGRectGetMaxY(webView.frame) + kMarginVertical;

    webView.hidden = NO;

    if ([self.delegate respondsToSelector:@selector(tableViewCellDidChangeHeight:)]) {
        [self.delegate tableViewCellDidChangeHeight:self];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked && [self.delegate respondsToSelector:@selector(tableViewCell:didActiveLinkWithURL:)]) {
        [self.delegate tableViewCell:self didActiveLinkWithURL:request.URL];
    }
    return navigationType != UIWebViewNavigationTypeLinkClicked;
}

@end
