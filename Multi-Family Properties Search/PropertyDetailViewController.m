//
//  PropertyDetailViewController.m
//  Multi-Family Properties Search
//
//  Created by Kevin Chen on 2/5/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "PropertyDetailViewController.h"
#import "PropertyDataStore.h"

@implementation PropertyDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.MLNumber length] > 0){
        [[PropertyDataStore getInstance] getProperty:self.MLNumber success:^(NSURLSessionDataTask *task, id property) {
            
            NSDictionary * attributes = (NSDictionary*) property;
            self.propertyDescription.text = attributes[@"PropertyDescription"];
            self.address.text = [NSString stringWithFormat:@"%@ %@ %@, %@ %@",
                                 attributes[@"StreetNumber"],
                                 attributes[@"StreetName"],
                                 attributes[@"City"],
                                 attributes[@"State"],
                                 attributes[@"PostalCode"]
                                 ];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }
        ];
    }
}

- (IBAction)contactMe:(id)sender {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Property Detail"
                                                                              message:@"Enter your comment and tap Send"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    
       [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
        {
            
                     textField.placeholder = NSLocalizedString(@"comment", @"Login");
         }];
    
    
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Send", @"OK action")
                               style:UIAlertActionStyleDestructive
                               handler:^(UIAlertAction *action)
                               {
                                   UIAlertController * confirmController = [UIAlertController alertControllerWithTitle:@"Property Detail"
                                                                                                             message:@"Comment sent!"
                                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                                   
                                   UIAlertAction *closeAction = [UIAlertAction
                                                                 actionWithTitle:NSLocalizedString(@"OK", @"Cancel action")
                                                                 style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction *action)
                                                                 {
                                                                     
                                                                     
                                                                 }];
                                   [confirmController addAction:closeAction];

                                   [self presentViewController:confirmController animated:YES completion:nil];
                                   
                               }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                       
                                   }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

}
@end
