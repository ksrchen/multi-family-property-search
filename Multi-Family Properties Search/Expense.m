//
//  Expense.m
//  Multi-Family Properties Search
//
//  Created by kevin chen on 2/26/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "Expense.h"

@implementation Expense

-(id)initWithExpenseType:(NSString*) type
         andAmount:(NSNumber *) amount
{
    self = [super init];
    if (!self) {
        return nil;
    }
   
    self.ExpenseType = type;
    self.ExpenseAmount = amount;
   
    return self;
}


@end
