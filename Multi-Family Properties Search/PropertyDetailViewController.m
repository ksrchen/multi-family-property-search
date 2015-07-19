//
//  PropertyDetailViewController.m
//  Multi-Family Properties Search
//
//  Created by Kevin Chen on 2/5/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "PropertyDetailViewController.h"
#import "PropertyDataStore.h"
#import "Expense.h"
#import "User.h"
#import "UserDataStore.h"
#import "PropertyDataStore.h"
#import <MessageUI/MessageUI.h>
#import "FinancialViewController.h"
#import "DetailTableViewController.h"

@implementation PropertyDetailViewController  {
    NSArray *_images;
    FinancialViewController *_financialView;
    DetailTableViewController *_detailview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadFinancialView];
    [self loadDetailView];
    
    [self setTitle:@"Property Profile"];
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 6.0;
    self.scrollView.delegate = self;
    
    if ([self.MLNumber length] > 0){
        [[PropertyDataStore getInstance] getProperty:self.MLNumber success:^(NSURLSessionDataTask *task, id property) {
            
             dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary * attributes = (NSDictionary*) property;
            self.propertyDescription.text = attributes[@"PropertyDescription"];
            self.address.text = [NSString stringWithFormat:@"%@ %@ %@, %@ %@",
                                 attributes[@"StreetNumber"],
                                 attributes[@"StreetName"],
                                 attributes[@"City"],
                                 attributes[@"State"],
                                 attributes[@"PostalCode"]
                                 ];
            
            _images = (NSArray*)attributes[@"MediaURLs"];
            
            NSNumber *price = attributes[@"ListPrice"];
            NSNumber *roi = attributes[@"ROI"];
            
            self.ImagePager.dataSource = self;
            [self.ImagePager reloadData];
            
            NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
            [currencyFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
            
            
            NSNumberFormatter *percentFormatter = [[NSNumberFormatter alloc]init];
            [percentFormatter setNumberStyle:NSNumberFormatterPercentStyle];
            [percentFormatter setMaximumFractionDigits:2];
            
            
            self.profileHeader.text = [NSString stringWithFormat:@"MLS#: %@ ", self.MLNumber];
            
            self.priceDisplay.text = [NSString stringWithFormat:@"Price: %@  ROI: %@",  [currencyFormatter stringFromNumber:price],
                                      [roi doubleValue]>0.0?[percentFormatter stringFromNumber:roi] : @"n/a"];
            
            self.listingAgentName.text = [NSString stringWithFormat:@"%@ %@", attributes[@"ListingAgentFirstName"], attributes[@"ListingAgentLastName"]];
            self.listingOffice.text = attributes[@"ListingOffice"];
            
             [_financialView LoadData:property];
                 [_detailview loadData:property];
             });
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }
         ];
    }
}

-(void)loadFinancialView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PropertyDetails" bundle:nil];
    _financialView = (FinancialViewController *)[storyboard instantiateViewControllerWithIdentifier:@"FinancialView"];
    
    [self addChildViewController:_financialView];
    [self.finanicalSectionBody addSubview:_financialView.view];
    
    UIView *childView = _financialView.view;
    [childView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(childView);
    NSArray *constraintV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[childView]-|"
                                                                   options:0 metrics:nil views:viewsDictionary];
    NSArray *constraintH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[childView]-0-|"
                                                                   options:0 metrics:nil views:viewsDictionary];
    
    [self.finanicalSectionBody addConstraints:constraintV];
    [self.finanicalSectionBody addConstraints:constraintH];
    
    [_financialView didMoveToParentViewController:self];

}

-(void)loadDetailView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PropertyDetails" bundle:nil];
    _detailview = (DetailTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DetailViewSectionBody"];
    
    [self addChildViewController:_detailview];
    [self.detailSectionBody addSubview:_detailview.view];
    
    UIView *childView = _detailview.view;
    [childView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(childView);
    NSArray *constraintV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[childView]-|"
                                                                   options:0 metrics:nil views:viewsDictionary];
    NSArray *constraintH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[childView]-0-|"
                                                                   options:0 metrics:nil views:viewsDictionary];
    
    [self.detailSectionBody addConstraints:constraintV];
    [self.detailSectionBody addConstraints:constraintH];
    
    [_detailview didMoveToParentViewController:self];
    
}


- (IBAction)moreDescriptionTapped:(id)sender {
    [self.propertyDescription setNumberOfLines:0];
}

+(instancetype)GetController
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"PropertyDetails" bundle:nil];
    return [storyBoard instantiateViewControllerWithIdentifier:@"PropertyDetailView"];
}

- (IBAction)contactMe:(id)sender {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil
                                                                              message:nil
                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    
    
    UIAlertAction *sendEmailAction = [UIAlertAction
                                        actionWithTitle:NSLocalizedString(@"Email", @"Email Action")
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction *action)
                                        {                                            
                                            NSString* body = [NSString stringWithFormat: @"http://kmlservice.azurewebsites.net/PropertyProfile?id=%@", self.MLNumber];
                                            NSArray *data = @[body];
                                            
                                            UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:data applicationActivities:nil];
                                            
                                            [self presentViewController:vc animated:YES completion:nil];
                                            
                                        }];
    
    
    UIAlertAction *addToMylistAction = [UIAlertAction
                                        actionWithTitle:NSLocalizedString(@"Add to My Properties", @"Cancel action")
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction *action)
                                        {
                                            User* user = [[UserDataStore getInstance] getUser];
                                            PropertyDataStore * propertyDataStore = [PropertyDataStore getInstance];
                                            [propertyDataStore addMyListingForUser:user.UserID
                                                                      withMLNumber:[self MLNumber]
                                                                           success:^(NSURLSessionDataTask *task, id property) {
                                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"MyListingUpdated" object:self];
                                                                               });
                                                                               
                                                                           }
                                                                           failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                               
                                                                           }];
                                            
                                        }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                       
                                   }];
    
    
    [alertController addAction:sendEmailAction];
    //[alertController addAction:placeOfferAction];
    [alertController addAction:addToMylistAction];
    //[alertController addAction:addContactSalesAction];
    [alertController addAction:cancelAction];
    
    [[alertController popoverPresentationController] setBarButtonItem:sender];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.contentView;
}

- (NSArray *) arrayWithImages {
    return _images;
}
- (UIViewContentMode) contentModeForImage:(NSUInteger)image {
    return UIViewContentModeScaleToFill;
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
