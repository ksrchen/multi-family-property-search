//
//  ListViewController.m
//  Chrometopia
//
//  Created by kevin chen on 4/10/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "ListViewController.h"
#import "PropertyDataStore.h"
#import "Property.h"
#import "PropertyDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ListViewController ()

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPropertyListing) name:@"PropertyListingUpdated" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadPropertyListing {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([PropertyDataStore getInstance].properties){
        return [[PropertyDataStore getInstance].properties count];
    }else{
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PropertyListingCell" forIndexPath:indexPath];
    
    
    Property *p = [[ PropertyDataStore getInstance].properties objectAtIndex:indexPath.row];
    
    UILabel * addressLabel = (UILabel *)[cell viewWithTag:2];
    addressLabel.text = [p title];
    
    
    UILabel * priceLabel = (UILabel *)[cell viewWithTag:3];
    
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    
    NSNumberFormatter *percentFormatter = [[NSNumberFormatter alloc]init];
    [percentFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    [percentFormatter setMaximumFractionDigits:2];
    
    priceLabel.text = [NSString stringWithFormat:@"Price: %@  ROI: %@",  [currencyFormatter stringFromNumber:p.Price],
                       [p.ROI doubleValue]>0.0?[percentFormatter stringFromNumber:p.ROI] : @"n/a"];
    
    if (![p.MediaURL isKindOfClass:[NSNull class]])
    {
        UIImageView * imageView = (UIImageView *) [cell viewWithTag:4];
        [imageView setImageWithURL:[NSURL URLWithString:p.MediaURL]];
    }
    
    
    
    //[imageView setImage: [UIImage imageNamed:imageName]];
    
    return cell;
    
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    PropertyDetailViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"PropertyDetail"];
    
    Property *p = [[ PropertyDataStore getInstance].properties objectAtIndex:indexPath.row];
    vc.MLNumber = [p MLNumber];
    
    [self.navigationController pushViewController:vc animated:YES];
    
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
