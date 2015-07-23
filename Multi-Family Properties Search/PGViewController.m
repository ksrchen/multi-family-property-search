

#import "PGViewController.h"
#import "MMDrawerController.h"

@interface PGViewController ()

@end

@implementation PGViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self performSegueWithIdentifier:@"DRAWER_SEGUE" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DRAWER_SEGUE"]) {
        MMDrawerController *destinationViewController = (MMDrawerController *) segue.destinationViewController;

       // Instantitate and set the center view controller.
       UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MapSearch" bundle:nil];
       UIViewController *centerViewController = [storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
        [destinationViewController setCenterViewController:centerViewController];

        // Instantiate and set the left drawer controller.
        UIViewController *leftDrawerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SIDE_DRAWER_CONTROLLER"];
        [destinationViewController setLeftDrawerViewController:leftDrawerViewController];

    }
}
@end
