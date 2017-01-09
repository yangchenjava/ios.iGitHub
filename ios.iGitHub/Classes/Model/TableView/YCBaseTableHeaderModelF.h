//
//  YCBaseTableHeaderModelF.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/28.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kFontName [UIFont boldSystemFontOfSize:17]
#define kFontDesc [UIFont systemFontOfSize:15]

@class YCBaseTableHeaderModel;

@interface YCBaseTableHeaderModelF : NSObject

@property (nonatomic, strong) YCBaseTableHeaderModel *tableHeaderModel;

@property (nonatomic, assign, readonly) CGRect avatarF;
@property (nonatomic, assign, readonly) CGRect nameF;
@property (nonatomic, assign, readonly) CGRect descF;

@property (nonatomic, assign, readonly) CGFloat tableHeaderViewWidth;
@property (nonatomic, assign, readonly) CGFloat tableHeaderViewHeight;

@end
