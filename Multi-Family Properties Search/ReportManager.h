//
//  ReportManager.h
//  Chrometopia
//
//  Created by Kevin Chen on 7/25/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>

@interface ReportManager : AFHTTPSessionManager

+ (instancetype)getInstance;

-(void)getReport:(NSString*)MLNumber
            success:(void(^)(NSURL *filePath))success
            failure:(void(^)(NSError *error))failure;

@end
