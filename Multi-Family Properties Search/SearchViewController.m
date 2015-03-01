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
#import "PropertyDataStore.h"

@interface SearchViewController ()
<MKMapViewDelegate, UISearchBarDelegate>
{
    UIImageView *drawImage;
    
   // CGPoint location;
    
   // NSDate *lastClick;
    
    BOOL mouseSwiped;
    BOOL polygonDrawMode;
    
    CGPoint lastPoint;
    
    CGPoint currentPoint;
    
    NSMutableArray *latLang;
    
    MKPolygon *polygon;
}
@end

@implementation SearchViewController

NSMutableArray * _properties;

- (void)viewDidLoad {
    [super viewDidLoad];
    CLLocationManager * locationManager = [[CLLocationManager alloc] init];
    [locationManager startUpdatingLocation];
    [locationManager requestAlwaysAuthorization];
    
    [_map setShowsUserLocation:YES];
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = CLLocationCoordinate2DMake(34.05, -118.24);
    mapRegion.span.latitudeDelta = 1;
    mapRegion.span.longitudeDelta = 1;
    
    [_map setRegion:mapRegion animated: YES];
    
    latLang = [[NSMutableArray alloc]init];
    polygonDrawMode = NO;
    mouseSwiped = NO;
    
    _map.delegate = self;
    _searchBar.delegate = self;
    
    [self setTitle:@"Map Search"];
    
//    [self showLogin];
    
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
    if ([annotation isKindOfClass:[Property class]])
    {
        
        NSString * storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        PropertyDetailViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"PropertyDetail"];
        
        Property * p = (Property*)annotation;
        vc.MLNumber = [p MLNumber];
        
        for (id anno in [_map selectedAnnotations]) {
            [_map deselectAnnotation:anno animated:NO];
        }
        
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
    //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Disclosure Pressed" message:@"Click Cancel to Go Back" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    //[alertView show];
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    double yc = _map.region.center.latitude;
    double xc = _map.region.center.longitude;
    
    double y = _map.region.span.latitudeDelta/2;
    double x = _map.region.span.longitudeDelta/2;
    
    CLLocationCoordinate2D topLeft = CLLocationCoordinate2DMake(yc-y, xc-x);
    CLLocationCoordinate2D topRight = CLLocationCoordinate2DMake(yc-y, xc+x);
    CLLocationCoordinate2D bottomRight = CLLocationCoordinate2DMake(yc+y, xc+x);
    CLLocationCoordinate2D bottomLeft = CLLocationCoordinate2DMake(yc+y, xc-x);

    CLLocationCoordinate2D points[5];
    points[0] = topLeft;
    points[1] = topRight;
    points[2] = bottomRight;
    points[3] = bottomLeft;
    points[4] = topLeft;
    NSMutableString * polygon = [NSMutableString stringWithString:@"POLYGON(("];
    for (int i=0; i<5; i++) {
        [polygon appendFormat:@"%f %f, ", points[i].longitude, points[i].latitude];
    }
    long len = [polygon length];
    [polygon deleteCharactersInRange:NSMakeRange(len-2, 2)];
    [polygon appendString:@"))"];
    
    [[PropertyDataStore getInstance] getPropertiesForRegion:polygon withFilters:nil
                                                    success:^(NSURLSessionDataTask *task, NSMutableArray *properties) {
                                                        if (_properties)
                                                        {
                                                            [_map removeAnnotations:_properties];
                                                        }
                                                        
                                                        _properties = properties;
                                                        [_map addAnnotations:_properties];
                                                        
                                                    }
                                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                        
                                                    }
     ];
    
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[Property class]])
    {
        // Try to dequeue an existing pin view first.
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
            pinView.image = [UIImage imageNamed:@"map_pin.png"];
            pinView.calloutOffset = CGPointMake(0, 0);
            
            // Add a detail disclosure button to the callout.
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton setFrame:CGRectMake(0, 0, CGRectGetWidth(rightButton.frame)+10, CGRectGetHeight(rightButton.frame))];
            [rightButton setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];
            pinView.rightCalloutAccessoryView = rightButton;
            
            // Add an image to the left callout.
            NSString * imageName = [NSString stringWithFormat: @"im%ld.jpg", 1l];
            
            UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
            CGRect frame = iconView.frame;
            frame.size.width = 80;
            frame.size.height = 60;
            iconView.frame = frame;
            
            iconView.contentMode = UIViewContentModeScaleAspectFit;
            
            //pinView.leftCalloutAccessoryView = iconView;
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
        if (placemarks.count > 0){
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            MKCoordinateRegion region;
            region.center.latitude = placemark.region.center.latitude;
            region.center.longitude = placemark.region.center.longitude;
            MKCoordinateSpan span;
            double radius = placemark.region.radius / 1000; // convert to km
            
            // NSLog(@"[searchBarSearchButtonClicked] Radius is %f", radius);
            span.latitudeDelta = radius / 112.0;
            
            region.span = span;
            
            [_map setRegion:region animated:YES];
        }
    }];
}

- (void) showLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Multi-Family Listing Search"
                                                                              message:@"Please Sign In"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"Login", @"Login");
     }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"Password", @"Password");
         textField.secureTextEntry = YES;
     }];
    
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDestructive
                               handler:^(UIAlertAction *action)
                               {
                                   UITextField *login = alertController.textFields.firstObject;
                                   UITextField *password = alertController.textFields.lastObject;
                                   NSString * pwd = password.text;
                                   NSString * user = login.text;
                                   if ([pwd length] > 1 && [user length] > 1 && [pwd compare:@"42"] == NSOrderedSame){
                                       [defaults setObject:user forKey:@"loggedin"];
                                       [defaults synchronize];
                                   }
                                   else{
                                       [defaults removeObjectForKey:@"loggedin"];
                                       [defaults synchronize];
                                       [alertController setMessage:@"Login failed. Please try again."];
                                       [self presentViewController:alertController animated:YES completion:nil];
                                   }
                                   
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

- (IBAction)drawPolygon:(id)sender {
    [self.map setUserInteractionEnabled:NO];
    drawImage = [[UIImageView alloc] initWithImage:nil];
    
    drawImage.frame = CGRectMake(0, 0, self.map.frame.size.width, self.map.frame.size.height);
    
    [self.map addSubview:drawImage];
    
    drawImage.backgroundColor = [UIColor clearColor];
    [latLang removeAllObjects];
    polygonDrawMode = YES;
    mouseSwiped = NO;
}
- (IBAction)clearPolygon:(id)sender {
    if (polygon){
        [self.map removeOverlay:polygon];
    }
    polygon = nil;
    
    [self.map setUserInteractionEnabled:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!polygonDrawMode) {
        return;
    }
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if ([touch tapCount] == 2) {
        
        drawImage.image = nil;
        
    }
    
    //location = [touch locationInView:self.map];
    
    //lastClick = [NSDate date];
    
    lastPoint = [touch locationInView:self.map];
    
    //lastPoint.y -= 0;
    
    mouseSwiped = YES;
    
    [super touchesBegan: touches withEvent: event];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!polygonDrawMode) {
        return;
    }
    if (mouseSwiped) {
        UITouch *touch = [touches anyObject];
        
        currentPoint = [touch locationInView:self.view];
        
        UIGraphicsBeginImageContext(CGSizeMake(self.map.frame.size.width, self.map.frame.size.height));
        
        [drawImage.image drawInRect:CGRectMake(0, 0, self.map.frame.size.width, self.map.frame.size.height)];
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0);
        
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0, 1, 0, 1);
        
        CGContextBeginPath(UIGraphicsGetCurrentContext());
        
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        
        [drawImage setFrame:CGRectMake(0, 0, self.map.frame.size.width, self.map.frame.size.height)];
        
        drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        //converting points to latitude and longitude
        
        
        
        NSLog(@"CurrentPoint:%@", NSStringFromCGPoint(currentPoint));
        
        CLLocationCoordinate2D centerOfMapCoord = [self.map convertPoint:currentPoint toCoordinateFromView:self.map]; //Step 2
        
        CLLocation *towerLocation = [[CLLocation alloc] initWithLatitude:centerOfMapCoord.latitude longitude:centerOfMapCoord.longitude];
        
        [latLang addObject:towerLocation];
        
    }
    
    lastPoint = currentPoint;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!polygonDrawMode) {
        return;
    }
    
    [drawImage removeFromSuperview];
    if ([latLang count] > 0){
        
        
        CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * [latLang count]);
        
        for(int idx = 0; idx < [latLang count]; idx++) {
            
            CLLocation* locationCL = [latLang objectAtIndex:idx];
            
            coords[idx] = CLLocationCoordinate2DMake(locationCL.coordinate.latitude,locationCL.coordinate.longitude);
            
        }
        
        polygon = [MKPolygon polygonWithCoordinates:coords count:[latLang count]];
        
        free(coords);
        
        [self.map addOverlay:polygon];
        [latLang removeAllObjects];
        [self.map setVisibleMapRect:[polygon boundingMapRect] edgePadding:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0) animated:YES];
    }
    
    polygonDrawMode = NO;
    
}
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id )overlay

{
    
    MKPolygonView *polygonView = [[MKPolygonView alloc] initWithPolygon:overlay];
    
    polygonView.lineWidth = 5;
    
    polygonView.strokeColor = [UIColor redColor];
    
    polygonView.fillColor = [UIColor colorWithRed:0 green:191 blue:255 alpha:0.5];
    
    mapView.userInteractionEnabled = YES;
    
    return polygonView;
    
}


@end
