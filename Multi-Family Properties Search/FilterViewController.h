//
//  FilterViewController.h
//  Multi-Family Properties Search
//
//  Created by kevin chen on 3/3/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterDelegate.h"

@interface FilterViewController : UIViewController
- (IBAction)close:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *LotSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *GrossOperatingIncomeLabel;
@property (weak, nonatomic) IBOutlet UISlider *LotSizeSlider;
@property (weak, nonatomic) IBOutlet UISlider *GrossOperatingIncomeSlider;

@property (weak, nonatomic) id<FilterDelegate> delegate;

- (IBAction)Apply:(id)sender;
- (IBAction)Clear:(id)sender;

- (IBAction)LotSizeChanged:(id)sender;
- (IBAction)GrossOperatingIncomeChanged:(id)sender;

@end
