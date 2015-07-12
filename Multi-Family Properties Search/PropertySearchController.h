//
//  PropertySearchController.h
//  Chrometopia
//
//  Created by kevin chen on 4/10/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContainerViewController.h"

@interface PropertySearchController : UIViewController 
@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *currentLocationBarItem;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, weak) ContainerViewController *containerViewController;
- (IBAction)zoomToCurrentLocation:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *drawBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftFlexBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *hottestPropertiesBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rigthFlexBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *listViewBarItem;

- (IBAction)swapView:(id)sender;
- (IBAction)hottestPropertiesTapped:(id)sender;
- (IBAction)drawTapped:(id)sender;

@end
