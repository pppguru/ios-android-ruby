//
//  SMAddProfileDetailsVC.m
//  SwissMonkey
//
//  Created by Kasturi on 1/27/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "SMAddProfileDetailsVC.h"

@implementation SMAddProfileDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // set  up  navigation  view  on the  view
    [ReusedMethods setNavigationViewOnView:self.view WithTitle:@"Profile" andBackgroundColor:[UIColor whiteColor]];
    [ReusedMethods setUpLeftButton:self withImageName:@"nav_menu_toggle"];
   // [ReusedMethods setUpRightButton:self withImageName:@"home" withNotificationsCount:0];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

#pragma mark - BUTTON ACTION METHODS

//- (IBAction)navViewRightButtonAction:(id)sender{
//    [self.navigationController  popViewControllerAnimated:YES];
//    
//}

//- (IBAction) navViewLeftButtonAction:(id)sender{
//   [self.navigationController  popViewControllerAnimated:YES];
//}




@end
