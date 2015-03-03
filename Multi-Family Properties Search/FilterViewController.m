//
//  FilterViewController.m
//  Multi-Family Properties Search
//
//  Created by kevin chen on 3/3/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults * userDefault = [[NSUserDefaults alloc] init];
    float lotSize = [userDefault floatForKey:@"LotSize"];
    float grossOperatingIncome = [userDefault floatForKey:@"GrossOperatingIncome"];
    
    self.LotSizeSlider.value = lotSize;
    self.GrossOperatingIncomeSlider.value = grossOperatingIncome;
    
    [self LotSizeChanged:nil];
    [self GrossOperatingIncomeChanged:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)close:(id)sender {
    [self  dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)Apply:(id)sender {
    NSUserDefaults * userDefault = [[NSUserDefaults alloc] init];
    [userDefault setFloat:[self.LotSizeSlider value] forKey:@"LotSize"];
    [userDefault setFloat:[self.GrossOperatingIncomeSlider value] forKey:@"GrossOperatingIncome"];
    
    NSString * filters = [NSString stringWithFormat:@"LotSquareFootage > %.f AND GrossOperatingIncome > %.f", [self.LotSizeSlider value],  [self.GrossOperatingIncomeSlider value]];
    [self  dismissViewControllerAnimated:YES completion:nil];
    [self.delegate ApplyFilter:filters];
}

- (IBAction)Clear:(id)sender {
    [self  dismissViewControllerAnimated:YES completion:nil];
    [self.delegate ClearFilter];
}

- (IBAction)LotSizeChanged:(id)sender {
    
    self.LotSizeLabel.text  = [NSString stringWithFormat:@"Lot Size > %.f Square Feet", [self.LotSizeSlider value]];
}

- (IBAction)GrossOperatingIncomeChanged:(id)sender {
    self.GrossOperatingIncomeLabel.text  = [NSString stringWithFormat:@"Gross Operating Income > $%.f", [self.GrossOperatingIncomeSlider value]];
    
}
@end
