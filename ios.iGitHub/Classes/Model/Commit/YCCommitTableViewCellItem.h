//
//  YCCommitTableViewCellItem.h
//  ios.iGitHub
//
//  Created by yangc on 16/8/5.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import "YCBaseTableViewCellItem.h"

@interface YCCommitTableViewCellItem : YCBaseTableViewCellItem

@property (nonatomic, assign) long additions;
@property (nonatomic, assign) long deletions;
@property (nonatomic, copy) NSString *patch;

@end
