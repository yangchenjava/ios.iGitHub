//
//  YCIssuesDetailTableViewController.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/27.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import "YCBaseTableViewController.h"

@interface YCIssuesDetailTableViewController : YCBaseTableViewController

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *reposname;
@property (nonatomic, assign) long number;

@end
