//
//  YCReadmeViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/2.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <WebKit/WebKit.h>
#import <YCHelpKit/UIView+Category.h>
#import <YCHelpKit/UIViewController+Category.h>

#import "YCReadmeResult.h"
#import "YCReadmeViewController.h"
#import "YCReposBiz.h"

@interface YCReadmeViewController () <WKNavigationDelegate>

@property (nonatomic, weak) WKWebView *webView;

@end

@implementation YCReadmeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupWebView];
}

- (void)setupWebView {
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    webView.height -= (YC_StatusBarHeight + YC_NavigationBarHeight + YC_TabBarBottomSafeMargin);
    webView.navigationDelegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webView];
    self.webView = webView;

    NSURL *url = [[NSBundle mainBundle] URLForResource:@"readme.html" withExtension:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSString *content = self.readme.content;
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@"\\\n"];
    [webView evaluateJavaScript:[NSString stringWithFormat:@"document.getElementById(\"markdown-body\").innerHTML = marked(decodeURIComponent(escape(atob(\"%@\"))));", content] completionHandler:nil];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (navigationAction.navigationType != WKNavigationTypeLinkActivated) {
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        decisionHandler(WKNavigationActionPolicyCancel);
        [self presentWebViewControllerWithURL:navigationAction.request.URL animated:YES completion:nil];
    }
}

@end
