//
//  PropertyDataStore.m
//  Multi-Family Properties Search
//
//  Created by Kevin Chen on 2/14/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "PropertyDataStore.h"
#import "Property.h"
#import "User.h"
#import "UserDataStore.h"

NSString* const baseURLString = @"http://kmlservice.azurewebsites.net/api/";

@implementation PropertyDataStore {
    BOOL _searching;
}

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
    _searching = NO;
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFJSONRequestSerializer serializer];

    return self;
}

- (void)getHottestProperties:(void(^)(NSURLSessionDataTask *task, NSMutableArray * properties))success
                     failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    [self.requestSerializer setValue:[[UserDataStore getInstance] getUser].UserID forHTTPHeaderField:@"From"];
    
    self.properties = [[NSMutableArray alloc] init];
   // NSString *filters = @"GrossOperatingIncome>1000";
    //NSString *polygon = @"POLYGON((-118.12738095737302 33.881694872069836, -118.23870336032712 33.881694872069836,-118.23870336032712 33.84798421519106,-118.12738095737302 33.84798421519106,-118.12738095737302 33.881694872069836))";
    
   // NSDictionary * params = [ [NSDictionary alloc] initWithObjectsAndKeys:polygon, @"Polygon", filters, @"Filters", nil];
    
    NSString* path = @"hottestproperties";
    
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            NSLog(@"Success -- %@", responseObject);
            NSArray * responses = responseObject;
            for (NSDictionary *prop in responses) {
                NSString * address = [NSString stringWithFormat:@"%@ %@ %@, %@ %@",
                                      prop[@"StreetNumber"],
                                      prop[@"StreetName"],
                                      prop[@"City"],
                                      prop[@"State"],
                                      prop[@"PostalCode"]
                                      ];
                
                NSNumber *roi = prop[@"ROI"];
                NSNumber *price = prop[@"ListPrice"];

                
                [self.properties addObject:[[Property alloc] initWithAddress:address
                                                                 andLocation:CLLocationCoordinate2DMake([prop[@"Latitude"] doubleValue],
                                                                                                        [prop[@"longitude"] doubleValue])
                                                                 andMLNumber:prop[@"MLnumber"]
                                                                    mediaURL: prop[@"MediaURL"]
                                                                         roi:roi
                                                                       price:price
                                            ]];
                
            }
            success(task, self.properties);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];
    
    
}

- (void)getPropertiesForRegion:(NSString *)polygon
                   withFilters:(NSString *)filters
                       success:(void(^)(NSURLSessionDataTask *task, NSMutableArray * properties))success
                       failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    if (_searching) {
        return;
    }
    _searching = YES;
    [self.requestSerializer setValue:[[UserDataStore getInstance] getUser].UserID forHTTPHeaderField:@"From"];
    
    self.properties = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PropertyListingUpdated" object:nil];
    
    NSDictionary * params = [ [NSDictionary alloc] initWithObjectsAndKeys:polygon, @"Polygon", filters, @"Filters", nil];
    
    NSString* path = @"resincome";
    
    [self PUT:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        _searching = NO;
        if (success) {
            NSLog(@"Success -- %@", responseObject);
            NSArray * responses = responseObject;
            NSMutableArray *properties = [[NSMutableArray alloc] init];
            for (NSDictionary *prop in responses) {
                //NSLog(@"City %@", prop[@"City"]);
                NSString * address = [NSString stringWithFormat:@"%@ %@ %@, %@ %@",
                                      prop[@"StreetNumber"],
                                      prop[@"StreetName"],
                                      prop[@"City"],
                                      prop[@"State"],
                                      prop[@"PostalCode"]
                                      ];
                NSNumber *roi = prop[@"ROI"];
                NSNumber *price = prop[@"ListPrice"];
                
                [properties addObject:[[Property alloc] initWithAddress:address
                                                            andLocation:CLLocationCoordinate2DMake([prop[@"Latitude"] doubleValue],
                                                                                                   [prop[@"longitude"] doubleValue])
                                                            andMLNumber:prop[@"MLnumber"]
                                                               mediaURL: prop[@"MediaURL"]
                                                                    roi:roi
                                                                  price:price
                                       ]];
                
            }
            self.properties = properties;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PropertyListingUpdated" object:nil];
            success(task, properties);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        _searching = NO;
        if (failure) {
            failure(task, error);
        }
    }];
}

- (void)getProperty:(NSString *)MLNumber
            success:(void(^)(NSURLSessionDataTask *task, id property))success
            failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    [self.requestSerializer setValue:[[UserDataStore getInstance] getUser].UserID forHTTPHeaderField:@"From"];
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
    [self.requestSerializer setValue:[[UserDataStore getInstance] getUser].UserID forHTTPHeaderField:@"From"];
    
    NSString* path = @"favorite";
    NSDictionary * params = [ [NSDictionary alloc] initWithObjectsAndKeys:userId, @"userId", nil];
    
    [self GET:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            NSLog(@"Success -- %@", responseObject);
            NSArray * responses = responseObject;
            for (NSDictionary *prop in responses) {
                NSString * address = [NSString stringWithFormat:@"%@ %@ %@, %@ %@",
                                      prop[@"StreetNumber"],
                                      prop[@"StreetName"],
                                      prop[@"City"],
                                      prop[@"State"],
                                      prop[@"PostalCode"]
                                      ];
                
                NSNumber *roi = prop[@"ROI"];
                NSNumber *price = prop[@"ListPrice"];

                [properties addObject:[[Property alloc] initWithAddress:address
                                                            andLocation:CLLocationCoordinate2DMake([prop[@"Latitude"] doubleValue],
                                                                                                   [prop[@"longitude"] doubleValue])
                                                            andMLNumber:prop[@"MLnumber"]
                                                               mediaURL: prop[@"MediaURL"]
                                                                    roi:roi
                                                                  price:price
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
    [self.requestSerializer setValue:[[UserDataStore getInstance] getUser].UserID forHTTPHeaderField:@"From"];
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
    [self.requestSerializer setValue:[[UserDataStore getInstance] getUser].UserID forHTTPHeaderField:@"From"];
    
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
