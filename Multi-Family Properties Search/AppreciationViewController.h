//
//  AppreciationViewController.h
//  Chrometopia
//
//  Created by Kevin Chen on 7/25/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "PagedViewController.h"
@interface AppreciationViewController : PagedViewController
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *GraphView;
@end

