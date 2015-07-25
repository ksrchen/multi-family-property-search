//
//  AppreciationViewController.m
//  Chrometopia
//
//  Created by Kevin Chen on 7/25/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "AppreciationViewController.h"

@interface AppreciationViewController ()

<CPTPlotDataSource>
{
    NSMutableArray *_data;
    CPTScatterPlot *_plot;
    CPTXYPlotSpace *_barGraphPlotSpace;
}
@end

@implementation AppreciationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _data =[[NSMutableArray alloc] init];
    
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
    
    CPTGraph* graph = [[CPTXYGraph alloc] initWithFrame:self.GraphView.bounds];
    self.GraphView.hostedGraph = graph;
    
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontSize = 18.0f;
    
    NSString *title = @"Income Appreciation";
    graph.title = title;
    graph.titleTextStyle = textStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, 20.0f);
    
    _barGraphPlotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    _barGraphPlotSpace.allowsUserInteraction = NO;
    
    [_barGraphPlotSpace setXRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromFloat(2.5)]];
    
    [[graph plotAreaFrame] setPaddingLeft:50.0f];
    [[graph plotAreaFrame] setPaddingTop:10.0f];
    [[graph plotAreaFrame] setPaddingBottom:50.0f];
    [[graph plotAreaFrame] setPaddingRight:0.0f];
    [[graph plotAreaFrame] setBorderLineStyle:nil];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)[graph axisSet];
    
    CPTXYAxis *xAxis = [axisSet xAxis];
    [xAxis setMajorIntervalLength:CPTDecimalFromInt(5)];
    [xAxis setMinorTickLineStyle:nil];
    [xAxis setLabelingPolicy:CPTAxisLabelingPolicyFixedInterval];
    [xAxis setTitleOffset:25.0];
    [xAxis setTitle:@"Year"];
    
    CPTXYAxis *yAxis = [axisSet yAxis];
    [yAxis setMajorIntervalLength:CPTDecimalFromFloat(1000)];
    [yAxis setMinorTickLineStyle:nil];
    [yAxis setLabelingPolicy:CPTAxisLabelingPolicyFixedInterval];
    
    CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
    borderLineStyle.lineColor = [CPTColor lightGrayColor];
    
    _plot = [[CPTScatterPlot alloc] init];
    [_plot setIdentifier:@"Appreciation"];
    
    CPTMutableLineStyle *mainPlotLineStyle = [[_plot dataLineStyle] mutableCopy];
    [mainPlotLineStyle setLineWidth:2.0f];
    [mainPlotLineStyle setLineColor:[CPTColor greenColor]];
    [_plot setDataLineStyle:mainPlotLineStyle];
    
    [_plot setDelegate:self];
    [_plot setDataSource:self];
    [graph addPlot:_plot];
}
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plotnumberOfRecords {
    return _data.count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    if (fieldEnum == CPTScatterPlotFieldX){
        return [NSNumber numberWithInteger:index];
    }else{
        NSNumber *value = [_data objectAtIndex:index];
        return  value;
    }
}



-(void)LoadData:(id)data
{
    [_data removeAllObjects];
    NSDictionary * attributes = (NSDictionary*) data;
    
    NSNumber *income = attributes[@"GrossIncome"];
    NSNumber *rate = attributes[@"ReentAppreciatioinRate"];
    float value = [income floatValue];
    float factor = [rate floatValue] + 1.0;
    
    for (int i=0; i<30; i++) {
        [_data addObject:[NSNumber numberWithFloat:value]];
        value = value * factor;
    }
    
    [_plot reloadData];
    [_barGraphPlotSpace setXRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt(32)]];
    [_barGraphPlotSpace setYRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromFloat(value)]];

}


@end
