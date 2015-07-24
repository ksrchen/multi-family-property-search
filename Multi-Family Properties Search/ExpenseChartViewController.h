//
//  ExpenseChartViewController.h
//  Chrometopia
//
//  Created by Kevin Chen on 7/23/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
@interface ExpenseChartViewController : UIViewController
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *pieGraphView;
-(void)LoadData:(id)data;
@end
