//
//  MyListingViewController.m
//  Multi-Family Properties Search
//
//  Created by Kevin Chen on 2/5/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "MyListingViewController.h"
#import "Property.h"
#import "PropertyDetailViewController.h"
#import "PropertyDataStore.h"
#import "User.h"
#import "UserDataStore.h"

@interface MyListingViewController ()
{
    NSMutableArray * _properties;
}

@end

@implementation MyListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setTitle:@"My Listings"];
    
    [self reloadMyListing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMyListing) name:@"MyListingUpdated" object:nil];

}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    long i = indexPath.row + 1;
    UILabel * label = (UILabel *)[cell viewWithTag:2];
    
    Property * p = [_properties objectAtIndex:indexPath.row];
    
    label.text = [p title];
    
    
    UIImageView * imageView = (UIImageView *) [cell viewWithTag:4];
    //NSString * imageName = [NSString stringWithFormat: @"im%ld.jpg", i];
    NSString * imageName = @"pic..png";
    
    [imageView setImage: [UIImage imageNamed:imageName]];
    
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
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Property * p = [_properties objectAtIndex:indexPath.row];
    
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    PropertyDetailViewController  * vc = [storyboard instantiateViewControllerWithIdentifier:@"PropertyDetail"];
    vc.MLNumber = p.MLNumber;
    [self.navigationController pushViewController:vc animated:YES];

}

@end
