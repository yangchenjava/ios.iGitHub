//
//  YCProfileResult.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/7.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCProfileResult : NSObject

/**
 *  @author yangc, 16-07-07 16:07:14
 *
 *  yangchenjava
 */
@property (nonatomic, copy) NSString *login;
/**
 *  @author yangc, 16-07-07 16:07:32
 *
 *  7478565
 */
@property (nonatomic, assign) long ID;
/**
 *  @author yangc, 16-07-07 16:07:40
 *
 *  https://avatars.githubusercontent.com/u/7478565?v=3
 */
@property (nonatomic, copy) NSString *avatar_url;
/**
 *  @author yangc, 16-07-07 16:07:50
 *
 *  yangc
 */
@property (nonatomic, copy) NSString *name;
/**
 *  @author yangc, 16-07-07 16:07:07
 *
 *  QQ 511636835
 */
@property (nonatomic, copy) NSString *company;
/**
 *  @author yangc, 16-07-07 16:07:16
 *
 *  null
 */
@property (nonatomic, copy) NSString *blog;
/**
 *  @author yangc, 16-07-07 16:07:24
 *
 *  沈阳
 */
@property (nonatomic, copy) NSString *location;
/**
 *  @author yangc, 16-07-07 16:07:32
 *
 *  yangchen_java@126.com
 */
@property (nonatomic, copy) NSString *email;
/**
 *  @author yangc, 16-07-07 16:07:40
 *
 *  null
 */
@property (nonatomic, copy) NSString *bio;
/**
 *  @author yangc, 16-07-07 16:07:44
 *
 *  66
 */
@property (nonatomic, assign) long public_repos;
/**
 *  @author yangc, 16-07-07 16:07:52
 *
 *  0
 */
@property (nonatomic, assign) long public_gists;
/**
 *  @author yangc, 16-07-07 16:07:56
 *
 *  31
 */
@property (nonatomic, assign) long followers;
/**
 *  @author yangc, 16-07-07 16:07:02
 *
 *  0
 */
@property (nonatomic, assign) long following;
/**
 *  @author yangc, 16-07-07 16:07:08
 *
 *  2014-05-04T06:36:43Z
 */
@property (nonatomic, strong) NSDate *created_at;
/**
 *  @author yangc, 16-07-07 16:07:18
 *
 *  2016-06-14T10:04:27Z
 */
@property (nonatomic, strong) NSDate *updated_at;
/**
 *  @author yangc, 16-07-07 16:07:18
 *
 *  2016-06-14T10:04:27Z
 */
@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) NSString *highlighter;

@end
