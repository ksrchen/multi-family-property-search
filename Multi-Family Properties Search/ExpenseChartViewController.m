//
//  ExpenseChartViewController.m
//  Chrometopia
//
//  Created by Kevin Chen on 7/23/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "ExpenseChartViewController.h"
#import "Expense.h"

@interface ExpenseChartViewController ()
<CPTPlotDataSource>
{
    NSArray * _expenses;
    NSNumber *_expense;
    
    CPTPieChart *_pieChart;
    CPTBarPlot *_expensePlot;
      
}


@end

@implementation ExpenseChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _expenses = [[NSArray alloc] init];
    [self createExpenseChart];
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void) createExpenseChart{
    
    
    //self.pieGraphView.allowPinchScaling = YES;
    
    
    // Create a CPTGraph object and add to hostView
    CPTGraph* graph = [[CPTXYGraph alloc] initWithFrame:self.pieGraphView.bounds];
    self.pieGraphView.hostedGraph = graph;
    
    // 2 - Set up text style
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
   // textStyle.color = [CPTColor grayColor];
  //  textStyle.fontName = @"Helvetica-Bold";
    //textStyle.fontSize = 16.0f;
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
-(void)LoadData:(id)data
{
    
    NSDictionary * attributes = (NSDictionary*) data;
    
    NSNumber *mortage = attributes[@"Mortage"];
    NSNumber *propertyTax = attributes[@"PropertyTax"];
    NSNumber *propertyManagement = attributes[@"PropertyManagement"];
    NSNumber *insurance = attributes[@"Insurance"];
    NSNumber *utilities = attributes[@"Utilites"];
    NSNumber *mainteance = attributes[@"Maintenance"];
    
    _expenses = [[NSArray alloc]
                 initWithObjects:[[Expense alloc] initWithExpenseType:@"Mortgage" andAmount:mortage],
                 [[Expense alloc] initWithExpenseType:@"Ins" andAmount:insurance],
                 [[Expense alloc] initWithExpenseType:@"Mgmt" andAmount:propertyManagement],
                 [[Expense alloc] initWithExpenseType:@"Prop Tax" andAmount:propertyTax],
                 [[Expense alloc] initWithExpenseType:@"Utilities" andAmount:utilities],
                 [[Expense alloc] initWithExpenseType:@"Maint" andAmount:mainteance],
                 nil];
    [_pieChart reloadData];
    
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
        else {
            return nil;
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
          //  labelText.color = [CPTColor grayColor];
            labelText.fontSize = 12.0;
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
@end
