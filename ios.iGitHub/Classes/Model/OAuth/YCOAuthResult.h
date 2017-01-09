//
//  YCOAuthResult.h
//  ios.iGitHub
//
//  Created by yangc on 16/7/5.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface YCOAuthResult : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) NSString *scope;
@property (nonatomic, copy) NSString *token_type;

@end
