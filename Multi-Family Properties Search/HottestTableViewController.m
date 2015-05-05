//
//  HottestTableViewController.m
//  Multi-Family Properties Search
//
//  Created by Kevin Chen on 2/5/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "HottestTableViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "PropertyDataStore.h"
#import "Property.h"
#import "UIImageView+AFNetworking.h"
#import "PropertyDetailViewController.h"

@interface HottestTableViewController ()
{
    
    NSArray * _properties;
}

@end

@implementation HottestTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [super viewDidLoad];
    
    [self setTitle:@"Hottest Properties"];
    
    [self setupLeftMenuButton];
    [[PropertyDataStore getInstance] getHottestProperties:^(NSURLSessionDataTask *task, NSMutableArray *properties) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _properties = properties;
            [self.tableView reloadData];
        });
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

- (void)setupLeftMenuButton {
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
}

- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Property *p = [_properties objectAtIndex:indexPath.row];
    
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
    Property *p = [_properties objectAtIndex:indexPath.row];
    
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    PropertyDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"PropertyDetail"];
    vc.MLNumber = p.MLNumber;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
