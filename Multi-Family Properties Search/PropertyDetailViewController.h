//
//  PropertyDetailViewController.h
//  Multi-Family Properties Search
//
//  Created by Kevin Chen on 2/5/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertyDetailViewController : UIViewController
- (IBAction)contactMe:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *propertyDescription;

@property (weak, nonatomic) IBOutlet UILabel *address;
@property (nonatomic, copy) NSString * MLNumber;
@end
