//
//  YCOAuthParam.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/5.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCOAuthParam : NSObject

/**
 *  @author yangc, 16-07-05 20:07:31
 *
 *  1b11aefcd2c9620683da
 */
@property (nonatomic, copy) NSString *client_id;

/**
 *  @author yangc, 16-07-05 20:07:56
 *
 *  0f59520f1bb2474128640a9c075cb4a16e79501f
 */
@property (nonatomic, copy) NSString *client_secret;

@property (nonatomic, copy) NSString *code;

@end
