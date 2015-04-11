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


NSString * const  FACEBOOK_PROVIDER = @"Facebook";


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
    
    NSString *kMyClientID = @"147536039573-mc2mlerjtqa17nstdjksk74q73b1upt3.apps.googleusercontent.com";
    NSString *kMyClientSecret = @"cRHoOrvmj5vNOsvFvQY82iFa";
    
    NSString *scope = @"profile";
    
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
        
        NSString * path;
        if ([[auth serviceProvider] compare:FACEBOOK_PROVIDER] == 0) {
            path = @"https://graph.facebook.com/v2.2/me";
        }
        else {
            path = @"https://www.googleapis.com/plus/v1/people/me";
        }
        
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
                    User * user = [[User alloc] init];
                    if ([[auth serviceProvider] compare:FACEBOOK_PROVIDER] == 0) {
                        user.UserID = json[@"email"];
                        user.Password =@"";
                        user.FirstName = json[@"first_name"];
                        user.LastName = json[@"last_name"];
                    }else {
                        NSArray * emails = json[@"emails"];
                        NSDictionary * firstEmail =  [emails objectAtIndex:0];
                        user.UserID = firstEmail[@"value"];
                        user.Password = @"";
                        NSDictionary * name = json[@"name"];
                        user.FirstName = name[@"givenName"];
                        user.LastName =  name[@"familyName"];
                    }
                    [self.ActivityIndicatorView startAnimating];
                    [[UserDataStore getInstance] registerUser:user
                                                      success:^(NSURLSessionDataTask *task) {
                                                          [self.ActivityIndicatorView stopAnimating];
                                                          NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                                                          [defaults saveCustomObject:user key:USER];
                                                          [AppDelegate showRootController];
                                                          
                                                          
                                                      }
                                                      failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                          [self.ActivityIndicatorView stopAnimating];
                                                          NSHTTPURLResponse * response =  (NSHTTPURLResponse*)[task response];
                                                          if ([response statusCode] != 400){
                                                              [errorMessageController setMessage:[error localizedDescription]];
                                                              [self presentViewController:errorMessageController animated:YES completion:nil];
                                                          }else {
                                                              NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                                                              [defaults saveCustomObject:user key:USER];
                                                              [AppDelegate showRootController];
                                                          }
                                                      }
                     ];
                }
                
            }
        }];
        
        
    }
}

- (IBAction)signInWithFacebook:(id)sender {
//    UIAlertController * messageController = [UIAlertController alertControllerWithTitle:@"Info" message:@"Sign in with Facebook is TBD." preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//    [messageController addAction:action];
//
//    [self presentViewController:messageController animated:YES completion:nil];
    
    
    GTMOAuth2Authentication *auth = [self authForFacebook];
    
    // Specify the appropriate scope string, if any, according to the service's API documentation
    auth.scope = @"email";
    
    NSURL *authURL = [NSURL URLWithString:@"https://www.facebook.com/dialog/oauth"];
    
    // Display the authentication view
    GTMOAuth2ViewControllerTouch *viewController;
    viewController = [[GTMOAuth2ViewControllerTouch alloc] initWithAuthentication:auth
                                                                  authorizationURL:authURL
                                                                  keychainItemName:nil
                                                                          delegate:self
                                                                  finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    
    // Now push our sign-in view
    [[self navigationController] pushViewController:viewController animated:YES];
}

- (GTMOAuth2Authentication *)authForFacebook {
    
    NSString *kClientID = @"788979951157117";     // pre-assigned by service
    NSString *kClientSecret = @"f931226287fd004311ae3658e0b71af3"; // pre-assigned by ser
    
    NSURL *tokenURL = [NSURL URLWithString:@"https://graph.facebook.com/oauth/access_token"];
    
    // We'll make up an arbitrary redirectURI.  The controller will watch for
    // the server to redirect the web view to this URI, but this URI will not be
    // loaded, so it need not be for any actual web page.
    NSString *redirectURI = @"http://www.google.com/OAuthCallback";
    
    GTMOAuth2Authentication *auth;
    auth = [GTMOAuth2Authentication authenticationWithServiceProvider:FACEBOOK_PROVIDER
                                                             tokenURL:tokenURL
                                                          redirectURI:redirectURI
                                                             clientID:kClientID
                                                         clientSecret:kClientSecret];
    return auth;
}
@end
