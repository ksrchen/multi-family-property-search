//
//  Expense.h
//  Multi-Family Properties Search
//
//  Created by kevin chen on 2/26/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Expense : NSObject
@property (nonatomic, copy) NSString * ExpenseType;
@property (nonatomic, copy) NSNumber * ExpenseAmount;

-(id)initWithExpenseType:(NSString*) type
               andAmount:(NSNumber *) amount;

@end
