//
//  FinancialTableViewController.h
//  Chrometopia
//
//  Created by Kevin Chen on 7/19/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinancialTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *roiLabel;
@property (weak, nonatomic) IBOutlet UILabel *grossScheduledIncomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *netOperatingIncomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *capRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *grossRentMultiplierLabel;

-(void)loadData:(id)data;

@end
