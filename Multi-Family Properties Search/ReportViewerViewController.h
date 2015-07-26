//
//  ReportViewerViewController.h
//  Chrometopia
//
//  Created by Kevin Chen on 7/25/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@import QuickLook;

@interface ReportViewerViewController : QLPreviewController
@property (nonatomic, copy) NSString * MLNumber;
@property (nonatomic, copy) NSURL *fileUrl;
@end
