//
//  NSMutableArray+Category.m
//  ios_utils
//
//  Created by yangc on 16-4-14.
//  Copyright (c) 2016年 yangc. All rights reserved.
//

#import "NSMutableArray+Category.h"

@implementation NSMutableArray (Category)

- (void)insertObjects:(NSArray *)objects atIndex:(NSUInteger)index {
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    for (NSUInteger i = index; i < index + objects.count; i++) {
        [indexes addIndex:i];
    }
    [self insertObjects:objects atIndexes:indexes];
}

@end
