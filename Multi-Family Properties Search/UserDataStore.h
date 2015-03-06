//
//  UserDataStore.h
//  Multi-Family Properties Search
//
//  Created by Kevin Chen on 2/16/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "User.h"

extern NSString * const USER;

@interface UserDataStore :  AFHTTPSessionManager

+ (instancetype)getInstance;

- (void)loginWithUserID:(NSString*) userID andPassword:(NSString*) password
                success:(void(^)(NSURLSessionDataTask *task))success
                failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void) registerUser:(User*) user
              success:(void(^)(NSURLSessionDataTask *task))success
              failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

- (BOOL) isAuthenticated;
- (void) logOut;
- (User*) getUser;

@end
