//
//  YCBaseTableViewController.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/15.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCBaseTableHeaderModel;

@interface YCBaseTableViewController : UITableViewController

@property (nonatomic, strong) YCBaseTableHeaderModel *tableHeaderModel;
@property (nonatomic, strong) NSArray *groupArray;

@end
