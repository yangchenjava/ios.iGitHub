//
//  YCReadmeViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/2.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <WebKit/WebKit.h>

#import "UIView+Category.h"
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
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navigationBarHeight = self.navigationController.navigationBar.height;

    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    webView.height -= (statusBarHeight + navigationBarHeight);
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
    }
}

@end
