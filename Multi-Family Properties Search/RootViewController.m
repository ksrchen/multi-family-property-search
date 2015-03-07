//
//  RootViewController.m
//  Multi-Family Properties Search
//
//  Created by Kevin Chen on 3/7/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "RootViewController.h"
#import "User.h"
#import "UserDataStore.h"   
#import "PropertyDataStore.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //do the inital load to the the my listing count;
    [self reloadMyListing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMyListing) name:@"MyListingUpdated" object:nil];

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

-(void)reloadMyListing{
    User * user = [[UserDataStore getInstance] getUser];
    
    [[PropertyDataStore getInstance] getMyListingForUser:  user.UserID
                                                 success:^(NSURLSessionDataTask *task, NSMutableArray *properties) {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         NSUInteger count = [properties count];
                                                         UITabBarItem *  tabBarItem = [[[self tabBar] items] objectAtIndex:2];
                                                         if (count>0){
                                                             tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu", (unsigned long)count];
                                                         }else{
                                                             tabBarItem.badgeValue = nil;
                                                         }
                                                     });
                                                     
                                                 }
                                                 failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                     
                                                 }];
    
    
}


@end
