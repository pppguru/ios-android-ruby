//
//  SMHomeBottomVC.m
//  SwissMonkey
//
//  Created by Kasturi on 06/01/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "SMHomeBottomVC.h"
#import "SMJobResultsVC.h"

@implementation SMHomeBottomVC
@synthesize jobsForYouButton,applicationStatusButton,jobHistoryButton,savedJobsButton;

- (void) viewDidAppear:(BOOL)animated{
   
    [super viewDidAppear:animated];
    
    [self  updatUI];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self clearAllButtonBGColor];
}

- (void) updatUI{
//    for (int i  =  603; i <= 606; i++) {
//        UIButton *  button  =  (UIButton *)  [self.view viewWithTag:i];
//        [button.titleLabel setTextColor:[UIColor appWhiteColor]];
//        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
//        [button.titleLabel setNumberOfLines:0];
//        [button.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
//        [button.layer setBorderWidth:8.0f];
//        [button.layer setBorderColor:[UIColor clearColor].CGColor];
//        [button.layer setCornerRadius:5.0f];
//        [button.layer setMasksToBounds:YES];
////        button.layer.borderWidth
//    }
    
    [jobsForYouButton setBackgroundColor:[UIColor clearColor]];
    [jobsForYouButton.layer setBorderWidth:1.0f];
    [jobsForYouButton.layer setBorderColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0].CGColor];
    [jobsForYouButton.layer setCornerRadius:5.0f];
    
//    [jobsForYouButton setTitle:@"" forState:UIControlStateNormal];
//    [[jobsForYouButton titleLabel] setText:@"JOBS FOR YOU"];
//        [jobsForYouButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 30)];
//    jobsForYouButton.titleLabel.numberOfLines = 0;
//    [jobsForYouButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
//    [jobsForYouButton.titleLabel  setTextColor:[UIColor redColor]];
    
    [applicationStatusButton setBackgroundColor:[UIColor clearColor]];
    [applicationStatusButton.layer setBorderWidth:1.0f];
    [applicationStatusButton.layer setBorderColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0].CGColor];
    [applicationStatusButton.layer setCornerRadius:5.0f];
    
    [jobHistoryButton setBackgroundColor:[UIColor clearColor]];
    [jobHistoryButton.layer setBorderWidth:1.0f];
    [jobHistoryButton.layer setBorderColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0].CGColor];
    [jobHistoryButton.layer setCornerRadius:5.0f];
    
    [savedJobsButton setBackgroundColor:[UIColor clearColor]];
    [savedJobsButton.layer setBorderWidth:1.0f];
    [savedJobsButton.layer setBorderColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0].CGColor];
    [savedJobsButton.layer setCornerRadius:5.0f];
}


- (IBAction)jobsForYouButtonAction:(id)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self  updateBottomButtonsStatusWithSender:sender title:@"Jobs For You" method:METHOD_JOBS];
}
- (IBAction)applicationStatusButtonAction:(id)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self  updateBottomButtonsStatusWithSender:sender title:@"Application Status" method:METHOD_APPLICATIONS];
}
- (IBAction)jobHistoryButtonAction:(id)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self  updateBottomButtonsStatusWithSender:sender title:@"Job History" method:METHOD_HISTORY];
}
- (IBAction)savedJobsButtonAction:(id)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self  updateBottomButtonsStatusWithSender:sender title:@"Saved Jobs" method:METHOD_SAVEDJOBS];
}

- (IBAction)closeAction:(UIButton *)sender {
    [super hideMenuViewControllerAnimated:YES];
}

- (void) clearAllButtonBGColor{
    
    [jobsForYouButton setBackgroundColor:[UIColor clearColor]];
    [applicationStatusButton setBackgroundColor:[UIColor clearColor]];
    [jobHistoryButton setBackgroundColor:[UIColor clearColor]];
    [savedJobsButton setBackgroundColor:[UIColor clearColor]];
    
    [jobsForYouButton  setTitleColor:[UIColor colorWithRed:98/255.0 green:98/255.0 blue:98/255.0 alpha:1.0] forState:UIControlStateNormal];
    [applicationStatusButton  setTitleColor:[UIColor colorWithRed:98/255.0 green:98/255.0 blue:98/255.0 alpha:1.0] forState:UIControlStateNormal];
    [jobHistoryButton  setTitleColor:[UIColor colorWithRed:98/255.0 green:98/255.0 blue:98/255.0 alpha:1.0] forState:UIControlStateNormal];
    [savedJobsButton  setTitleColor:[UIColor colorWithRed:98/255.0 green:98/255.0 blue:98/255.0 alpha:1.0] forState:UIControlStateNormal];
}

- (void)  updateBottomButtonsStatusWithSender:(id) sender title:(NSString *)titleString method:(NSString *)methodName{
    if(![ReusedMethods isZipCodeAvailable])
    {
        RBACustomAlert *alert = [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"We recommend to update your profile for better search result." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert setTag:12];
        [alert show];
        return;
    }
    

    [self clearAllButtonBGColor];
    _titleString = titleString;
    [sender  setBackgroundColor:[UIColor appGreenColor]];
    [(UIButton *)sender  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
//    NSString * titleString = nil;
//    
//    switch ([sender tag] % 10) {
//        case 3:
//            titleString = @"Jobs for you";
//            break;
//        case 4:
//            titleString = @"Application Status";
//            break;
//        case 5:
//            titleString = @"Job history";
//            break;
//        case 6:
//            titleString = @"Saved Jobs";
//            break;
//            
//        default:
//            break;
//    }
    
    APIObject * reqObject = [[APIObject alloc] initWithMethodName:methodName ModuleName:MODULE_JOBS MethodType:METHOD_TYPE_POST Parameters:nil SuccessCallBack:@selector(apiCallSuccess:) AndFailureCallBack:@selector(apiCallFailed:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
    [service makeWebServiceCall];
    
    [self performSelector:@selector(clearAllButtonBGColor) withObject:nil afterDelay:3.0];
}

- (void) navigate2Jobresult:(NSArray *)jobs{
    AppDelegate * appDelegate  =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    SMJobResultsVC * smJobResultsVC =  [self.storyboard  instantiateViewControllerWithIdentifier:SM_JOBRESULTS_VC];
    [self closeAction:nil];
    smJobResultsVC.viewTitleString  =  _titleString;
    smJobResultsVC.arrayJobs = _jobs;
    smJobResultsVC.savedJobs = jobs;
    [appDelegate.navController  pushViewController:smJobResultsVC animated:YES];
}

- (void) apiCallSuccess:(WebServiceCalls *)server{
    _jobs = [server.responseData objectForKey:@"jobs"];
    APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_SAVEDJOBS ModuleName:MODULE_JOBS MethodType:METHOD_TYPE_POST Parameters:nil SuccessCallBack:@selector(apiSavedCallSuccess:) AndFailureCallBack:@selector(apiSavedCallFailed:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
   // [service makeWebServiceCall];
    
    [self navigate2Jobresult:[server.responseData objectForKey:@"jobs"]];

    
}

- (void) apiCallFailed:(WebServiceCalls *)server{
    
}

- (void) apiSavedCallSuccess:(WebServiceCalls *)server{
    [self navigate2Jobresult:[server.responseData objectForKey:@"jobs"]];
    
}
- (void) apiSavedCallFailed:(WebServiceCalls *)server{
    
}

- (void) alertView:(RBACustomAlert *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 12){
        if(buttonIndex == alertView.cancelButtonIndex){
            
                        AppDelegate * appDelegate  =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        [self closeAction:nil];
                        SMProfileVC * smProfileVC =  [self.storyboard  instantiateViewControllerWithIdentifier:SM_PROFILE_VC];
                        [appDelegate.navController  pushViewController:smProfileVC animated:NO];
            //            appDelegate.navController.viewControllers = @[self.smSearchModel.profileVC];
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isHome"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber  numberWithBool:NO] forKey:@"isAdvancedSearch"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            
            
//            self.smSearchModel  =  [[SMSearchModel alloc] init];
//            AppDelegate * appDelegate  =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            [self closeAction:nil];
//            self.smSearchModel.profileVC =  [self.storyboard  instantiateViewControllerWithIdentifier:SM_PROFILE_VC];
//            //[appDelegate.navController  pushViewController:smProfileVC animated:NO];
//            appDelegate.navController.viewControllers = @[self.smSearchModel.profileVC];
//            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isHome"];
        }
    }
 
}


@end
