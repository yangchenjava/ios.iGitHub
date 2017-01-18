//
//  YCBaseTableViewCellGroup.h
//  ios.iGitHub
//
//  Created by yangc on 16-5-8.
//  Copyright (c) 2016年 yangc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCBaseTableViewCellGroup : NSObject

@property (nonatomic, copy) NSString *header;
@property (nonatomic, copy) NSString *footer;
@property (nonatomic, strong) NSArray *itemArray;

@end
