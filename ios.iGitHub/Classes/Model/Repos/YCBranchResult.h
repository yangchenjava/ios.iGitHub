//
//  YCBranchResult.h
//  ios.iGitHub
//
//  Created by yangc on 16/8/9.
//  Copyright © 2016年 yangc. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface YCBranchResult : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *name;

@end
