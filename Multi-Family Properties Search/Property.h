//
//  Property.h
//  Multi-Family Properties Search
//
//  Created by Kevin Chen on 2/5/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Property : NSObject <MKAnnotation>

//@property (weak, nonatomic) NSString * title;
//@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy  ) NSString *MLNumber;
@property (nonatomic, copy) NSString *MediaURL;
@property (nonatomic, strong) NSNumber *ROI;
@property (nonatomic, strong) NSNumber *Price;

-(id)initWithAddress:(NSString*) address
         andLocation:(CLLocationCoordinate2D) location
         andMLNumber:(NSString *) mlNumber
            mediaURL: (NSString *) mediaURL
                 roi:(NSNumber*) roi
               price:(NSNumber*) price;
@end
