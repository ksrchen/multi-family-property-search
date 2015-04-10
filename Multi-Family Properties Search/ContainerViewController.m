
#import "ContainerViewController.h"
#import "SearchViewController.h"
#import "ListViewController.h"


@interface ContainerViewController ()

@property (assign, nonatomic) BOOL transitionInProgress;

@end

@implementation ContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.transitionInProgress = NO;
    self.currentSegueIdentifier = SegueIdentifierMap;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    // Instead of creating new VCs on each seque we want to hang on to existing
    // instances if we have it. Remove the second condition of the following
    // two if statements to get new VC instances instead.
    if ([segue.identifier isEqualToString:SegueIdentifierMap]) {
        self.mapViewController = segue.destinationViewController;
    }

    if ([segue.identifier isEqualToString:SegueIdentifierList]) {
        self.listViewController = segue.destinationViewController;
    }

    // If we're going to the first view controller.
    if ([segue.identifier isEqualToString:SegueIdentifierMap]) {
        // If this is not the first time we're loading this.
        if (self.childViewControllers.count > 0) {
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.mapViewController];
        }
        else {
            // If this is the very first time we're loading this we need to do
            // an initial load and not a swap.
            [self addChildViewController:segue.destinationViewController];
            UIView* destView = ((UIViewController *)segue.destinationViewController).view;
            destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:destView];
            [segue.destinationViewController didMoveToParentViewController:self];
        }
    }
    // By definition the second view controller will always be swapped with the
    // first one.
    else if ([segue.identifier isEqualToString:SegueIdentifierList]) {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.listViewController];
    }
}

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];

    [self transitionFromViewController:fromViewController toViewController:toViewController duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:^(BOOL finished) {
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
        self.transitionInProgress = NO;
    }];
}

- (void)swapViewControllers
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    if (self.transitionInProgress) {
        return;
    }

    self.transitionInProgress = YES;
    self.currentSegueIdentifier = ([self.currentSegueIdentifier isEqualToString:SegueIdentifierMap]) ? SegueIdentifierList : SegueIdentifierMap;
    
    if (([self.currentSegueIdentifier isEqualToString:SegueIdentifierMap]) && self.mapViewController) {
        [self swapFromViewController:self.listViewController toViewController:self.mapViewController];
        return;
    }
    
    if (([self.currentSegueIdentifier isEqualToString:SegueIdentifierList]) && self.listViewController) {
        [self swapFromViewController:self.mapViewController toViewController:self.listViewController];
        return;
    }

    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

@end
