//
//  YCSourceViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/10.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <YCHelpKit/UIView+Category.h>
#import <YCHelpKit/UIViewController+Category.h>

#import "YCReposBiz.h"
#import "YCSourceViewController.h"

@interface YCSourceViewController () <UIWebViewDelegate>

@property (nonatomic, weak) UIWebView *webView;

@property (nonatomic, strong) YCContentResult *content;

@end

@implementation YCSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupWebView];
}

- (void)setupWebView {
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navigationBarHeight = self.navigationController.navigationBar.height;

    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.height -= (statusBarHeight + navigationBarHeight);
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webView];
    self.webView = webView;

    [YCReposBiz reposContentWithUsername:self.username
        reposname:self.reposname
        path:self.path
        ref:self.ref
        page:1
        success:^(id result) {
            self.content = result;

            NSURL *url = [[NSBundle mainBundle] URLForResource:@"highlight.html" withExtension:nil];
            [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
        }
        failure:^(NSError *error) {
            NSLog(@"%@", error.localizedDescription);
        }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // 根据扩展名定义样式
    NSString *extension = self.content.name.pathExtension;
    if ([extension isEqualToString:@"m"]) {
        extension = @"objectivec";
    }
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"$(\"code\").addClass(\"%@\");", extension]];
    // 解析内容
    NSString *content = self.content.content;
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@"\\\n"];
    content = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"decodeURIComponent(escape(atob(\"%@\")));", content]];
    // 转义字符
    content = [content stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    content = [content stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    // 填充内容
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"$(\"code\").text(\"%@\");", content]];
    // 绘制行号，设置样式
    [webView stringByEvaluatingJavaScriptFromString:@"drawLineNumber();"];
    [webView stringByEvaluatingJavaScriptFromString:@"$(\".lineNumber-background\").height(document.body.scrollHeight);"];
    // 设置高亮样式
    [webView stringByEvaluatingJavaScriptFromString:@"$(\"code\").each(function(i, block){ hljs.highlightBlock(block); });"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [self presentWebViewControllerWithURL:request.URL animated:YES completion:nil];
    }
    return navigationType != UIWebViewNavigationTypeLinkClicked;
}

@end
