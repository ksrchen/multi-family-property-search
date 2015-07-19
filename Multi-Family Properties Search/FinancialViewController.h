//
//  FinancialViewController.h
//  Chrometopia
//
//  Created by Kevin Chen on 7/19/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface FinancialViewController : UIViewController
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *pieGraphView;
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *lineGraphView;

-(void)LoadData:(id)data;
@end
