

#import "PGSideDrawerController.h"
#import "UIViewController+MMDrawerController.h"

NSString *const SHOW_MAP = @"ShowMap";
NSString *const SHOW_HOTTEST_PROPERTIES = @"ShowHottestProperties";

@interface PGSideDrawerController ()
@property(nonatomic, strong) NSIndexPath *currentIndex;
@end

@implementation PGSideDrawerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowMapView) name:SHOW_MAP object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHottestPropertiesView) name:SHOW_HOTTEST_PROPERTIES object:nil];

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
            {
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"HottestProperty" bundle:nil];
                centerViewController = [storyBoard instantiateViewControllerWithIdentifier:@"HottestPropertyView"];
            }
                break;
            case 1:
            {
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MapSearch" bundle:nil];
                centerViewController = [storyBoard instantiateViewControllerWithIdentifier:@"SearchViewController"];
            }
                break;

            default:
                break;
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MyProperties" bundle:nil];
                centerViewController = [storyBoard instantiateViewControllerWithIdentifier:@"MyListingViewController"];
            }
                break;
            case 1:
            {
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"SavedSearchResults" bundle:nil];
                centerViewController = [storyBoard instantiateViewControllerWithIdentifier:@"SavedSearchResultsView"];
            }
                break;
            case 2:
            {
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Alerts" bundle:nil];
                centerViewController = [storyBoard instantiateViewControllerWithIdentifier:@"AlertsView"];
            }
                break;
            case 3:
            {
                NSString* url = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=123"];
                NSArray *data = @[url];
                UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:data applicationActivities:nil];
                [self presentViewController:vc animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    } else if (indexPath.section == 2){
        switch (indexPath.row) {
            case 0:
            {
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"signin" bundle:nil];
                centerViewController = [storyBoard instantiateViewControllerWithIdentifier:@"signinView"];
            }
                break;
            case 1:
            {
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
                centerViewController = [storyBoard instantiateViewControllerWithIdentifier:@"settingsView"];
            }
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

-(void)ShowMapView
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MapSearch" bundle:nil];
    UIViewController *centerViewController = [storyBoard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self.mm_drawerController setCenterViewController:centerViewController withCloseAnimation:YES completion:nil];
}
-(void)showHottestPropertiesView
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"HottestProperty" bundle:nil];
    UIViewController *centerViewController = [storyBoard instantiateViewControllerWithIdentifier:@"HottestPropertyView"];
    [self.mm_drawerController setCenterViewController:centerViewController withCloseAnimation:YES completion:nil];
}

@end
