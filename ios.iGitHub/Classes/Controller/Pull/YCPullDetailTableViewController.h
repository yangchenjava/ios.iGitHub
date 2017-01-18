//
//  YCPullDetailTableViewController.h
//  ios.iGitHub
//
//  Created by yangc on 16/8/4.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YCBaseTableViewController.h"

@interface YCPullDetailTableViewController : YCBaseTableViewController

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *reposname;
@property (nonatomic, assign) long number;

@end
