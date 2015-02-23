//
//  PropertyDataStore.h
//  Multi-Family Properties Search
//
//  Created by Kevin Chen on 2/14/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>

@interface PropertyDataStore : AFHTTPSessionManager

+ (PropertyDataStore *)getInstance;
- (void)getPropertiesForRegion:(NSString *)polygon
                    withFilters:(NSString *)filters
                     success:(void(^)(NSURLSessionDataTask *task, NSMutableArray * properties))success
                     failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)getProperty:(NSString *)MLNumber
                       success:(void(^)(NSURLSessionDataTask *task, id property))success
                       failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;


@end