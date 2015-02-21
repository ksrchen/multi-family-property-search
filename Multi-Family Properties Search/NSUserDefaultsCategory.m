//
//  NSUserDefaultsCategory.m
//  Multi-Family Properties Search
//
//  Created by Kevin Chen on 2/21/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "NSUserDefaultsCategory.h"

@implementation NSUserDefaults (NSUserDefaultsCategory)

- (void)saveCustomObject:(id<NSCoding>)object
                     key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    [self setObject:encodedObject forKey:key];
    [self synchronize];
    
}

- (id<NSCoding>)loadCustomObjectWithKey:(NSString *)key {
    NSData *encodedObject = [self objectForKey:key];
    id<NSCoding> object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

@end
