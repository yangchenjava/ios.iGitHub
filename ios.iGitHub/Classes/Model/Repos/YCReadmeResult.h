//
//  YCReadmeResult.h
//  ios.iGitHub
//
//  Created by yangc on 16/8/2.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCReadmeResult : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sha;
@property (nonatomic, assign) long size;
@property (nonatomic, copy) NSString *download_url;
@property (nonatomic, copy) NSString *content;

@end
