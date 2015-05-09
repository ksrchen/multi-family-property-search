//
//  PropertyDetailViewController.h
//  Multi-Family Properties Search
//
//  Created by Kevin Chen on 2/5/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "KIImagePager.h"
#import <MessageUI/MessageUI.h>

@interface PropertyDetailViewController : UIViewController<CPTPlotDataSource, UIScrollViewDelegate, KIImagePagerDataSource, MFMailComposeViewControllerDelegate>
- (IBAction)contactMe:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *propertyDescription;
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *pieGraphView;

@property (weak, nonatomic) IBOutlet CPTGraphHostingView *lineGraphView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *profileHeader;
@property (weak, nonatomic) IBOutlet UILabel *priceDisplay;

@property (weak, nonatomic) IBOutlet UILabel *address;
@property (nonatomic, copy) NSString * MLNumber;
@property (weak, nonatomic) IBOutlet KIImagePager *ImagePager;
@property (weak, nonatomic) IBOutlet UILabel *listingAgentName;
@property (weak, nonatomic) IBOutlet UILabel *listingOffice;
@end
