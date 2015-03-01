//
//  SearchViewController.h
//  Multi-Family Properties Search
//
//  Created by Kevin Chen on 2/5/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface SearchViewController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView * map;
- (IBAction)onFilter:(id)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)drawPolygon:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearPolygon;
- (IBAction)clearPolygon:(id)sender;

@end
