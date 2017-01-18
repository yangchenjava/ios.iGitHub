//
//  YCScannerView.h
//  ios.iGitHub
//
//  Created by yangc on 16/9/19.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScannerSize CGSizeMake(YC_ScreenWidth * 2 / 3, YC_ScreenWidth * 2 / 3)

@interface YCScannerView : UIView

- (void)startAnimation;
- (void)stopAnimation;

@end
