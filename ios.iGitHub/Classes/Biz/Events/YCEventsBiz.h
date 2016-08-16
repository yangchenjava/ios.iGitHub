//
//  YCEventsBiz.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/19.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCEventsBiz : NSObject

+ (void)eventsWithUsername:(NSString *)username reposname:(NSString *)reposname page:(int)page success:(void (^)(NSArray *results))success failure:(void (^)(NSError *error))failure;

@end
