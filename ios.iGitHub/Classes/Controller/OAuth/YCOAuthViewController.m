//
//  YCOAuthViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/5.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <YCHelpKit/MBProgressHUD+Category.h>
#import <YCHelpKit/UIView+Category.h>

#import "YCGitHubUtils.h"
#import "YCOAuthBiz.h"
#import "YCOAuthParam.h"
#import "YCOAuthResult.h"
#import "YCOAuthViewController.h"

@interface YCOAuthViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;

@end

@implementation YCOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Login";

    self.webView.delegate = self;
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    NSURL *url = [NSURL URLWithString:@"https://github.com/login/oauth/authorize?client_id=1b11aefcd2c9620683da"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];

    self.backButton.enabled = NO;
    self.forwardButton.enabled = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    webView.backgroundColor = YC_Color_RGB(250, 250, 250);
    self.backButton.enabled = webView.canGoBack;
    self.forwardButton.enabled = webView.canGoForward;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.URL.absoluteString;
    NSLog(@"%@", url);
    NSRange range = [url rangeOfString:@"code="];
    if (range.location != NSNotFound) {
        [MBProgressHUD showMessage:@"后台小弟拼命加载中..."];

        YCOAuthParam *param = [[YCOAuthParam alloc] init];
        param.client_id = @"1b11aefcd2c9620683da";
        param.client_secret = @"0f59520f1bb2474128640a9c075cb4a16e79501f";
        param.code = [url substringFromIndex:range.location + range.length];
        [YCOAuthBiz oauthWithParam:param
            success:^(YCOAuthResult *result) {
                [YCGitHubUtils setOAuth:result];
                [YCGitHubUtils setupRootViewController];
                [MBProgressHUD hideHUD];
            }
            failure:^(NSError *error) {
                NSLog(@"%@", [error localizedDescription]);
                [MBProgressHUD hideHUD];
            }];
        return NO;
    }
    return YES;
}

@end
