//
//  NSUserDefaultsCategory.h
//  Multi-Family Properties Search
//
//  Created by Kevin Chen on 2/21/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (NSUserDefaultsCategory)

-(void)saveCustomObject:(id<NSCoding>)object
key:(NSString *)key;
- (id<NSCoding>)loadCustomObjectWithKey:(NSString *)key;

@end
