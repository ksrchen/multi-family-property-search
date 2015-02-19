//
//  RegisterViewController.m
//  Multi-Family Properties Search
//
//  Created by Kevin Chen on 2/16/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "RegisterViewController.h"
#import "User.h"
#import "UserDataStore.h"

@implementation RegisterViewController

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self setTitle:@"Register"];
}
- (IBAction)register:(id)sender {
    
    UIAlertController * messageController = [UIAlertController alertControllerWithTitle:@"Error" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [ UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [messageController addAction:okAction];
    
    NSString * userID = [[self userID] text];
    NSString * password = [[self password] text];
    NSString * passwordConfirmation = [[self passwordConfirmation] text];
    
    NSString * firstName = [[self firstName] text];
    NSString * lastName = [[self lastName] text];
    
    
    if ([userID length] <= 0)
    {
        [messageController setMessage:@"User ID is required"];
        [self presentViewController:messageController animated:YES completion:nil];
        return;
    }
    
    if (![self validateEmail:userID])
    {
        [messageController setMessage:@"User ID is a valid email address"];
        [self presentViewController:messageController animated:YES completion:nil];
        return;
    }
    
    if ([password length] <= 0)
    {
        [messageController setMessage:@"Password is required"];
        [self presentViewController:messageController animated:YES completion:nil];
        return;
    }
    if ([password compare:passwordConfirmation] != 0){
        [messageController setMessage:@"Password and password confirmation does not match"];
        [self presentViewController:messageController animated:YES completion:nil];
        return;
    }

    if ([firstName length] <= 0)
    {
        [messageController setMessage:@"First name is required"];
        [self presentViewController:messageController animated:YES completion:nil];
        return;
    }
    
    if ([lastName length] <= 0)
    {
        [messageController setMessage:@"Last name is required"];
        [self presentViewController:messageController animated:YES completion:nil];
        return;
    }
    
    User * user = [[User alloc] init];
    user.userID = userID;
    user.password = password;
    user.FirstName = firstName;
    user.LastName = lastName;
    [self.ActivityIndicatorView startAnimating];
    [[UserDataStore getInstance] registerUser:user success:^(NSURLSessionDataTask *task) {
        [self.ActivityIndicatorView stopAnimating];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.ActivityIndicatorView stopAnimating];
        [messageController setMessage:@"Registration failed. Please try again."];
        [self presentViewController:messageController animated:YES completion:nil];
    }
];

}
@end
