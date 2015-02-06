//
//  SearchViewController.m
//  Multi-Family Properties Search
//
//  Created by Kevin Chen on 2/5/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "SearchViewController.h"
#import "Property.h"
#import "PropertyDetailViewController.h"

@interface SearchViewController ()
<MKMapViewDelegate, UISearchBarDelegate>
@end

@implementation SearchViewController

NSMutableArray * properties;

- (void)viewDidLoad {
    [super viewDidLoad];
    [_map setShowsUserLocation:YES];
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = CLLocationCoordinate2DMake(34.05, -118.24);
    mapRegion.span.latitudeDelta = 1;
    mapRegion.span.longitudeDelta = 1;
    
    [_map setRegion:mapRegion animated: YES];
    
    properties = [[NSMutableArray alloc] init];
    
    [properties addObject:[[Property alloc] initWithAddress:@"2000 Riverside Dr Los Angeles 90039" andLocation:CLLocationCoordinate2DMake(34.05, -118.24)]];
    [properties addObject:[[Property alloc] initWithAddress:@"Westside Towers, West - 11845 W. Olympic Blvd" andLocation:CLLocationCoordinate2DMake(34.08, -118.20)]];
    [properties addObject:[[Property alloc] initWithAddress:@"12400 Wilshire Los Angeles, CA" andLocation:CLLocationCoordinate2DMake(34.15, -118.14)]];
    [properties addObject:[[Property alloc] initWithAddress:@"1766 Wilshire Blvd - Landmark II" andLocation:CLLocationCoordinate2DMake(34.0, -118.14)]];
    [properties addObject:[[Property alloc] initWithAddress:@"Gateway LA - 12424 Wilshire Blvd" andLocation:CLLocationCoordinate2DMake(34.05, -118.24)]];
    [properties addObject:[[Property alloc] initWithAddress:@"21800 Oxnard Street, Woodland Hills, CA 91367" andLocation:CLLocationCoordinate2DMake(34.19, -118.04)]];
    [properties addObject:[[Property alloc] initWithAddress:@"G11990 San Vicente Blvd, Los Angeles, CA 90049" andLocation:CLLocationCoordinate2DMake(34.15, -118.0)]];
    
    for (int i=0; i<properties.count; i++) {
        Property* item = [properties objectAtIndex:i];
        
         MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        
        point.coordinate = item.location;
        point.title = item.address;
        
        [_map addAnnotation:point];
    }
    

    
//    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
//    point.coordinate = CLLocationCoordinate2DMake(34.05, -118.24);
//    point.title = @"Where am I?";
//    point.subtitle = @"I'm here!!!";
//    
//    [_map addAnnotation:point];
    
    _map.delegate = self;
    _searchBar.delegate = self;
    
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
                                                                              message:@"Map search filter is under construction!"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
//    
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
//     {
//         textField.placeholder = NSLocalizedString(@"Option 1", @"Login");
//     }];
//    
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
//     {
//         textField.placeholder = NSLocalizedString(@"Option 2", @"Password");
//     }];
    
    
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

#pragma mark Delegate Methods

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        
        NSString * storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"PropertyDetail"];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
    //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Disclosure Pressed" message:@"Click Cancel to Go Back" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    //[alertView show];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
            pinView.image = [UIImage imageNamed:@"small-red-pin.png"];
            pinView.calloutOffset = CGPointMake(0, 32);
            
            // Add a detail disclosure button to the callout.
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            pinView.rightCalloutAccessoryView = rightButton;
            
            // Add an image to the left callout.
            NSString * imageName = [NSString stringWithFormat: @"im%ld.jpg", 1];
            
            UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
            CGRect frame = iconView.frame;
            frame.size.width = 80;
            frame.size.height = 60;
            iconView.frame = frame;
            
            iconView.contentMode = UIViewContentModeScaleAspectFit;
            
            pinView.leftCalloutAccessoryView = iconView;
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    [theSearchBar resignFirstResponder];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:theSearchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        //Error checking
        
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        MKCoordinateRegion region;
        region.center.latitude = placemark.region.center.latitude;
        region.center.longitude = placemark.region.center.longitude;
        MKCoordinateSpan span;
        double radius = placemark.region.radius / 1000; // convert to km
        
        NSLog(@"[searchBarSearchButtonClicked] Radius is %f", radius);
        span.latitudeDelta = radius / 112.0;
        
        region.span = span;
        
        [_map setRegion:region animated:YES];
    }];
}
@end
