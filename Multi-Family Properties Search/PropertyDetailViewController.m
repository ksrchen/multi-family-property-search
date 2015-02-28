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
NSArray * _expenseData;
NSArray * _incomeData;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _expenses = [[NSArray alloc]
                 initWithObjects:[[Expense alloc] initWithExpenseType:@"Mortgage" andAmount:[NSNumber numberWithDouble:2400]],
                 [[Expense alloc] initWithExpenseType:@"Prop Tax" andAmount:[NSNumber numberWithDouble:500]],
                 [[Expense alloc] initWithExpenseType:@"Insurance" andAmount:[NSNumber numberWithDouble:200]],
                 [[Expense alloc] initWithExpenseType:@"Pro Mgmt" andAmount:[NSNumber numberWithDouble:150]],
                 [[Expense alloc] initWithExpenseType:@"Utilities" andAmount:[NSNumber numberWithDouble:75]],
                 nil];
    
    _expenseData = [[NSArray alloc] initWithObjects:
                    [NSValue valueWithCGPoint:CGPointMake(0, 0)],
                    [NSValue valueWithCGPoint:CGPointMake(2,  3)],
                    [NSValue valueWithCGPoint:CGPointMake(5, 4)],
                    [NSValue valueWithCGPoint:CGPointMake(10, 6)],
                    [NSValue valueWithCGPoint:CGPointMake(30, 8)],
                    nil];
    
    _incomeData = [[NSArray alloc] initWithObjects:
                    [NSValue valueWithCGPoint:CGPointMake(0, 0)],
                    [NSValue valueWithCGPoint:CGPointMake(2,  5)],
                    [NSValue valueWithCGPoint:CGPointMake(5, 8)],
                    [NSValue valueWithCGPoint:CGPointMake(10, 10)],
                    [NSValue valueWithCGPoint:CGPointMake(30, 15)],
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
            
            [self createExpenseChart];
            [self createIncomeVsExpenseChart];
            
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

-(void) createIncomeVsExpenseChart{
    
    
    self.lineGraphView.allowPinchScaling = YES;
    
    
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
    NSString *title = @"Income VS Expense";
    graph.title = title;
    graph.titleTextStyle = textStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, 27.0f);
    
    [graph.plotAreaFrame setPaddingLeft:30.0f];
    [graph.plotAreaFrame setPaddingBottom:20.0f];
    // 5 - Enable user interactions for plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    //[plotSpace setXRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(5.0f)]];
    //[plotSpace setYRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(10.0f)]];
    NSNumberFormatter *axisFormatter = [[NSNumberFormatter alloc] init];
    [axisFormatter setMinimumIntegerDigits:1];
    [axisFormatter setMaximumFractionDigits:0];
    
    CPTMutableTextStyle *textStyleAxis = [CPTMutableTextStyle textStyle];
    [textStyle setFontSize:12.0f];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)[graph axisSet];
    
    CPTXYAxis *xAxis = [axisSet xAxis];
   // [xAxis setMajorTickLength: 8.0f];
   // [xAxis setMinorTickLineStyle:nil];
    [xAxis setLabelingPolicy:CPTAxisLabelingPolicyAutomatic];
    [xAxis setLabelTextStyle:textStyleAxis];
    [xAxis setLabelFormatter:axisFormatter];
    [xAxis setTickDirection:CPTSignNegative];
    //[xAxis setAxisConstraints:[CPTConstraints constraintWithLowerOffset:5.0f]];
//    CGFloat dateCount = [_expenseData count];
//    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:dateCount];
//    NSMutableSet *xLocations = [NSMutableSet setWithCapacity:dateCount];
//    NSInteger i = 0;
//    for (NSValue * val in _expenseData) {
//        CGPoint point = [val CGPointValue];
//        
//        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%.f", point.x]  textStyle:xAxis.labelTextStyle];
//        CGFloat location = i++;
//        label.tickLocation = CPTDecimalFromCGFloat(location);
//        label.offset = xAxis.majorTickLength;
//        if (label) {
//            [xLabels addObject:label];
//            [xLocations addObject:[NSNumber numberWithFloat:location]];
//        }
//    }
//    xAxis.axisLabels = xLabels;
//    xAxis.majorTickLocations = xLocations;
//    
    CPTXYAxis *yAxis = [axisSet yAxis];
   // [yAxis setMajorTickLength: 8.0f];;
   // [yAxis setMinorTickLineStyle:nil];
    [yAxis setLabelingPolicy:CPTAxisLabelingPolicyAutomatic];
    [yAxis setLabelTextStyle:textStyleAxis];
    [yAxis setLabelFormatter:axisFormatter];
    [yAxis setTickDirection:CPTSignNegative];
    
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    [axisLineStyle setLineWidth:1];
    [axisLineStyle setLineColor:[CPTColor colorWithCGColor:[[UIColor grayColor] CGColor]]];
    
    [xAxis setAxisLineStyle:axisLineStyle];
    [xAxis setMajorTickLineStyle:axisLineStyle];
    [yAxis setAxisLineStyle:axisLineStyle];
    [yAxis setMajorTickLineStyle:axisLineStyle];
    
    
    CPTScatterPlot *expensePlot = [[CPTScatterPlot alloc] initWithFrame:[graph bounds]];
    [expensePlot setIdentifier:@"expensePlot"];
    [expensePlot setDelegate:self];
    [expensePlot setDataSource:self];
    
    CPTMutableLineStyle *mainPlotLineStyle = [[expensePlot dataLineStyle] mutableCopy];
    [mainPlotLineStyle setLineWidth:2.0f];
    [mainPlotLineStyle setLineColor:[CPTColor colorWithCGColor:[[UIColor blueColor] CGColor]]];
    
    [expensePlot setDataLineStyle:mainPlotLineStyle];
    
    [graph addPlot:expensePlot];
    
    CPTScatterPlot *incomePlot = [[CPTScatterPlot alloc] initWithFrame:[graph bounds]];
    [incomePlot setIdentifier:@"incomePlot"];
    [incomePlot setDelegate:self];
    [incomePlot setDataSource:self];
    
    CPTMutableLineStyle *incomePlotLineStyle = [[incomePlot dataLineStyle] mutableCopy];
    [incomePlotLineStyle setLineWidth:2.0f];
    [incomePlotLineStyle setLineColor:[CPTColor colorWithCGColor:[[UIColor greenColor] CGColor]]];
    
    [incomePlot setDataLineStyle:incomePlotLineStyle];
    
    [graph addPlot:incomePlot];
    
    [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:expensePlot, incomePlot, nil]];
    
}
// This method is here because this class also functions as datasource for our graph
// Therefore this class implements the CPTPlotDataSource protocol
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plotnumberOfRecords {
    if ([plotnumberOfRecords isKindOfClass:[CPTPieChart class]]) {
        return _expenses.count;
    }
    else {
        if ([plotnumberOfRecords.identifier isEqual:@"expensePlot"] ){
            return _expenseData.count;
        }else if  ([plotnumberOfRecords.identifier isEqual:@"incomePlot"] ){
            return _incomeData.count;
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
        if ([plot.identifier isEqual:@"expensePlot"] ){
            NSValue * value = [_expenseData objectAtIndex:index];
            CGPoint point = [value CGPointValue];
            if (fieldEnum == CPTScatterPlotFieldX){
                return [NSNumber numberWithFloat: point.x];
            }else{
                return [NSNumber numberWithFloat: point.y];
            }
        }
        else if ([plot.identifier isEqual:@"incomePlot"] ) {
            NSValue * value = [_incomeData objectAtIndex:index];
            CGPoint point = [value CGPointValue];
            if (fieldEnum == CPTScatterPlotFieldX){
                return [NSNumber numberWithFloat: point.x];
            }else{
                return [NSNumber numberWithFloat: point.y];
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
