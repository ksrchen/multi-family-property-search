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

@implementation PropertyDetailViewController  {
    
    NSArray * _expenses;
    NSArray *_images;
    
    NSNumber *_income;
    NSNumber *_expense;
    
    CPTPieChart *_pieChart;
    CPTBarPlot *_incomePlot;
    CPTBarPlot *_expensePlot;
    CPTXYPlotSpace *_barGraphPlotSpace;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    _expenses = [[NSArray alloc] init];
    
    
    [self setTitle:@"Property Profile"];
    
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 6.0;
    self.scrollView.delegate = self;
    
    [self createExpenseChart];
    [self createIncomeVsExpenseChart];
    
    if ([self.MLNumber length] > 0){
        [[PropertyDataStore getInstance] getProperty:self.MLNumber success:^(NSURLSessionDataTask *task, id property) {
            
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
            
            NSNumber *mortage = attributes[@"Mortage"];
            NSNumber *propertyTax = attributes[@"PropertyTax"];
            NSNumber *propertyManagement = attributes[@"PropertyManagement"];
            NSNumber *insurance = attributes[@"Insurance"];
            //NSNumber *utilityWater = attributes[@"UtilityWater"];
            
            _expenses = [[NSArray alloc]
                         initWithObjects:[[Expense alloc] initWithExpenseType:@"Mortgage" andAmount:mortage],
                         [[Expense alloc] initWithExpenseType:@"Prop Tax" andAmount:propertyTax],
                         [[Expense alloc] initWithExpenseType:@"Insurance" andAmount:insurance],
                         [[Expense alloc] initWithExpenseType:@"Pro Mgmt" andAmount:propertyManagement],
                         [[Expense alloc] initWithExpenseType:@"Utilities" andAmount:[NSNumber numberWithDouble:0]],
                         nil];
            [_pieChart reloadData];
            
            _income= attributes[@"GrossIncome"];
            float sum = [mortage doubleValue] + [propertyTax doubleValue] + [propertyManagement doubleValue] + [insurance doubleValue];
            _expense = [NSNumber numberWithFloat:sum];
            
            [_incomePlot reloadData];
            [_expensePlot reloadData];
            
            float maxY = [_income floatValue] > [_expense floatValue]? [_income floatValue] : [_expense floatValue];
            [_barGraphPlotSpace setYRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt(maxY + 500)]];
            
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
            
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }
         ];
    }
}

-(void) createExpenseChart{
    
    
    //self.pieGraphView.allowPinchScaling = YES;
    
    
    // Create a CPTGraph object and add to hostView
    CPTGraph* graph = [[CPTXYGraph alloc] initWithFrame:self.pieGraphView.bounds];
    self.pieGraphView.hostedGraph = graph;
    
    // 2 - Set up text style
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor grayColor];
    textStyle.fontName = @"Helvetica-Bold";
    textStyle.fontSize = 16.0f;
    // 3 - Configure title
    NSString *title = @"Expenses";
    graph.title = title;
    graph.titleTextStyle = textStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, 17.0f);
    graph.axisSet = nil;
    
    _pieChart = [[CPTPieChart alloc] init];
    _pieChart.dataSource = self;
    _pieChart.delegate = self;
    _pieChart.pieRadius = (self.pieGraphView.bounds.size.height * 0.6) / 2;
    _pieChart.pieInnerRadius = (self.pieGraphView.bounds.size.height * 0.6) / 5;
    _pieChart.identifier = graph.title;
    _pieChart.startAngle = M_PI_4;
    _pieChart.sliceDirection = CPTPieDirectionClockwise;
    // 3 - Create gradient
    //    CPTGradient *overlayGradient = [[CPTGradient alloc] init];
    //    overlayGradient.gradientType = CPTGradientTypeRadial;
    //    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
    //    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
    //    //pieChart.overlayFill = [CPTFill fillWithGradient:overlayGradient];
    
    [graph addPlot:_pieChart];
    
    
}

-(void) createIncomeVsExpenseChart{
    
    CGFloat const CPDBarWidth = 0.25f;
    
    // Create a CPTGraph object and add to hostView
    CPTGraph* graph = [[CPTXYGraph alloc] initWithFrame:self.lineGraphView.bounds];
    //    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    self.lineGraphView.hostedGraph = graph;
    
    // 2 - Set up text style
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor grayColor];
    textStyle.fontName = @"Helvetica-Bold";
    textStyle.fontSize = 16.0f;
    // 3 - Configure title
    NSString *title = @"Income vs Expense";
    graph.title = title;
    graph.titleTextStyle = textStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, 27.0f);
    
        // 5 - Enable user interactions for plot space
    _barGraphPlotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    _barGraphPlotSpace.allowsUserInteraction = NO;
    
    [_barGraphPlotSpace setXRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromFloat(2.5)]];
    //[plotSpace setYRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt(3000 + 1)]];
    
    [[graph plotAreaFrame] setPaddingLeft:60.0f];
    [[graph plotAreaFrame] setPaddingTop:10.0f];
    [[graph plotAreaFrame] setPaddingBottom:40.0f];
    [[graph plotAreaFrame] setPaddingRight:0.0f];
    [[graph plotAreaFrame] setBorderLineStyle:nil];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)[graph axisSet];
    
    CPTXYAxis *xAxis = [axisSet xAxis];
    [xAxis setMajorIntervalLength:CPTDecimalFromInt(1)];
    [xAxis setMinorTickLineStyle:nil];
    [xAxis setLabelingPolicy:CPTAxisLabelingPolicyNone];
    [xAxis setLabelTextStyle:textStyle];
    
    CPTXYAxis *yAxis = [axisSet yAxis];
    [yAxis setMajorIntervalLength:CPTDecimalFromInt(1000)];
    [yAxis setMinorTickLineStyle:nil];
    [yAxis setLabelingPolicy:CPTAxisLabelingPolicyFixedInterval];
    
    _incomePlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor greenColor] horizontalBars:NO];
    [_incomePlot setIdentifier:@"Income"];
    [_incomePlot setBarWidth:CPTDecimalFromCGFloat(CPDBarWidth)];
    [_incomePlot setBarOffset:CPTDecimalFromCGFloat(CPDBarWidth)];
    [_incomePlot setDelegate:self];
    [_incomePlot setDataSource:self];
    [graph addPlot:_incomePlot];

    _expensePlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor redColor] horizontalBars:NO];
    [_expensePlot setIdentifier:@"Expense"];
    [_expensePlot setBarWidth:CPTDecimalFromCGFloat(CPDBarWidth)];
    [_expensePlot setDelegate:self];
    [_expensePlot setDataSource:self];
    [graph addPlot:_expensePlot];
    
    graph.legend = [CPTLegend legendWithGraph:graph];
    CPTMutableTextStyle *legendtextStyle = [CPTMutableTextStyle textStyle];
    legendtextStyle.color = [CPTColor grayColor];
    legendtextStyle.fontName = @"Helvetica-Bold";
    legendtextStyle.fontSize = 10.0f;
    graph.legend.textStyle = legendtextStyle;
    
    //graph.legend.fill = [CPTFill fillWithColor:[CPTColor darkGrayColor]];
   // graph.legend.borderLineStyle = axisSet.axisLineStyle;
    graph.legend.cornerRadius = 5.0;
    graph.legend.swatchSize = CGSizeMake(15.0, 15.0);
    graph.legendAnchor = CPTRectAnchorTopRight;
    graph.legendDisplacement = CGPointMake(30.0, -20.0);
    graph.legend.numberOfRows = 2;
    
}
// This method is here because this class also functions as datasource for our graph
// Therefore this class implements the CPTPlotDataSource protocol
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plotnumberOfRecords {
    if ([plotnumberOfRecords isKindOfClass:[CPTPieChart class]]) {
        return _expenses.count;
    }
    else {
        if ([plotnumberOfRecords.identifier isEqual:@"Expense"] ){
            return 1;
        }else if  ([plotnumberOfRecords.identifier isEqual:@"Income"] ){
            return 1;
        }
    }
    return 0;
}

// This method is here because this class also functions as datasource for our graph
// Therefore this class implements the CPTPlotDataSource protocol
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    if ([plot isKindOfClass:[CPTPieChart class]]) {
        Expense * expense = [_expenses objectAtIndex:index];
        return expense.ExpenseAmount;
    }
    else {
        if ([plot.identifier isEqual:@"Expense"] ){
            if (fieldEnum == CPTScatterPlotFieldX){
                return [NSNumber numberWithFloat: 1];
            }else{
                return [NSNumber numberWithFloat: [_expense floatValue]];
            }
        }
        else if ([plot.identifier isEqual:@"Income"] ) {
            if (fieldEnum == CPTScatterPlotFieldX){
                return [NSNumber numberWithFloat: 1];
            }else{
                return [NSNumber numberWithFloat: [_income floatValue]];
            }
            
        }
    }
    return 0;
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx
{
    if ([plot isKindOfClass:[CPTPieChart class]]) {
        static CPTMutableTextStyle *labelText = nil;
        if (!labelText) {
            labelText= [[CPTMutableTextStyle alloc] init];
            labelText.color = [CPTColor grayColor];
            labelText.fontSize = 10.0;
        }
        
        double sum = 0;
        for (Expense *expense in _expenses) {
            sum = sum + [[expense ExpenseAmount] doubleValue];
        }
        
        Expense * expense = [_expenses objectAtIndex:idx];
        
        double percent = [[expense ExpenseAmount] doubleValue] / sum;
        NSNumberFormatter *percentFormatter = [[NSNumberFormatter alloc]init];
        [percentFormatter setNumberStyle:NSNumberFormatterPercentStyle];
        
        NSString *label = [NSString stringWithFormat:@"%@ %@", expense.ExpenseType, [percentFormatter stringFromNumber:[NSNumber numberWithDouble:  percent]]];
        
        return [[CPTTextLayer alloc] initWithText:label style:labelText];
        
    }
    else {
        return nil;
    }
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
                                            MFMailComposeViewController * picker = [[MFMailComposeViewController alloc] init];
                                            NSString* body = [NSString stringWithFormat: @"http://kmlservice.azurewebsites.net/PropertyProfile?id=%@", self.MLNumber];
                                           
                                            [picker setSubject:@"Checkout this property"];
                                            [picker setTitle:@"Email"];
                                            [picker setMessageBody:body isHTML:YES];
                                            
                                            picker.mailComposeDelegate = self;
                                            [self presentViewController:picker animated:YES completion:NULL];
                                            
                                        }];
    
    UIAlertAction *placeOfferAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Place an Offer", @"Cancel action")
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           
                                           
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
    
    UIAlertAction *addContactSalesAction = [UIAlertAction
                                            actionWithTitle:NSLocalizedString(@"Contact Sales Agent", @"Cancel action")
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action)
                                            {
                                                
                                                
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
