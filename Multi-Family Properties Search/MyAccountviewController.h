//
//  MyAccountviewController.h
//  Multi-Family Properties Search
//
//  Created by Kevin Chen on 2/5/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAccountviewController : UITableViewController
- (IBAction)signOut:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *UserID;
@property (weak, nonatomic) IBOutlet UITextField *FirstName;
@property (weak, nonatomic) IBOutlet UITextField *Lastname;

@end
