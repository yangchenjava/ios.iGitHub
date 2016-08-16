//
//  YCCommitPatchViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/5.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import "UIView+Category.h"
#import "YCCommitPatchViewController.h"

@interface YCCommitPatchViewController () <UIWebViewDelegate>

@property (nonatomic, weak) UIWebView *webView;

@end

@implementation YCCommitPatchViewController

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

    NSURL *url = [[NSBundle mainBundle] URLForResource:@"diffindex.html" withExtension:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *URLString = request.URL.absoluteString;
    NSLog(@"%@", URLString);
    if ([URLString isEqualToString:@"app://ready"]) {
        self.patch = [self.patch stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        self.patch = [self.patch stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
        self.patch = [self.patch stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"patch(\"%@\");", self.patch]];
    }
    return YES;
}

@end
