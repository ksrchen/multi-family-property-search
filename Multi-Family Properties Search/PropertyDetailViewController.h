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

@interface PropertyDetailViewController : UIViewController<UIScrollViewDelegate, KIImagePagerDataSource, MFMailComposeViewControllerDelegate>
- (IBAction)contactMe:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *propertyDescription;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *profileHeader;
@property (weak, nonatomic) IBOutlet UILabel *priceDisplay;

@property (weak, nonatomic) IBOutlet UILabel *address;
@property (nonatomic, copy) NSString * MLNumber;
@property (weak, nonatomic) IBOutlet KIImagePager *ImagePager;
@property (weak, nonatomic) IBOutlet UILabel *listingAgentName;
@property (weak, nonatomic) IBOutlet UILabel *listingOffice;
@property (weak, nonatomic) IBOutlet UIButton *descriptionMoreButton;
@property (weak, nonatomic) IBOutlet UILabel *roiLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfUnitsLabel;

- (IBAction)moreDescriptionTapped:(id)sender;
+(instancetype)GetController;

@property (weak, nonatomic) IBOutlet UIView *finanicalSectionBody;
@property (weak, nonatomic) IBOutlet UIView *detailSectionBody;

@end
