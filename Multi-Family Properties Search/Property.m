//
//  Property.m
//  Multi-Family Properties Search
//
//  Created by Kevin Chen on 2/5/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "Property.h"

@implementation Property


-(id)initWithAddress:(NSString*) address andLocation:(CLLocationCoordinate2D) location
{
    self.address = address;
    self.location = location;
    return self;
}

@end
