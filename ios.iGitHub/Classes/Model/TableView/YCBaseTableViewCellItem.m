//
//  YCBaseTableViewCellItem.m
//  ios.iGitHub
//
//  Created by yangc on 16-5-8.
//  Copyright (c) 2016年 yangc. All rights reserved.
//

#import "YCBaseTableViewCellItem.h"

@implementation YCBaseTableViewCellItem

+ (instancetype)itemWithTitle:(NSString *)title {
    return [self itemWithTitle:title icon:nil];
}

+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon {
    return [self itemWithTitle:title icon:icon subtitle:nil];
}

+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon subtitle:(NSString *)subtitle {
    return [self itemWithTitle:title icon:icon subtitle:subtitle destClass:nil instanceVariables:nil];
}

+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon subtitle:(NSString *)subtitle destClass:(Class)destClass instanceVariables:(NSDictionary *)instanceVariables {
    YCBaseTableViewCellItem *item = [[self alloc] init];
    item.title = title;
    item.icon = icon;
    item.subtitle = subtitle;
    item.destClass = destClass;
    item.instanceVariables = instanceVariables;
    return item;
}

@end
