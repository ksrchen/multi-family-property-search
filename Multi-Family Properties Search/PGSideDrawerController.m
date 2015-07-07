

#import "PGSideDrawerController.h"
#import "UIViewController+MMDrawerController.h"

@interface PGSideDrawerController ()
@property(nonatomic, strong) NSIndexPath *currentIndex;
@end

@implementation PGSideDrawerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentIndex = [NSIndexPath indexPathForRow:1 inSection:0];
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.currentIndex isEqual:indexPath]) {
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
        return;
    }
    
    UIViewController *centerViewController;
    if (indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
                centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HotestViewController"];
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
                break;
            case 1:
                centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyListingViewController"];
                break;
            case 2:
                centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HotestViewController"];
                break;
            case 3:
            {
                NSString* url = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=123"];
                [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
            }
                break;
            default:
                break;
        }
    } else if (indexPath.section == 3){
        switch (indexPath.row) {
            case 0:
                centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
                break;
            case 1:
                centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyAccountViewController"];
                break;
                
            default:
                break;
        }
    }
    if (centerViewController) {
        self.currentIndex = indexPath;
        [self.mm_drawerController setCenterViewController:centerViewController withCloseAnimation:YES completion:nil];
    } else {
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    }
}

@end
