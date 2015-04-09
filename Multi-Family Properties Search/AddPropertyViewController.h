//
//  AddPropertyViewController.h
//  Chrometopia
//
//  Created by kevin chen on 4/9/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPropertyViewController : UITableViewController
@property (weak, nonatomic) NSString *MLSNumber;

- (IBAction)saveButtonTap:(id)sender;
@end
