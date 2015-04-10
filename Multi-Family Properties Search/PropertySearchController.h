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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *listViewBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *currentLocationBarItem;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)swapView:(id)sender;

@property (nonatomic, weak) ContainerViewController *containerViewController;
- (IBAction)zoomToCurrentLocation:(id)sender;

@end
