//
//  ChartPageViewController.m
//  Chrometopia
//
//  Created by Kevin Chen on 7/24/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "ChartPageViewController.h"
#import "ExpenseChartViewController.h"
#import "IncomeExpenseChartViewController.h"
#import "PagedViewController.h"
#import "AppreciationViewController.h"

@interface ChartPageViewController ()
<UIPageViewControllerDataSource, UIPageViewControllerDelegate>
{
    id _data;
}
@end

@implementation ChartPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = self;
    self.delegate = self;
    [self setViewControllers:@[[self viewControllerAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
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
-(void)loadData:(id)data
{
    _data = data;
    for (PagedViewController *vc in self.viewControllers) {
        [vc LoadData:_data];
    }
}

//-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
//{
//    for (PagedViewController *vc in self.viewControllers) {
//        [vc LoadData:_data];
//    }
//
//}
-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    for (PagedViewController *vc in pendingViewControllers) {
        [vc LoadData:_data];
    }

    
}
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    PagedViewController * controller = (PagedViewController *)viewController;
    int index = controller.index;
    index++;
    
    return [self viewControllerAtIndex:index];
    
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    PagedViewController * controller = (PagedViewController *)viewController;
    int index = controller.index;
    index--;
    
    return [self viewControllerAtIndex:index];

}

-(PagedViewController *)viewControllerAtIndex:(int)index
{
    switch (index) {
        case 0:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PropertyDetails" bundle:nil];
            PagedViewController *vc  =[storyboard instantiateViewControllerWithIdentifier:@"IncomeExpenseChart"];
            vc.index = index;
            return vc;
        }
            break;
        case 1:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PropertyDetails" bundle:nil];
            PagedViewController *vc  =[storyboard instantiateViewControllerWithIdentifier:@"ExpenseChart"];
            vc.index = index;
            return vc;
        }
            break;
            
        case 2:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PropertyDetails" bundle:nil];
            PagedViewController *vc  =[storyboard instantiateViewControllerWithIdentifier:@"ROIChart"];
            vc.index = index;
            return vc;
        }
            break;
        case 3:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PropertyDetails" bundle:nil];
            PagedViewController *vc  =[storyboard instantiateViewControllerWithIdentifier:@"AppreciationChart"];
            vc.index = index;
            return vc;
        }
            break;
            
        default:
            break;
    }
   
    
    return nil;
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 4;
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}
@end

