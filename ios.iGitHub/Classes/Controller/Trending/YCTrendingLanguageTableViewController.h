//
//  YCTrendingLanguageTableViewController.h
//  ios.iGitHub
//
//  Created by yangc on 2017/11/27.
//  Copyright © 2017年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCTrendingLanguageResult;

@interface YCTrendingLanguageTableViewController : UITableViewController

@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) void (^callback)(YCTrendingLanguageResult *trendingLanguage);

@end
