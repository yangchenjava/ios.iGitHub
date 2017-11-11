//
//  YCCommitTableViewController.h
//  ios.iGitHub
//
//  Created by yangc on 16/8/3.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import "YCTableViewController.h"

@interface YCCommitTableViewController : YCTableViewController

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *reposname;
@property (nonatomic, strong) NSNumber *number;

@end
