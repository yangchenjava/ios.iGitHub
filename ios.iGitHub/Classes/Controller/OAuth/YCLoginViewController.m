//
//  YCLoginViewController.m
//  ios.iGitHub
//
//  Created by yangc on 16/7/7.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <YCHelpKit/MBProgressHUD+Category.h>
#import <YCHelpKit/UIImage+Category.h>
#import <YCHelpKit/UIImageView+SDWebImageCategory.h>

#import "YCGitHubUtils.h"
#import "YCLoginViewController.h"
#import "YCOAuthResult.h"
#import "YCProfileBiz.h"
#import "YCProfileResult.h"

@interface YCLoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *aiv;

@end

@implementation YCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageView.image = [[UIImage imageNamed:@"login_user_unknown"] imageWithTintColor:YC_Color_RGB(87, 87, 87)];
    YCProfileResult *profile = [YCGitHubUtils profile];
    if (profile) {
        self.label.hidden = NO;
        self.aiv.hidden = NO;
        self.label.text = [NSString stringWithFormat:@"Logging in as %@", profile.login];
    } else {
        self.label.hidden = YES;
        self.aiv.hidden = YES;
    }

    [self setupProfile];
}

- (void)setupProfile {
    [YCProfileBiz profileWithAccessToken:[YCGitHubUtils oauth].access_token
        success:^(YCProfileResult *result) {
            [YCGitHubUtils setProfile:result];
            self.label.hidden = NO;
            self.aiv.hidden = NO;
            self.label.text = [NSString stringWithFormat:@"Logging in as %@", result.login];

            [self.imageView sd_setImageCircleWithURL:[NSURL URLWithString:result.avatar_url]
                                    placeholderImage:self.imageView.image
                                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                   [YCGitHubUtils setupRootViewController];
                                               });
                                           }];
        }
        failure:^(NSError *error) {
            [MBProgressHUD showError:error.localizedDescription];
        }];
}

@end
