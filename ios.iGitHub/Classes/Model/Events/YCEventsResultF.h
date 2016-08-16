//
//  YCEventsResultF.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/21.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "YCEventsResult.h"

#define kFontDate [UIFont systemFontOfSize:13]
#define kFontContent [UIFont systemFontOfSize:17]
#define kFontDesc [UIFont systemFontOfSize:15]

@interface YCEventsResultF : NSObject

@property (nonatomic, strong) YCEventsResult *events;

@property (nonatomic, assign, readonly) CGRect typeF;
@property (nonatomic, assign, readonly) CGRect avatarF;
@property (nonatomic, assign, readonly) CGRect dateF;
@property (nonatomic, assign, readonly) CGRect contentF;
@property (nonatomic, assign, readonly) CGRect descF;

@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end
