//
//  ROIChartViewController.m
//  Chrometopia
//
//  Created by Kevin Chen on 7/24/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "ROIChartViewController.h"

@interface ROIChartViewController ()

<CPTPlotDataSource>
{
    NSNumber *_roi;
    CPTBarPlot *_plot;
    CPTXYPlotSpace *_barGraphPlotSpace;
}
@end

@implementation ROIChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createPlot];
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

-(void) createPlot{
    
    CGFloat const CPDBarWidth = 0.25f;
    
    CPTGraph* graph = [[CPTXYGraph alloc] initWithFrame:self.GraphView.bounds];
    self.GraphView.hostedGraph = graph;
    
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontSize = 18.0f;

    NSString *title = @"ROI";
    graph.title = title;
    graph.titleTextStyle = textStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, 20.0f);
    
    _barGraphPlotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    _barGraphPlotSpace.allowsUserInteraction = NO;
    
    [_barGraphPlotSpace setXRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromFloat(2.5)]];
    
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
    [yAxis setMajorIntervalLength:CPTDecimalFromFloat(0.1)];
    [yAxis setMinorTickLineStyle:nil];
    [yAxis setLabelingPolicy:CPTAxisLabelingPolicyFixedInterval];
    
    CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
    borderLineStyle.lineColor = [CPTColor lightGrayColor];
    
    _plot = [[CPTBarPlot alloc] init];
    [_plot setIdentifier:@"ROI"];
    [_plot setBarWidth:CPTDecimalFromCGFloat(CPDBarWidth)];
    [_plot setBarOffset:CPTDecimalFromCGFloat(CPDBarWidth+0.5)];
    _plot.lineStyle = borderLineStyle;
    [_plot setDelegate:self];
    [_plot setDataSource:self];
    [graph addPlot:_plot];
    
//    graph.legend = [CPTLegend legendWithGraph:graph];
//    CPTMutableTextStyle *legendtextStyle = [CPTMutableTextStyle textStyle];
//    graph.legend.textStyle = legendtextStyle;
//    
//    graph.legend.cornerRadius = 5.0;
//    graph.legend.swatchSize = CGSizeMake(15.0, 15.0);
//    graph.legendAnchor = CPTRectAnchorTopRight;
//    graph.legendDisplacement = CGPointMake(0.0, -20.0);
//    graph.legend.numberOfRows = 2;
    
}
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plotnumberOfRecords {
       return 1;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    return [NSNumber numberWithFloat: [_roi floatValue]];
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx
{
    return nil;
}

-(CPTFill *)barFillForBarPlot:(CPTBarPlot *)barPlot
                  recordIndex:(NSUInteger)index
{
    return [CPTFill fillWithColor:[CPTColor greenColor]];
}

-(void)LoadData:(id)data
{
    NSDictionary * attributes = (NSDictionary*) data;
    _roi= attributes[@"ROI"];
    [_plot reloadData];
    [_barGraphPlotSpace setYRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromFloat([_roi floatValue]+ 0.2)]];
}


@end
