//
//  HottestPropertyContainerViewController.m
//  Chrometopia
//
//  Created by Kevin Chen on 7/11/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "HottestPropertyContainerViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "PGSideDrawerController.h"

@interface HottestPropertyContainerViewController ()

@end

@implementation HottestPropertyContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupLeftMenuButton];
    [self setTitle:@"Hottest Properties"];
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

- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)setupLeftMenuButton {
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItems:@[leftDrawerButton]];
}


- (IBAction)sortTapped:(id)sender {
}

- (IBAction)mapTapped:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_MAP object:self];
}
@end
