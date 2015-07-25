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
<UIDocumentInteractionControllerDelegate>
{
    UIDocumentInteractionController *_documentInterationController;
}

@end

@implementation ReportViewerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[ReportManager getInstance] getReport:self.MLNumber success:^(NSURL *filePath) {
        _documentInterationController = [UIDocumentInteractionController interactionControllerWithURL:filePath];
        _documentInterationController.delegate = self;
        [_documentInterationController presentPreviewAnimated:YES];
        
        //NSLog(@"%@", filePath);
    } failure:^(NSError *error) {
        
    }];
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

-(UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

@end
