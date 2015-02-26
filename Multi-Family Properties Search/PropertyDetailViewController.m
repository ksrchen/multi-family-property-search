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


@implementation PropertyDetailViewController

NSArray * _expenses;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _expenses = [[NSArray alloc]
                 initWithObjects:[[Expense alloc] initWithExpenseType:@"Mortgage" andAmount:[NSNumber numberWithDouble:2400]],
                 [[Expense alloc] initWithExpenseType:@"Prop Tax" andAmount:[NSNumber numberWithDouble:500]],
                 [[Expense alloc] initWithExpenseType:@"Insurance" andAmount:[NSNumber numberWithDouble:200]],
                 [[Expense alloc] initWithExpenseType:@"Pro Mgmt" andAmount:[NSNumber numberWithDouble:150]],
                 [[Expense alloc] initWithExpenseType:@"Utilities" andAmount:[NSNumber numberWithDouble:75]],
                 nil];
    
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 6.0;
    self.scrollView.delegate = self;
    
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
            
            [self createPieChart];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }
        ];
    }
}

-(void) createPieChart{
    
    
    self.pieGraphView.allowPinchScaling = YES;
    
    
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
        
    CPTPieChart *pieChart = [[CPTPieChart alloc] init];
    pieChart.dataSource = self;
    pieChart.delegate = self;
    pieChart.pieRadius = (self.pieGraphView.bounds.size.height * 0.6) / 2;
    pieChart.identifier = graph.title;
    pieChart.startAngle = M_PI_4;
    pieChart.sliceDirection = CPTPieDirectionClockwise;
    // 3 - Create gradient
//    CPTGradient *overlayGradient = [[CPTGradient alloc] init];
//    overlayGradient.gradientType = CPTGradientTypeRadial;
//    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
//    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
//    //pieChart.overlayFill = [CPTFill fillWithGradient:overlayGradient];
    
    [graph addPlot:pieChart];
    
}
// This method is here because this class also functions as datasource for our graph
// Therefore this class implements the CPTPlotDataSource protocol
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plotnumberOfRecords {
    if ([plotnumberOfRecords isKindOfClass:[CPTPieChart class]]) {
        return _expenses.count;
    }
    else {
        return (NSUInteger) 0;
    }
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
        return (NSUInteger) 0;
    }
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx
{
    if ([plot isKindOfClass:[CPTPieChart class]]) {
        static CPTMutableTextStyle *labelText = nil;
        if (!labelText) {
            labelText= [[CPTMutableTextStyle alloc] init];
            labelText.color = [CPTColor grayColor];
        }
        Expense * expense = [_expenses objectAtIndex:idx];
        return [[CPTTextLayer alloc] initWithText:expense.ExpenseType style:labelText];
        
    }
    else {
        return nil;
    }
}

- (IBAction)contactMe:(id)sender {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Property Detail"
                                                                              message:@"Enter your comment and tap Send"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    
       [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
        {
            
                     textField.placeholder = NSLocalizedString(@"comment", @"Login");
         }];
    
    
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Send", @"OK action")
                               style:UIAlertActionStyleDestructive
                               handler:^(UIAlertAction *action)
                               {
                                   UIAlertController * confirmController = [UIAlertController alertControllerWithTitle:@"Property Detail"
                                                                                                             message:@"Comment sent!"
                                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                                   
                                   UIAlertAction *closeAction = [UIAlertAction
                                                                 actionWithTitle:NSLocalizedString(@"OK", @"Cancel action")
                                                                 style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction *action)
                                                                 {
                                                                     
                                                                     
                                                                 }];
                                   [confirmController addAction:closeAction];

                                   [self presentViewController:confirmController animated:YES completion:nil];
                                   
                               }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                       
                                   }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.contentView;
}

@end
