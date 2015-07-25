//
//  PagedViewController.h
//  Chrometopia
//
//  Created by Kevin Chen on 7/24/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagedViewController : UIViewController
@property (nonatomic) int index;
-(void)LoadData:(id)data;
@end
