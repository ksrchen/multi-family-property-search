//
//  SearchViewController.m
//  Multi-Family Properties Search
//
//  Created by Kevin Chen on 2/5/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()
<MKMapViewDelegate>
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_map setShowsUserLocation:YES];
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = CLLocationCoordinate2DMake(34.05, -118.24);
    mapRegion.span.latitudeDelta = 0.5;
    mapRegion.span.longitudeDelta = 0.5;
    
    [_map setRegion:mapRegion animated: YES];
    
    _map.delegate = self;
    [self setTitle:@"Map Search"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onFilter:(id)sender {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Map Search"
                                                                              message:@"Select your options"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"Option 1", @"Login");
     }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"Option 2", @"Password");
     }];
    
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDestructive
                               handler:^(UIAlertAction *action)
                               {
                                   
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

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
   
}
@end
