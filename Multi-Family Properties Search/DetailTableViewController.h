//
//  DetailTableViewController.h
//  Chrometopia
//
//  Created by Kevin Chen on 7/19/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *unitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *countyLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *lotSizeLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberOfElectricMetersLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfGasMetersLabel;

@property (weak, nonatomic) IBOutlet UILabel *mlsNumber;

@property (weak, nonatomic) IBOutlet UILabel *yearBuilt;
-(void)loadData:(id)data;
@end
