//
//  YCReposResult.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/10.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YCProfileResult;

@interface YCReposResult : NSObject

/**
 *  @author yangc, 16-07-10 17:07:00
 *
 *  21277933
 */
@property (nonatomic, assign) long ID;
/**
 *  @author yangc, 16-07-10 17:07:05
 *
 *  com.yangc.platform
 */
@property (nonatomic, copy) NSString *name;
/**
 *  @author yangc, 16-07-10 17:07:14
 *
 *  yangchenjava/com.yangc.platform
 */
@property (nonatomic, copy) NSString *full_name;
/**
 *  @author yangc, 16-07-10 17:07:26
 *
 *  YCProfileResult
 */
@property (nonatomic, strong) YCProfileResult *owner;
/**
 *  @author yangc, 16-07-12 15:07:16
 *
 *  false
 */
@property (nonatomic, assign) BOOL pvt;
/**
 *  @author yangc, 16-07-10 17:07:36
 *
 *  https://github.com/yangchenjava/com.yangc.platform
 */
@property (nonatomic, copy) NSString *html_url;
/**
 *  @author yangc, 16-07-10 17:07:49
 *
 *  基于shiro的权限框架实现，为正在做这方面的童鞋提供方向
 */
@property (nonatomic, copy) NSString *desc;
/**
 *  @author yangc, 16-07-10 17:07:58
 *
 *  https://api.github.com/repos/yangchenjava/com.yangc.platform
 */
@property (nonatomic, copy) NSString *url;
/**
 *  @author yangc, 16-07-10 17:07:08
 *
 *  2014-06-27T14:11:39Z
 */
@property (nonatomic, strong) NSDate *created_at;
/**
 *  @author yangc, 16-07-10 17:07:20
 *
 *  2016-03-24T01:32:23Z
 */
@property (nonatomic, strong) NSDate *updated_at;
/**
 *  @author yangc, 16-07-10 17:07:30
 *
 *  2016-06-14T01:45:29Z
 */
@property (nonatomic, strong) NSDate *pushed_at;
/**
 *  @author yangc, 16-07-10 17:07:39
 *
 *  网站主页
 */
@property (nonatomic, copy) NSString *homepage;
/**
 *  @author yangc, 16-07-10 17:07:09
 *
 *  5967
 */
@property (nonatomic, assign) long size;
/**
 *  @author yangc, 16-07-10 17:07:35
 *
 *  27
 */
@property (nonatomic, assign) long stargazers_count;
/**
 *  @author yangc, 16-07-10 17:07:49
 *
 *  27
 */
@property (nonatomic, assign) long watchers_count;
/**
 *  @author yangc, 16-07-10 17:07:52
 *
 *  Java
 */
@property (nonatomic, copy) NSString *language;
/**
 *  @author yangc, 16-07-10 17:07:12
 *
 *  true
 */
@property (nonatomic, assign) BOOL has_issues;
/**
 *  @author yangc, 16-07-10 17:07:29
 *
 *  true
 */
@property (nonatomic, assign) BOOL has_downloads;
/**
 *  @author yangc, 16-07-10 17:07:33
 *
 *  25
 */
@property (nonatomic, assign) long forks_count;
/**
 *  @author yangc, 16-07-10 17:07:47
 *
 *  1
 */
@property (nonatomic, assign) long open_issues_count;

/**
 *  @author yangc, 16-07-12 17:07:48
 *
 *  YCReposResult
 */
@property (nonatomic, strong) YCReposResult *parent;

@end
