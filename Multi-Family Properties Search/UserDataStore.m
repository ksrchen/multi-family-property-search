//
//  UserDataStore.m
//  Multi-Family Properties Search
//
//  Created by Kevin Chen on 2/16/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "UserDataStore.h"
#import "NSUserDefaultsCategory.h"

extern NSString* const baseURLString;

NSString * const USER=@"User";

@implementation UserDataStore

+ (instancetype)getInstance {
    static UserDataStore *_sharedClient = nil;
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


- (void)loginWithUserID:(NSString*) userID andPassword:(NSString*) password
                success:(void(^)(NSURLSessionDataTask *task))success
                failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

{
    NSDictionary * params = [ [NSDictionary alloc] initWithObjectsAndKeys:userID, @"userID", password, @"password", nil];
    
    NSString* path = @"User";
    
    [self GET:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            
            NSDictionary * data = (NSDictionary*) responseObject;
            User * user = [[User alloc] init];
            
            user.FirstName = [data objectForKey:@"FirstName"];
            user.LastName = [data objectForKey:@"LastName"];
            user.UserID = [data objectForKey:@"UserID"];
            user.Password = [data objectForKey:@"Password"];
            
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults saveCustomObject:user key:USER];
           
            success(task);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];
}

- (void) registerUser:(User*) user
              success:(void(^)(NSURLSessionDataTask *task))success
              failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

{
    NSString* path = @"User";
    
    NSDictionary * params = [ [NSDictionary alloc] initWithObjectsAndKeys:
                             user.UserID, @"userID",
                             user.Password, @"Password",
                             user.FirstName, @"FirstName",
                             user.LastName, @"LastName",
//                             @"1", @"Active",
                             nil];
    
    [self POST:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults saveCustomObject:user key:USER];
            success(task);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];

}
- (BOOL) isAuthenticated
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    User * user = (User*) [defaults loadCustomObjectWithKey:USER];
    return (user != nil);
}
- (void) logOut
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:USER];
    
}

@end
