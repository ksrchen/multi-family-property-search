//
//  LoginViewController.h
//  Multi-Family Properties Search
//
//  Created by Kevin Chen on 2/16/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)signIn:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *ActivityIndicatorView;

- (IBAction)signInWithGoogle:(id)sender;
- (IBAction)signInWithFacebook:(id)sender;

@end
