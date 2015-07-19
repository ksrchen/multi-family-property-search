//
//  AnnotationCalloutViewController.m
//  Chrometopia
//
//  Created by Kevin Chen on 7/18/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "AnnotationCalloutViewController.h"
#import "UIImageView+AFNetworking.h"

@interface AnnotationCalloutViewController () {
    UITapGestureRecognizer *_tapGestureRecognizer;
}

@end

@implementation AnnotationCalloutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.addressLabel.text = [self.Property title];
    
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    
    NSNumberFormatter *percentFormatter = [[NSNumberFormatter alloc]init];
    [percentFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    [percentFormatter setMaximumFractionDigits:2];
    
    self.priceLabel.text = [NSString stringWithFormat:@"Price: %@",  [currencyFormatter stringFromNumber:self.Property.Price]];
    self.roiLabel.text = [NSString stringWithFormat:@"ROI: %@", [self.Property.ROI doubleValue]>0.0?[percentFormatter stringFromNumber:self.Property.ROI] : @"n/a"];
    
    if (![self.Property.MediaURL isKindOfClass:[NSNull class]])
    {
        [self.imageView setImageWithURL:[NSURL URLWithString:self.Property.MediaURL]];
    }
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:_tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewTapped:(id) sender
{
    [self.delegate viewDidTapped:self.Property];
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
