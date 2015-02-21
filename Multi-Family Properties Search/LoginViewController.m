//
//  LoginViewController.m
//  Multi-Family Properties Search
//
//  Created by Kevin Chen on 2/16/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UserDataStore.h"
#import "NSUserDefaultsCategory.h"

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
    [self setTitle:@"Login"];
}

-(void)viewDidAppear:(BOOL)animated{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    User * user =(User*)[defaults loadCustomObjectWithKey:USER];
    [[self account] setText:user.UserID];
    [[self password] setText:user.Password];
    
}

- (IBAction)signIn:(id)sender {
    
    UIAlertController * messageController = [UIAlertController alertControllerWithTitle:@"Error" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [ UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [messageController addAction:okAction];
    
    NSString * userID = [[self account] text];
    NSString * password = [[self password] text];
    
    if ([userID length] <= 0)
    {
        [messageController setMessage:@"User ID is required"];
        [self presentViewController:messageController animated:YES completion:nil];
        return;
    }
    
    if ([password length] <= 0)
    {
        [messageController setMessage:@"Password is required"];
        [self presentViewController:messageController animated:YES completion:nil];
        return;
    }
    
    [self.ActivityIndicatorView startAnimating];
    
    [[UserDataStore getInstance]loginWithUserID:userID andPassword:password success:^(NSURLSessionDataTask *task) {
        [self.ActivityIndicatorView stopAnimating];
        [AppDelegate showRootController];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.ActivityIndicatorView stopAnimating];
        [messageController setMessage:@"Log in failed. Please try again."];
        [self presentViewController:messageController animated:YES completion:nil];

    }
     ];
}
@end
