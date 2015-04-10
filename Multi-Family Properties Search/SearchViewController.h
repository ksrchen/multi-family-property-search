//
//  SearchViewController.h
//  Multi-Family Properties Search
//
//  Created by Kevin Chen on 2/5/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "FilterDelegate.h"

@interface SearchViewController : UIViewController <FilterDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet MKMapView * map;
- (IBAction)drawPolygon:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearPolygon;
- (IBAction)clearPolygon:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *labelButton;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

- (IBAction)zoomToCurrentLocation:(id)sender;
- (void) ApplyFilter: (NSString *) filters;
- (void) ClearFilter;
@end
