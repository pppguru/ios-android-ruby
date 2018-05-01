//
//  SMHomeVC.m
//  SwissMonkey
//
//  Created by Kasturi on 24/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import "SMHomeVC.h"
#import "SMProfileVC.h"
#import "SMUserProfileDescriptionVC.h"
#import "SMAddProfileDetailsVC.h"
#import "SMSettingsVC.h"
#import "SMLoginVC.h"
#import "SMJobResultsVC.h"
#import "SMSearchVC.h"

@interface SMHomeVC () <UINavigationControllerDelegate, JVMenuPopoverDelegate, SMHomeModelDelegate>

@property (nonatomic, strong) CAGradientLayer *gradient;

@end

@implementation SMHomeVC{
    BOOL isAdvancedSearch;
}


@synthesize jobsForYouButton,applicationStatusButton,jobHistoryButton,savedJobsButton,smHomeModel,searchButton;

- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self  updatUI];
}



#pragma mark - LIFE CYCLE  METHODS

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self commonInit];
    // [self  updateUI];
    
    if(![[[ReusedMethods sharedObject].dropDownListDict allKeys] count])
        [smHomeModel callDropDownListMethods];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isHome"] boolValue]){
        
        if ([ReusedMethods isAccountInActive]) {
            [smHomeModel makeApiCallForNotificationsList];
        }
        
        NSString * titleString  = @"Welcome";// isAdvancedSearch  ? @"Advanced Search"  :  @"Welcome";
        NSString *  imagName  = @"nav_menu_toggle"; // isAdvancedSearch  ?  @"back" : @"menu";
        NSInteger  notificationCount  =  isAdvancedSearch  ?  0  :  smHomeModel.notificationsListArray.count;
        NSString * rightImgname  = isAdvancedSearch  ? @"" :  @"alert_btn";
        
        NSInteger   previousNotificationCount =  [[[NSUserDefaults  standardUserDefaults] objectForKey:USER_NOTIFICATIONS_COUNT] intValue];
        
        notificationCount  =  notificationCount  -  (int) previousNotificationCount;
        
        // set  up  navigation  view  on the  view
        // [ReusedMethods setNavigationViewOnView:self.view WithTitle:titleString andBackgroundColor:isAdvancedSearch  ? [UIColor appBrightNavColor]: [UIColor applightNavColor]];
        [ReusedMethods setNavigationViewOnView:self.view WithTitle:titleString andBackgroundColor:[UIColor whiteColor]];
        [ReusedMethods setUpLeftButton:self withImageName:imagName];
        [ReusedMethods setUpRightButton:self withImageName:rightImgname withNotificationsCount:notificationCount];
        [self.menuButton addTarget:self action:@selector(navViewLeftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // call  notifications  method for display
}

#pragma mark - Menu Helper Functions
- (void)commonInit{
    smHomeModel  =  [[SMHomeModel alloc] init];
    smHomeModel.delegate  = self;
    [smHomeModel menuPopoverOfViewController:self];
    //[self setAllDefaultData2Dict];
}



#pragma mark  -  BUTTON ACTIONS

- (IBAction)navViewLeftButtonAction:(id)sender{
    if(isAdvancedSearch){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isAdvancedSearch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [ReusedMethods checkAppFlow];
    }
    else{
        [self.view endEditing:YES];
        [[SlideNavigationController sharedInstance] toggleLeftMenu];
    }
}

- (IBAction)navViewRightButtonAction:(id)sender{
    if(smHomeModel.notificationsListArray.count == 0){
        RBACustomAlert  * alert  =  [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"No notifications to display" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }else{
        NSString * titleString  = isAdvancedSearch  ? @"Advanced Search"  :  @"Welcome";
        NSString *  imagName  =  isAdvancedSearch  ?  @"back" : @"nav_menu_toggle";
        int  notificationCount  =  0; //isAdvancedSearch  ?  0  : (int) smHomeModel.notificationsListArray.count ;
        NSString * rightImgname  = isAdvancedSearch  ? @"" :  @"alert_btn";
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:smHomeModel.notificationsListArray.count] forKey:USER_NOTIFICATIONS_COUNT];
        
        //Removing navigation view from view
        for (UIView *navView in self.view.subviews) {
            if (navView.tag == NAVIGATION_VIEW_TAG||navView.tag == LEFT_BUTTON_TAG||navView.tag == RIGHT_BUTTON_TAG) {
                [navView removeFromSuperview];
            }
        }
        
        // set  up  navigation  view  on the  view
        [ReusedMethods setNavigationViewOnView:self.view WithTitle:titleString andBackgroundColor:[UIColor whiteColor]];
        [ReusedMethods setUpLeftButton:self withImageName:imagName];
        [ReusedMethods setUpRightButton:self withImageName:rightImgname withNotificationsCount:notificationCount];
        [self.menuButton addTarget:self action:@selector(navViewLeftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    [smHomeModel setUpNotificationsView];
    //  notifications  stuff
    //    UIView *  notificationView  = [smHomeModel setUpNotificationsView];
    //    [self.view addSubview:notificationView];
}


#pragma mark - MENU DELEGATE  METHODS

- (void)menuPopoverDidSelectViewControllerAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        self.navigationController.viewControllers = @[smHomeModel.homeVC];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isHome"];
    }
    else if (indexPath.row == 1)
    {
        // change  based  on  requirement
        //        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //        BOOL firstTime = [userDefaults boolForKey:@"firstTime"];
        if(![ReusedMethods isProfileFilled])
            self.navigationController.viewControllers = @[smHomeModel.profileVC];
        else
            self.navigationController.viewControllers  = @[smHomeModel.userProfileDescriptionVC];
        //            self.navigationController.viewControllers = @[smHomeModel.firstProfileVC];
        
        //        [userDefaults setBool:NO forKey:@"firstTime"];
        //        [userDefaults synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isHome"];
        
        // self.navigationController.viewControllers  = @[smHomeModel.userProfileDescriptionVC];
        //[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isHome"];
    }
    else if (indexPath.row == 2)
    {
        self.navigationController.viewControllers = @[smHomeModel.settingsVC];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isHome"];
    }
    else if (indexPath.row == 3)
    {
        self.navigationController.viewControllers = @[smHomeModel.helpVC];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isHome"];
    }
    else if (indexPath.row  ==  4)
    {
        //        self.navigationController.viewControllers = @[smHomeModel.logInVC];
        RBACustomAlert * alert = [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"Are you sure want to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert setTag:112];
        [alert show];
    }
}


- (void) alertView:(RBACustomAlert *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1)
    {
        //Logout user
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isHome"];
        [ReusedMethods logout];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


#pragma mark - TABLE VIEW DELEGATE METHODS

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [smHomeModel  tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

- (NSInteger)  tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [smHomeModel tableView:tableView numberOfRowsInSection:section];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [smHomeModel numberOfSectionsInTableView:tableView];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [smHomeModel tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [smHomeModel tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [self moveToJobResultsVC];
    // [[tableView  superview]  removeFromSuperview];
}

- (void) moveToJobResultsVC{
    SMJobResultsVC *smJobResultsVC  =  [self.storyboard  instantiateViewControllerWithIdentifier:SM_JOBRESULTS_VC];
    smJobResultsVC.viewTitleString = @"Job Results";
    smJobResultsVC.arrayJobs = _jobs;
    smJobResultsVC.savedJobs = _savedJobs;
    [self.navigationController  pushViewController:smJobResultsVC animated:YES];
}

#pragma mark - Model Delegate Methods

-(void)serverCallSuccessRespone:(NSDictionary *)jobDict{
    _jobs = nil;
    _jobs = [jobDict objectForKey:@"jobs"];
    if(_jobs.count){
        [smHomeModel makeServerCallForSavedJobs];
    }
    else{
        [[[RBACustomAlert alloc] initWithTitle:@"Jobs not found" message:@"No jobs found with this search criteria, please try with another search criteria" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

-(void)serverCallSavedJobsSuccessRespone:(NSDictionary *)jobDict{
    _savedJobs = nil;
    _savedJobs = [jobDict objectForKey:@"jobs"];
    [self moveToJobResultsVC];
}

-(void)serverCallSavedJobsFailureRespone:(NSString *)error{
    
}

-(void)serverCallFailureRespone:(NSString *)error{
    [[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:error delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

// notifications

- (void) notificationSuccessCall{
    
    NSString * titleString  = isAdvancedSearch  ? @"Advanced Search"  :  @"Welcome";
    NSString *  imagName  =  isAdvancedSearch  ?  @"back" : @"menu";
    int  notificationCount  =  isAdvancedSearch  ?  0  : (int) smHomeModel.notificationsListArray.count ;
    NSString * rightImgname  = isAdvancedSearch  ? @"" :  @"alert_btn";
    
    
    NSInteger   previousNotificationCount =  [[[NSUserDefaults  standardUserDefaults] objectForKey:USER_NOTIFICATIONS_COUNT] intValue];
    
    notificationCount  =  notificationCount  -  (int) previousNotificationCount;
    //    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:smHomeModel.notificationsListArray.count] forKey:USER_NOTIFICATIONS_COUNT];
    
    //Removing navigation view from view
    for (UIView *navView in self.view.subviews) {
        if (navView.tag == NAVIGATION_VIEW_TAG||navView.tag == LEFT_BUTTON_TAG||navView.tag == RIGHT_BUTTON_TAG) {
            [navView removeFromSuperview];
        }
    }
    
    // set  up  navigation  view  on the  view
    [ReusedMethods setNavigationViewOnView:self.view WithTitle:titleString andBackgroundColor:[UIColor whiteColor]];
    [ReusedMethods setUpLeftButton:self withImageName:imagName];
    [ReusedMethods setUpRightButton:self withImageName:rightImgname withNotificationsCount:notificationCount];
    [self.menuButton addTarget:self action:@selector(navViewLeftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark  - HOME SCREEN BUTTON ACTIONS

- (void) updatUI{
    jobHistoryButton.tag  = HOME_BOTTOM_JOBHISTORY_TAG;
    jobsForYouButton.tag  =  HOME_BOTTOM_JOBSFORYOU_TAG;
    applicationStatusButton.tag  =  HOME_BOTTOM_APPLICATION_STATUS_TAG;
    savedJobsButton.tag  = HOME_BOTTOM_SAVEDJOBS_TAG;
    searchButton.tag  =  HOME_BOTTOM_SEARCH_BUTTON_TAG;
    
    for (int i  =  603; i <= 607; i++) {
        UIButton *  button  =  (UIButton *)  [self.view viewWithTag:i];
        [button.titleLabel setTextColor:[UIColor appWhiteColor]];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [button.titleLabel setNumberOfLines:0];
        [button.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [button.layer setBorderWidth:8.0f];
        [button.layer setBorderColor:[UIColor clearColor].CGColor];
        [button.layer setCornerRadius:5.0f];
        [button.layer setMasksToBounds:YES];
        [[button titleLabel] setFont:[UIFont appNormalTextFont]];
    }
}
- (IBAction)searchButtonAction:(id)sender{
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isAdvancedSearch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    SMSearchVC * smSearchVC =  [self.storyboard instantiateViewControllerWithIdentifier:SM_SEARCH_VC];
    [self.navigationController pushViewController:smSearchVC animated:YES];
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

- (void)  updateBottomButtonsStatusWithSender:(id) sender title:(NSString *)titleString method:(NSString *)methodName{
    //    [jobsForYouButton setBackgroundColor:[UIColor clearColor]];
    //    [applicationStatusButton setBackgroundColor:[UIColor clearColor]];
    //    [jobHistoryButton setBackgroundColor:[UIColor clearColor]];
    //    [savedJobsButton setBackgroundColor:[UIColor clearColor]];
    _titleString = titleString;
    // [sender  setBackgroundColor:[UIColor appPinkColor]];
    
    if (![ReusedMethods isAccountInActive]) {
        [[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:ACCOUNT_DEACTIVATED_MESSAGE delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    APIObject * reqObject = [[APIObject alloc] initWithMethodName:methodName ModuleName:MODULE_JOBS MethodType:METHOD_TYPE_POST Parameters:nil SuccessCallBack:@selector(apiCallSuccess:) AndFailureCallBack:@selector(apiCallFailed:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
    [service makeWebServiceCall];
}

- (void) navigate2Jobresult{
    AppDelegate * appDelegate  =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    SMJobResultsVC * smJobResultsVC =  [self.storyboard  instantiateViewControllerWithIdentifier:SM_JOBRESULTS_VC];
    [self closeAction:nil];
    smJobResultsVC.viewTitleString  =  _titleString;
    smJobResultsVC.arrayJobs = _jobs;
    smJobResultsVC.savedJobs = _savedJobs;
    [appDelegate.navController  pushViewController:smJobResultsVC animated:YES];
}

- (void) apiCallSuccess:(WebServiceCalls *)server{
    _jobs = [server.responseData objectForKey:@"jobs"];
    
    APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_SAVEDJOBS ModuleName:MODULE_JOBS MethodType:METHOD_TYPE_POST Parameters:nil SuccessCallBack:@selector(apiSavedCallSuccess:) AndFailureCallBack:@selector(apiSavedCallFailed:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
    [service makeWebServiceCall];
}

- (void) apiCallFailed:(WebServiceCalls *)server{
    
}

- (void) apiSavedCallSuccess:(WebServiceCalls *)server{
    _savedJobs = [server.responseData objectForKey:@"jobs"];
    [self navigate2Jobresult];
}

- (void) apiSavedCallFailed:(WebServiceCalls *)server{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    if (aTouch.tapCount == 1)
    {
        // CGPoint p = [aTouch locationInView:self];
        for (UIView *aView in self.view.subviews) {
            if (([aView isKindOfClass:[UIView class]]) && ([aView tag] == HOME_NOTIFICATIONVIEW_TAG )) //&&(!CGRectContainsPoint(aView.frame, p)))
            {
                [aView removeFromSuperview];
            }
            
        }
    }
}


#pragma mark - Slide Menu Display
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}




@end
