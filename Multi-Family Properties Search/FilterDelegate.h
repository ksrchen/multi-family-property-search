//
//  FilterOptions.h
//  Multi-Family Properties Search
//
//  Created by kevin chen on 3/3/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FilterDelegate <NSObject>
@required
- (void) ApplyFilter: (NSString *) filters;
- (void) ClearFilter;

@end

