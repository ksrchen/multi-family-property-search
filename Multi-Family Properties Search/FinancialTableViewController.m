//
//  FinancialTableViewController.m
//  Chrometopia
//
//  Created by Kevin Chen on 7/19/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "FinancialTableViewController.h"

@interface FinancialTableViewController ()

@end

@implementation FinancialTableViewController

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
    
    NSNumberFormatter *percentFormatter = [[NSNumberFormatter alloc]init];
    [percentFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    [percentFormatter setMaximumFractionDigits:2];
    
    NSNumberFormatter *rateFormatter = [[NSNumberFormatter alloc]init];
    [rateFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [rateFormatter setMaximumFractionDigits:2];
    
    NSNumber *roi = attributes[@"ROI"];
    self.roiLabel.text = [NSString stringWithFormat:@"%@", [roi doubleValue]>0.0?[percentFormatter stringFromNumber:roi] : @"n/a"];
    
    NSNumber *grossScheduledIncome = attributes[@"GrossIncome"];
    self.grossScheduledIncomeLabel.text = [currencyFormatter stringFromNumber:grossScheduledIncome];
    
    NSNumber *netOperatingIncome = attributes[@"NetOperatingIncome"];
    self.netOperatingIncomeLabel.text = [currencyFormatter stringFromNumber:netOperatingIncome];

    NSNumber *capRate = attributes[@"CapRate"];
    self.capRateLabel.text = [rateFormatter stringFromNumber:capRate];
    
    NSNumber *grossRentMultiplier = attributes[@"GrossMultiplier"];
    self.grossRentMultiplierLabel.text = [rateFormatter stringFromNumber:grossRentMultiplier];


}
@end
