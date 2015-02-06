//
//  Property.h
//  Multi-Family Properties Search
//
//  Created by Kevin Chen on 2/5/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Property : NSObject
@property (weak, nonatomic) NSString * address;
@property (nonatomic) CLLocationCoordinate2D location;

-(id)initWithAddress:(NSString*) address andLocation:(CLLocationCoordinate2D) location;
@end
