//
//  YCCommitDetailTableViewController.h
//  ios.iGitHub
//
//  Created by yangc on 16/8/5.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YCBaseTableViewController.h"

@interface YCCommitDetailTableViewController : YCBaseTableViewController

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *reposname;
@property (nonatomic, copy) NSString *sha;

@end
