//
//  YCNewsBiz.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/18.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCNewsBiz : NSObject

+ (void)newsWithUsername:(NSString *)username success:(void (^)(NSArray *results))success failure:(void (^)(NSError *error))failure;

@end
