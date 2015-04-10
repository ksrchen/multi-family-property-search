//
//  PropertySearchController.m
//  Chrometopia
//
//  Created by kevin chen on 4/10/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "PropertySearchController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "FilterViewController.h"

@interface PropertySearchController ()
{
    CLLocationManager *locationManager;
}

@end

@implementation PropertySearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    locationManager = [[CLLocationManager alloc] init];
    [locationManager startUpdatingLocation];
    [locationManager requestAlwaysAuthorization];

    
    [self setupLeftMenuButton];
    
    [self.navigationItem setTitleView:self.searchBar];
    [self.navigationItem setRightBarButtonItems:@[ self.filterBarItem, self.currentLocationBarItem]];
    self.searchBar.delegate = self.containerViewController.mapViewController;

}

- (void)setupLeftMenuButton {
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItems:@[leftDrawerButton, self.listViewBarItem]];
}

- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"embedContainer"]) {
        self.containerViewController = segue.destinationViewController;
    }else if ([[segue identifier] isEqualToString:@"FilterViewSeque"]) {
        FilterViewController *vc = [segue destinationViewController];
        vc.delegate = self.containerViewController.mapViewController;
    }

}

- (IBAction)swapView:(id)sender {
    [self.containerViewController swapViewControllers];
     UIBarButtonItem *item = sender;
    if ([self.containerViewController.currentSegueIdentifier isEqualToString:SegueIdentifierMap]){
        item.title = @"List";
    }else{
        item.title = @"Map";
    }
}
- (IBAction)zoomToCurrentLocation:(id)sender {
    [self.searchBar resignFirstResponder];
    self.searchBar.text = nil;

    [self.containerViewController.mapViewController zoomToCurrentLocation:nil];
}
@end
