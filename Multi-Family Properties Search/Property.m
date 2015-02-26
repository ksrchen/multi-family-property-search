//
//  Property.m
//  Multi-Family Properties Search
//
//  Created by Kevin Chen on 2/5/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "Property.h"

@implementation Property

@synthesize title;
@synthesize coordinate;
@synthesize MLNumber;

-(id)initWithAddress:(NSString*) address
         andLocation:(CLLocationCoordinate2D) location
         andMLNumber:(NSString *) mlNumber;
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    title  = address;
    coordinate = location;
    self.MLNumber = mlNumber;
    return self;
}

@end
