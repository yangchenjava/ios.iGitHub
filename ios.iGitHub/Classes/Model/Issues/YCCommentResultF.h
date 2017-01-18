//
//  YCCommentResultF.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/30.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kMargin 10
#define kFontName [UIFont systemFontOfSize:16 weight:UIFontWeightMedium]
#define kFontDate [UIFont systemFontOfSize:13 weight:UIFontWeightLight]

@class YCCommentResult;

@interface YCCommentResultF : NSObject

@property (nonatomic, strong) YCCommentResult *comment;

@property (nonatomic, assign, readonly) CGRect avatarF;
@property (nonatomic, assign, readonly) CGRect nameF;
@property (nonatomic, assign, readonly) CGRect dateF;
@property (nonatomic, assign, readonly) CGRect contentF;
@property (nonatomic, assign, readonly) CGRect separatorF;

@end
