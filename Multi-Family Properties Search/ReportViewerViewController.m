//
//  ReportViewerViewController.m
//  Chrometopia
//
//  Created by Kevin Chen on 7/25/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "ReportViewerViewController.h"
#import "ReportManager.h"
@interface ReportViewerViewController ()
<QLPreviewControllerDataSource, QLPreviewItem>
{
   // UIDocumentInteractionController *_documentInterationController;
  //  NSURL *_url;
    UIBarButtonItem *_actionItem;
}
@end

@implementation ReportViewerViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.dataSource = self;
    [self reloadData];

}

- (void)didReceiveMemoryWarning {
    //[super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
     [super viewDidAppear:animated];
     _actionItem = self.navigationItem.rightBarButtonItem;
     self.navigationItem.rightBarButtonItem = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//-(UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
//{
//    return self;
//}

-(NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return self;
}

-(NSURL *)previewItemURL
{
    return self.fileUrl;
}
@end
