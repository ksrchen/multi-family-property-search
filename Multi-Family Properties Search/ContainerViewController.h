#import <UIKit/UIKit.h>
#import "ListViewController.h"
#import "SearchViewController.h"

#define SegueIdentifierMap @"mapView"
#define SegueIdentifierList @"listView"

@interface ContainerViewController : UIViewController
@property (strong, nonatomic) NSString *currentSegueIdentifier;
@property (strong, nonatomic) SearchViewController *mapViewController;
@property (strong, nonatomic) ListViewController *listViewController;

- (void)swapViewControllers;

@end
