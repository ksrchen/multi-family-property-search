//
//  ReportManager.m
//  Chrometopia
//
//  Created by Kevin Chen on 7/25/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "ReportManager.h"

extern NSString* const baseURLString;

@implementation ReportManager

+ (instancetype)getInstance {
    static ReportManager *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
    });
    return _sharedClient;
}


-(void)getReport:(NSString*)MLNumber
           success:(void(^)(NSURL *filePath))success
           failure:(void(^)(NSError *error))failure;

{
    NSString* path = [NSString stringWithFormat:@"%@/Report/%@", baseURLString, MLNumber];
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    NSString *documentsDirectory = [NSHomeDirectory()
                                    stringByAppendingPathComponent:@"Documents"];

    NSString *fileName = [NSString stringWithFormat:@"%@.pdf", MLNumber];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:fullPath append:NO]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"RES: %@", [[[operation response] allHeaderFields] description]);
        
        NSError *error;
       [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:&error];
        if (error) {
            NSLog(@"ERR: %@", [error description]);
            failure(error);
        } else {
            NSURL *url = [NSURL fileURLWithPath:fullPath];
            success(url);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERR: %@", [error description]);
        failure(error);
    }];
    
    [operation start];
    
}

@end
