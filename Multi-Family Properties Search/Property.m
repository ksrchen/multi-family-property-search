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

-(id)initWithAddress:(NSString*) address
         andLocation:(CLLocationCoordinate2D) location
         andMLNumber:(NSString *) mlNumber;
{
    title  = address;
    coordinate = location;
    _MLNumber = mlNumber;
    return self;
}

@end
