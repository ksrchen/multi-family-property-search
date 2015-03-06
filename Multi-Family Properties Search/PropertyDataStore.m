//
//  PropertyDataStore.m
//  Multi-Family Properties Search
//
//  Created by Kevin Chen on 2/14/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "PropertyDataStore.h"
#import "Property.h"

NSString* const baseURLString = @"http://kmlservice.azurewebsites.net/api/";

@implementation PropertyDataStore

+ (PropertyDataStore *)getInstance {
    static PropertyDataStore *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
    });
    return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    return self;
}

- (void)getPropertiesForRegion:(NSString *)polygon
                 withFilters:(NSString *)filters
                     success:(void(^)(NSURLSessionDataTask *task, NSMutableArray * properties))success
                     failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableArray *  properties = [[NSMutableArray alloc] init];
    
//    [properties addObject:[[Property alloc] initWithAddress:@"2000 Riverside Dr Los Angeles 90039" andLocation:CLLocationCoordinate2DMake(34.05, -118.24)]];
//    [properties addObject:[[Property alloc] initWithAddress:@"Westside Towers, West - 11845 W. Olympic Blvd" andLocation:CLLocationCoordinate2DMake(34.08, -118.20)]];
//    [properties addObject:[[Property alloc] initWithAddress:@"12400 Wilshire Los Angeles, CA" andLocation:CLLocationCoordinate2DMake(34.15, -118.14)]];
//    [properties addObject:[[Property alloc] initWithAddress:@"1766 Wilshire Blvd - Landmark II" andLocation:CLLocationCoordinate2DMake(34.0, -118.14)]];
//    [properties addObject:[[Property alloc] initWithAddress:@"Gateway LA - 12424 Wilshire Blvd" andLocation:CLLocationCoordinate2DMake(34.05, -118.24)]];
//    [properties addObject:[[Property alloc] initWithAddress:@"21800 Oxnard Street, Woodland Hills, CA 91367" andLocation:CLLocationCoordinate2DMake(34.19, -118.04)]];
//    [properties addObject:[[Property alloc] initWithAddress:@"G11990 San Vicente Blvd, Los Angeles, CA 90049" andLocation:CLLocationCoordinate2DMake(34.15, -118.0)]];
    
//    polygon = @"POLYGON((-118.12738095737302 33.881694872069836, -118.23870336032712 33.881694872069836,-118.23870336032712 33.84798421519106,-118.12738095737302 33.84798421519106,-118.12738095737302 33.881694872069836))";
    
    NSDictionary * params = [ [NSDictionary alloc] initWithObjectsAndKeys:polygon, @"Polygon", filters, @"Filters", nil];
    
    NSString* path = @"resincome";
    
    [self PUT:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            NSLog(@"Success -- %@", responseObject);
            NSArray * responses = responseObject;
            for (NSDictionary *prop in responses) {
                NSLog(@"City %@", prop[@"City"]);
                NSString * address = [NSString stringWithFormat:@"%@ %@, %@",
                                      prop[@"StreetNumber"],
                                      prop[@"StreetName"],
                                      prop[@"City"]
                                      ];

                [properties addObject:[[Property alloc] initWithAddress:address
                                       andLocation:CLLocationCoordinate2DMake([prop[@"Latitude"] doubleValue],
                                                                              [prop[@"longitude"] doubleValue])
                                                            andMLNumber:prop[@"MLnumber"]
                                       ]];
                
            }
            success(task, properties);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];
}

- (void)getProperty:(NSString *)MLNumber
            success:(void(^)(NSURLSessionDataTask *task, id property))success
            failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSString* path = [NSString stringWithFormat: @"resincome/%@", MLNumber];
    
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            NSLog(@"Success -- %@", responseObject);
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];
}

- (void)getMyListingForUser:(NSString *)userId
                    success:(void(^)(NSURLSessionDataTask *task, NSMutableArray * properties))success
                    failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableArray *  properties = [[NSMutableArray alloc] init];
    
    NSString* path = @"favorite";
    NSDictionary * params = [ [NSDictionary alloc] initWithObjectsAndKeys:userId, @"userId", nil];
    
    [self GET:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            NSLog(@"Success -- %@", responseObject);
            NSArray * responses = responseObject;
            for (NSDictionary *prop in responses) {
                NSString * address = [NSString stringWithFormat:@"%@ %@, %@",
                                      prop[@"StreetNumber"],
                                      prop[@"StreetName"],
                                      prop[@"City"]
                                      ];
                
                [properties addObject:[[Property alloc] initWithAddress:address
                                                            andLocation:CLLocationCoordinate2DMake([prop[@"Latitude"] doubleValue],
                                                                                                   [prop[@"longitude"] doubleValue])
                                                            andMLNumber:prop[@"MLnumber"]
                                       ]];
                
            }
            success(task, properties);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];

}

- (void)addMyListingForUser:(NSString *)userId
               withMLNumber:(NSString *) MLNumber
                    success:(void(^)(NSURLSessionDataTask *task, id property))success
                    failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSDictionary * params = [ [NSDictionary alloc] initWithObjectsAndKeys:userId, @"UserID", MLNumber, @"MLNumber", nil];
    NSString* path = @"favorite";

    [self POST:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];

    
}

- (void)removeMyListingForUser:(NSString *)userId
                  withMLNumber:(NSString *) MLNumber
                       success:(void(^)(NSURLSessionDataTask *task, id property))success
                       failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSDictionary * params = [ [NSDictionary alloc] initWithObjectsAndKeys:userId, @"userId", MLNumber, @"MLNumber", nil];
    NSString* path = @"favorite";
    
    [self DELETE:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];

    
}
@end
