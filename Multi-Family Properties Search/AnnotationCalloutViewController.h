//
//  AnnotationCalloutViewController.h
//  Chrometopia
//
//  Created by Kevin Chen on 7/18/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Property.h"
@protocol AnnotationCalloutViewDelegate <NSObject>
@required
- (void) viewDidTapped: (Property *)property;
@end

@interface AnnotationCalloutViewController : UIViewController
@property (nonatomic, weak) Property *Property;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *roiLabel;
@property (weak, nonatomic) id<AnnotationCalloutViewDelegate> delegate;
@end
