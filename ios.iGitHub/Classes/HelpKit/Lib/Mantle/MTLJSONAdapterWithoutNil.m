//
//  MTLJSONAdapterWithoutNil.m
//  ios_utils
//
//  Created by yangc on 16-4-28.
//  Copyright (c) 2016年 yangc. All rights reserved.
//

#import "MTLJSONAdapterWithoutNil.h"

@implementation MTLJSONAdapterWithoutNil

- (NSSet *)serializablePropertyKeys:(NSSet *)propertyKeys forModel:(id<MTLJSONSerializing>)model {
    NSMutableSet *modifiedPropertyKeys = propertyKeys.mutableCopy;

    NSDictionary *dict = [model dictionaryValue];
    for (NSString *key in propertyKeys) {
        if ([[dict valueForKey:key] isEqual:[NSNull null]]) {
            [modifiedPropertyKeys removeObject:key];
        }
    }

    return modifiedPropertyKeys.copy;
}

@end
