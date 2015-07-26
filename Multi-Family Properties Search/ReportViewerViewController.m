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
    bool _isPaid;
    UIBarButtonItem *_paidBarItem;
}
@end

@implementation ReportViewerViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isPaid = NO;
    _paidBarItem = [[UIBarButtonItem alloc] initWithTitle:@"$9.99" style:UIBarButtonItemStylePlain target:self action:@selector(pay:)];
    self.dataSource = self;
    [self reloadData];

}

-(void)pay:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Info" message:@"This takes user to the Apple Store to pay the $9.99 membership. After which the user have full access to this report"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        _isPaid = YES;
        [self updateRightButtonItem];
        
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)updateRightButtonItem
{
    if (_isPaid){
        self.navigationItem.rightBarButtonItem = _actionItem;
    }else{
        self.navigationItem.rightBarButtonItem = _paidBarItem;
    }
}
- (void)didReceiveMemoryWarning {
    //[super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
     [super viewDidAppear:animated];
     _actionItem = self.navigationItem.rightBarButtonItem;
    [self updateRightButtonItem];
}
-(void)viewWillLayoutSubviews
{
    if (![self.navigationItem.rightBarButtonItem isEqual:_paidBarItem]){
        _actionItem = self.navigationItem.rightBarButtonItem;
    }
    [self updateRightButtonItem];
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
