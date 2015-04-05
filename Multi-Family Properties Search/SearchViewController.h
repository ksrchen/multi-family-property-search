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

@interface SearchViewController : UIViewController <FilterDelegate>
@property (weak, nonatomic) IBOutlet MKMapView * map;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)drawPolygon:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearPolygon;
- (IBAction)clearPolygon:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *clearButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *labelButton;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *listViewBarItem;

@end
