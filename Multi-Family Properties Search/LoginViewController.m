//
//  LoginViewController.m
//  Multi-Family Properties Search
//
//  Created by Kevin Chen on 2/16/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UserDataStore.h"
#import "NSUserDefaultsCategory.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTMHTTPFetcher.h"

@implementation LoginViewController

NSString *kMyClientID = @"147536039573-mc2mlerjtqa17nstdjksk74q73b1upt3.apps.googleusercontent.com";
NSString *kMyClientSecret = @"cRHoOrvmj5vNOsvFvQY82iFa";

NSString *scope = @"profile";


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

- (IBAction)signInWithGoogle:(id)sender {
    GTMOAuth2ViewControllerTouch *viewController;
    viewController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:scope
                                                                clientID:kMyClientID
                                                            clientSecret:kMyClientSecret
                                                        keychainItemName:nil
                                                                delegate:self
                                                        finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    
    [[self navigationController] pushViewController:viewController
                                           animated:YES];
}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error {
    
    UIAlertController * errorMessageController = [UIAlertController alertControllerWithTitle:@"Error" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [errorMessageController addAction:action];
    
    if (error != nil) {
        // Authentication failed
        if ([error code] != kGTMOAuth2ErrorWindowClosed) {
            
            [errorMessageController setMessage:[error localizedDescription]];
            [self presentViewController:errorMessageController animated:YES completion:nil];
            
        }
    } else {
        
        //NSString * path = [NSString stringWithFormat:@"https://www.googleapis.com/plus/v1/people/me?access_token=%@", [auth accessToken]];
        NSString * path = @"https://www.googleapis.com/plus/v1/people/me";
        
        NSURL * url = [NSURL URLWithString:path];
        GTMHTTPFetcher * fetcher = [GTMHTTPFetcher fetcherWithURL:url];
        [fetcher setAuthorizer:auth];
        [self.ActivityIndicatorView startAnimating];
        [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
            [self.ActivityIndicatorView stopAnimating];
            if (error != nil){
                [errorMessageController setMessage:[error localizedDescription]];
                [self presentViewController:errorMessageController animated:YES completion:nil];
                
            }
            else {
                
                NSError * parseError = nil;
                NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];
                if (parseError != nil){
                    [errorMessageController setMessage:[parseError localizedDescription]];
                    [self presentViewController:errorMessageController animated:YES completion:nil];
                }
                else {
                    NSArray * emails = json[@"emails"];
                    NSDictionary * firstEmail =  [emails objectAtIndex:0];
                    
                    User * user = [[User alloc] init];
                    user.userID = firstEmail[@"value"];
                    
                    user.password = @"";
                    
                    NSDictionary * name = json[@"name"];
                    
                    user.FirstName = name[@"givenName"];
                    user.LastName =  name[@"familyName"];
                    [self.ActivityIndicatorView startAnimating];
                    [[UserDataStore getInstance] registerUser:user
                                                      success:^(NSURLSessionDataTask *task) {
                                                          [self.ActivityIndicatorView stopAnimating];
                                                          [AppDelegate showRootController];
                                                          
                                                      }
                                                      failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                          [self.ActivityIndicatorView stopAnimating];
                                                          [errorMessageController setMessage:[error localizedDescription]];
                                                          [self presentViewController:errorMessageController animated:YES completion:nil];
                                                          
                                                      }
                     ];
                }
                
            }
        }];
        
        
    }
}

- (IBAction)signInWithFacebook:(id)sender {
    UIAlertController * messageController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Sign in with Facebook is TBD." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [messageController addAction:action];

    [self presentViewController:messageController animated:YES completion:nil];
}
@end
