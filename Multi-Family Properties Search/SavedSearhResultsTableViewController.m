//
//  SavedSearhResultsTableViewController.m
//  Chrometopia
//
//  Created by Kevin Chen on 7/12/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "SavedSearhResultsTableViewController.h"
#import "Property.h"
#import "PropertyDetailViewController.h"
#import "PropertyDataStore.h"
#import "User.h"
#import "UserDataStore.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "AddPropertyViewController.h"
#import "UIImageView+AFNetworking.h"

@interface SavedSearhResultsTableViewController ()
{
    NSMutableArray * _properties;
}

@end

@implementation SavedSearhResultsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    [self setupLeftMenuButton];
    [self setTitle:@"Saved Search Results"];
    [self reloadMyListing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMyListing) name:@"MyListingUpdated" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)setupLeftMenuButton {
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItems:@[leftDrawerButton]];
}


#pragma mark - Table view data source

-(void)reloadMyListing{
    User * user = [[UserDataStore getInstance] getUser];
    
    [[PropertyDataStore getInstance] getMyListingForUser:  user.UserID
                                                 success:^(NSURLSessionDataTask *task, NSMutableArray *properties) {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         _properties = properties;
                                                         [self.tableView reloadData];
                                                         //                                                         NSUInteger count = [_properties count];
                                                         //                                                         if (count>0){
                                                         //                                                             [[self navigationController] tabBarItem].badgeValue = [NSString stringWithFormat:@"%lu", (unsigned long)count];
                                                         //                                                         }else{
                                                         //                                                             [[self navigationController] tabBarItem].badgeValue = nil;
                                                         //                                                         }
                                                     });
                                                     
                                                 }
                                                 failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                     
                                                 }];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_properties count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyListingCell" forIndexPath:indexPath];
    
    
    Property * p = [_properties objectAtIndex:indexPath.row];
    
    UILabel * addressLabel = (UILabel *)[cell viewWithTag:2];
    addressLabel.text = [p title];
    
    
    UILabel * priceLabel = (UILabel *)[cell viewWithTag:3];
    
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    
    NSNumber *price = [NSNumber numberWithDouble:350000.0];
    priceLabel.text = [NSString stringWithFormat:@"Price: %@  ROI: %.2f%%",  [currencyFormatter stringFromNumber:price], 25.0];
    
    if (![p.MediaURL isKindOfClass:[NSNull class]])
    {
        UIImageView * imageView = (UIImageView *) [cell viewWithTag:4];
        [imageView setImageWithURL:[NSURL URLWithString:p.MediaURL]];
    }
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        User* user = [[UserDataStore getInstance] getUser];
        
        Property * p = [_properties objectAtIndex:indexPath.row];
        PropertyDataStore * propertyDataStore = [PropertyDataStore getInstance];
        
        [propertyDataStore removeMyListingForUser:user.UserID withMLNumber:p.MLNumber success:^(NSURLSessionDataTask *task, id property) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MyListingUpdated" object:self];
                [self reloadMyListing];
            });
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
        [_properties removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
