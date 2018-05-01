//
//  SMTabBarViewController.m
//  SwissMonkey
//
//  Created by Expert Software Dev on 3/5/18.
//  Copyright © 2018 rapidBizApps. All rights reserved.
//

#import "SMTabBarViewController.h"
#import "SMJobResultsVC.h"
#import "UIView+InnerShadow.h"

@interface SMTabBarViewController () {
    UIButton *lastSelectedBtn;
}

@end

@implementation SMTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Customize the tab bar buttons
    [self customizeTabbarButtons];
    
    //Select the first button
    UIButton *btn = [self.view viewWithTag:111];
    [btn setBackgroundColor:[UIColor colorWithRed:80./200. green:91./255. blue:104./255. alpha:1.]];
    [ReusedMethods applyTopBorderIndicator:btn];
    lastSelectedBtn = btn;
    
    //apply the shadow
    
    [ReusedMethods applyShadowToView:_buttonContainerView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Update UI

- (void)customizeTabbarButtons {
    UIButton *btn;
    
    btn = [self.view viewWithTag:111];
    btn.backgroundColor = [UIColor whiteColor];
    btn = [self.view viewWithTag:222];
    btn.backgroundColor = [UIColor whiteColor];
    btn = [self.view viewWithTag:333];
    btn.backgroundColor = [UIColor whiteColor];
    btn = [self.view viewWithTag:444];
    btn.backgroundColor = [UIColor whiteColor];
}
- (IBAction)clickedTabbar:(id)sender {
    
    if (lastSelectedBtn) {
        lastSelectedBtn.backgroundColor = [UIColor whiteColor];
        [ReusedMethods removeTopBorder:lastSelectedBtn];
    }
    
    UIButton *btn = (UIButton *)sender;
    [btn setBackgroundColor:[UIColor colorWithRed:80./200. green:91./255. blue:104./255. alpha:1.]];
    [ReusedMethods applyTopBorderIndicator:btn];
    
    lastSelectedBtn = btn;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *targetVC = [segue destinationViewController];
    
    if ([segue.identifier isEqualToString:@"viewController2"]) { //Jobs for you
        SMJobResultsVC *jobResultVC = (SMJobResultsVC*)targetVC;
        [jobResultVC setTypeResults:1];
    }
    else if ([segue.identifier isEqualToString:@"viewController3"]) { //Saved Jobs
        SMJobResultsVC *jobResultVC = (SMJobResultsVC*)targetVC;
        [jobResultVC setTypeResults:2];
    }
    else if ([segue.identifier isEqualToString:@"viewController4"]) { //Application Status
//        SMJobResultsVC *jobResultVC = (SMJobResultsVC*)targetVC;
//        [jobResultVC setTypeResults:3];
    }
//
//    [(UINavigationController*)self.destinationViewController popToRootViewControllerAnimated:YES];
}

@end
