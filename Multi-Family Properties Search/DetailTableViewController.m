//
//  DetailTableViewController.m
//  Chrometopia
//
//  Created by Kevin Chen on 7/19/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "DetailTableViewController.h"

@interface DetailTableViewController ()

@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData:(id)data
{
    NSDictionary * attributes = (NSDictionary*) data;
    
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];

    NSNumber *price = attributes[@"ListPrice"];
    self.priceLabel.text = [currencyFormatter stringFromNumber:price];
    
    NSNumber *numberOfUnits = attributes[@"NumberOfUnits"];
    self.unitsLabel.text = [NSString stringWithFormat:@"%@", numberOfUnits];

    self.cityLabel.text = attributes[@"City"];
    self.mlsNumber.text = attributes[@"MLnumber"];
    
}
@end
