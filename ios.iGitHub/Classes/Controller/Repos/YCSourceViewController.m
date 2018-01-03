//
//  YCSourceViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/8/10.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <MJExtension/MJExtension.h>
#import <YCHelpKit/MBProgressHUD+Category.h>
#import <YCHelpKit/UIView+Category.h>
#import <YCHelpKit/UIViewController+Category.h>

#import "YCContentResult.h"
#import "YCReposBiz.h"
#import "YCSourceViewController.h"
#import "YCPickerView.h"
#import "YCGitHubUtils.h"
#import "YCProfileResult.h"

@interface YCSourceViewController () <UIWebViewDelegate, YCPickerViewDelegate>

@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, weak) YCPickerView *pickView;

@property (nonatomic, strong) YCContentResult *content;
@property (nonatomic, assign, getter=isRaw) BOOL raw;

@end

@implementation YCSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"SH" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightBarButtonItem)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupWebView];
}

- (void)clickRightBarButtonItem {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    NSArray <NSString *> *styles = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"styles" ofType:@"plist"]];
    YCPickerView *pickView = [[YCPickerView alloc] initWithFrame:CGRectMake(0, YC_ScreenHeight, YC_ScreenWidth, 350) defaultSelectRows:@[ @([styles indexOfObject:[YCGitHubUtils profile].highlighter]) ]];
    pickView.delegate = self;
    pickView.components = @[ styles ];
    [self.view addSubview:pickView];
    self.pickView = pickView;
    [UIView animateWithDuration:0.2 animations:^{
        self.pickView.y = YC_ScreenHeight - self.pickView.height;
    }];
}

- (void)pickerView:(YCPickerView *)pickerView didSelectComponent:(NSInteger)component row:(NSInteger)row title:(NSString *)title {
    [self setupHighlighter:title];
}

- (void)pickerView:(YCPickerView *)pickerView didClickDoneRows:(NSArray<NSNumber *> *)rows titles:(NSArray<NSString *> *)titles {
    [UIView animateWithDuration:0.2 animations:^{
        self.pickView.y = YC_ScreenHeight;
    } completion:^(BOOL finished) {
        if (finished) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [self.pickView removeFromSuperview];
            
            YCProfileResult *result = [YCGitHubUtils profile];
            result.highlighter = titles[0];
            [YCGitHubUtils setProfile:result];
        }
    }];
}

- (void)setupWebView {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.height -= (YC_StatusBarHeight + YC_NavigationBarHeight + YC_TabBarBottomSafeMargin);
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webView];
    self.webView = webView;

    NSString *extension = self.path.pathExtension.lowercaseString;
    if ([@[ @"jpg", @"jpeg", @"png", @"gif", @"bmp", @"doc", @"docx", @"xls", @"xlsx", @"pdf" ] containsObject:extension]) {
        self.raw = YES;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.download_url]]];
    } else if ([extension isEqualToString:@"mp4"]) {
        self.raw = YES;
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"highlight.html" withExtension:nil];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    } else {
        [YCReposBiz reposContentWithUsername:self.username
            reposname:self.reposname
            path:self.path
            ref:self.ref
            success:^(id result) {
                self.content = result;

                NSURL *url = [[NSBundle mainBundle] URLForResource:@"highlight.html" withExtension:nil];
                [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
            }
            failure:^(NSError *error) {
                [MBProgressHUD showError:error.localizedDescription];
            }];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *extension = self.path.pathExtension.lowercaseString;
    if (self.isRaw) {
        if ([extension isEqualToString:@"mp4"]) {
            webView.backgroundColor = YC_Color_RGB(38, 38, 38);
            [webView stringByEvaluatingJavaScriptFromString:@"$(\"body\").css(\"background-color\", \"#262626\");"];
            [webView stringByEvaluatingJavaScriptFromString:
                         [NSString stringWithFormat:@"$(\"body\").html($(\"<video src='%@' controls autobuffer width='100%%' height='100%%' style='margin: 45%% 0'></video>\"));", self.download_url]];
        }
    } else {
        // 根据扩展名定义样式
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
        [self setupHighlighter:[YCGitHubUtils profile].highlighter];
    }
}

- (void)setupHighlighter:(NSString *)highlighter {
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"$(\"#highlighter\").attr(\"href\", \"%@.css\");", highlighter]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [self presentWebViewControllerWithURL:request.URL animated:YES completion:nil];
    }
    return navigationType != UIWebViewNavigationTypeLinkClicked;
}

@end
