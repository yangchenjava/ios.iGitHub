//
//  YCScannerViewController.h
//  ios.iGitHub
//
//  Created by yangc on 16/9/19.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCScannerViewController : UIViewController

@property (nonatomic, copy) void (^success)(YCScannerViewController *vc, NSString *result);

+ (BOOL)isAvailable;

@end
