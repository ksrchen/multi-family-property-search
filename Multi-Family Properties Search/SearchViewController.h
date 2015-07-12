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
@property (nonatomic) BOOL InPolygonMode;
@property (weak, nonatomic) IBOutlet MKMapView * map;

- (IBAction)zoomToCurrentLocation:(id)sender;
- (void) ApplyFilter: (NSString *) filters;
- (void) ClearFilter;


- (void)drawPolygon;
- (void)clearPolygon;

@end
