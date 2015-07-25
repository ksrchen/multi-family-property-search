//
//  IncomeExpenseChartViewController.m
//  Chrometopia
//
//  Created by Kevin Chen on 7/23/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "IncomeExpenseChartViewController.h"

@interface IncomeExpenseChartViewController ()
<CPTPlotDataSource>
{
    NSNumber *_income;
    NSNumber *_expense;
    
    CPTBarPlot *_incomePlot;
    CPTBarPlot *_expensePlot;
    CPTXYPlotSpace *_barGraphPlotSpace;
}
@end

@implementation IncomeExpenseChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createIncomeVsExpenseChart];
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

-(void) createIncomeVsExpenseChart{
    
    CGFloat const CPDBarWidth = 0.25f;
    
    // Create a CPTGraph object and add to hostView
    CPTGraph* graph = [[CPTXYGraph alloc] initWithFrame:self.lineGraphView.bounds];
    //    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    self.lineGraphView.hostedGraph = graph;
    
    // 2 - Set up text style
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
   // textStyle.color = [CPTColor grayColor];
    //textStyle.fontName = @"Helvetica-Bold";
    textStyle.fontSize = 18.0f;
    // 3 - Configure title
    NSString *title = @"Income vs Expense";
    graph.title = title;
    graph.titleTextStyle = textStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, 20.0f);
    
    // 5 - Enable user interactions for plot space
    _barGraphPlotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    _barGraphPlotSpace.allowsUserInteraction = NO;
    
    [_barGraphPlotSpace setXRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromFloat(2.5)]];
    //[plotSpace setYRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt(3000 + 1)]];
    
    [[graph plotAreaFrame] setPaddingLeft:45.0f];
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
    
    CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
    borderLineStyle.lineColor = [CPTColor lightGrayColor];
    
    _incomePlot = [[CPTBarPlot alloc] init];
    [_incomePlot setIdentifier:@"Income"];
    [_incomePlot setBarWidth:CPTDecimalFromCGFloat(CPDBarWidth)];
    [_incomePlot setBarOffset:CPTDecimalFromCGFloat(CPDBarWidth+0.02)];
    _incomePlot.lineStyle = borderLineStyle;
    [_incomePlot setDelegate:self];
    [_incomePlot setDataSource:self];
    [graph addPlot:_incomePlot];
    
    _expensePlot = [[CPTBarPlot alloc]init];
    [_expensePlot setIdentifier:@"Expense"];
    [_expensePlot setBarWidth:CPTDecimalFromCGFloat(CPDBarWidth)];
    _expensePlot.lineStyle = borderLineStyle;
    [_expensePlot setDelegate:self];
    [_expensePlot setDataSource:self];
    [graph addPlot:_expensePlot];
    
    graph.legend = [CPTLegend legendWithGraph:graph];
    CPTMutableTextStyle *legendtextStyle = [CPTMutableTextStyle textStyle];
   // legendtextStyle.color = [CPTColor grayColor];
   // legendtextStyle.fontName = @"Helvetica-Bold";
   // legendtextStyle.fontSize = 10.0f;
    graph.legend.textStyle = legendtextStyle;
    
    
    //graph.legend.fill = [CPTFill fillWithColor:[CPTColor darkGrayColor]];
    // graph.legend.borderLineStyle = axisSet.axisLineStyle;
    graph.legend.cornerRadius = 5.0;
    graph.legend.swatchSize = CGSizeMake(15.0, 15.0);
    graph.legendAnchor = CPTRectAnchorTopRight;
    graph.legendDisplacement = CGPointMake(0.0, -20.0);
    graph.legend.numberOfRows = 2;
    
}
// This method is here because this class also functions as datasource for our graph
// Therefore this class implements the CPTPlotDataSource protocol
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plotnumberOfRecords {
    if ([plotnumberOfRecords.identifier isEqual:@"Expense"] ){
        return 1;
    }else if  ([plotnumberOfRecords.identifier isEqual:@"Income"] ){
        return 1;
    }
    
    return 0;
}

// This method is here because this class also functions as datasource for our graph
// Therefore this class implements the CPTPlotDataSource protocol
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
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
    
    return 0;
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx
{
    return nil;
}

-(CPTFill *)barFillForBarPlot:(CPTBarPlot *)barPlot
                  recordIndex:(NSUInteger)index
{
    if ([barPlot.identifier isEqual:@"Expense"]){
        return [CPTFill fillWithColor:[CPTColor redColor]];
    }
    else{
        return [CPTFill fillWithColor:[CPTColor greenColor]];
    }
}

-(void)LoadData:(id)data
{
    NSDictionary * attributes = (NSDictionary*) data;
 
    _income= attributes[@"GrossIncome"];
    
    NSNumber *mortage = attributes[@"Mortage"];
    NSNumber *propertyTax = attributes[@"PropertyTax"];
    NSNumber *propertyManagement = attributes[@"PropertyManagement"];
    NSNumber *insurance = attributes[@"Insurance"];
    NSNumber *utilities = attributes[@"Utilites"];
    NSNumber *mainteance = attributes[@"Maintenance"];
    
    float sum = [mortage doubleValue] + [propertyTax doubleValue] +
        [propertyManagement doubleValue] + [insurance doubleValue] +
        [utilities doubleValue] + [mainteance doubleValue];
    
    _expense = [NSNumber numberWithFloat:sum];
    
    [_incomePlot reloadData];
    [_expensePlot reloadData];
    
    float maxY = [_income floatValue] > [_expense floatValue]? [_income floatValue] : [_expense floatValue];
    [_barGraphPlotSpace setYRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt(maxY + 500)]];
    
}



@end
