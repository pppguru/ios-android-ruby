//
//  SMHomeModel.m
//  SwissMonkey
//
//  Created by Kasturi on 24/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import "SMHomeModel.h"
#import "NotificationsTableCell.h"
#import "SMHelpVC.h"

@interface SMHomeModel ()<UITableViewDelegate, UITableViewDataSource>


@end

@implementation SMHomeModel{
    UITableView * autocompleteTableView;
   // NSMutableArray *notificationsListArray;
}

@synthesize homeVC,profileVC,userProfileDescriptionVC,settingsVC,logInVC,storyboard,userProfileDescriptionStoryboard,menuItems, notificationsTbleView, firstProfileVC;

#pragma mark - Custom Accessors

- (id) init{
    
    if(self){
    
        self  =  [super init];
        storyboard  =  [UIStoryboard storyboardWithName:SM_STORY_BOARD bundle:nil];
        userProfileDescriptionStoryboard  = [UIStoryboard storyboardWithName:SM_USER_PROFILE_DESCRIPTION_STORYBOARD bundle:nil];
        _notificationsListArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (JVMenuItems *)menuItems
{
    if(!menuItems)
    {
        menuItems = [[JVMenuItems alloc] initWithMenuImages:@[[UIImage imageNamed:@"home-1"],[UIImage imageNamed:@"profile"],[UIImage imageNamed:@"settings"],[UIImage imageNamed:@"about"], [UIImage imageNamed:@"logout"]] menuTitles:@[@"Welcome", @"Profile", @"Settings", @"Support", @"Sign Out" ] menuCloseButtonImage:[UIImage imageNamed:@"cross"]];
        
        menuItems.menuSlideInAnimation = YES;
    }
    
    return menuItems;
}


- (void)menuPopoverOfViewController:(UIViewController *) vc
{
    if(!_menuPopover)
    {
        _menuPopover = [[JVMenuPopoverView alloc] initWithFrame:vc.view.frame menuItems:self.menuItems];
        //_menuPopover.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [ReusedMethods  changeGradientColorForWindow:_menuPopover];
        _menuPopover.delegate = vc;
    }
}

//   saving  to navigation controllers.
- (SMHomeVC *)homeVC
{
    if (!homeVC)
    {
        homeVC = (SMHomeVC *)[storyboard  instantiateViewControllerWithIdentifier:SM_HOME_VC];
    }
    
    return homeVC;
}

- (SMProfileVC *)profileVC
{
    if (!profileVC)
    {
        profileVC = (SMProfileVC *)[storyboard  instantiateViewControllerWithIdentifier:SM_PROFILE_VC];
    }
    
    return profileVC;
}

- (SMScreenTitleButtonsVC *) firstProfileVC{
    if (!firstProfileVC){
        UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:@"SMAddProfileDetails" bundle:nil];
        firstProfileVC = (SMScreenTitleButtonsVC *)[profileStoryboard  instantiateViewControllerWithIdentifier:SM_ADD_PROFILE_FIRST_VC];
    }
    
    return firstProfileVC;
    
}

- (SMUserProfileDescriptionVC *) userProfileDescriptionVC
{
    if (!userProfileDescriptionVC)
    {
        userProfileDescriptionVC = (SMUserProfileDescriptionVC *)[userProfileDescriptionStoryboard  instantiateViewControllerWithIdentifier:SM_PROFILE_DESCRIPTION_VC];
    }
    
    return userProfileDescriptionVC;

}

- (SMSettingsVC *)settingsVC
{
    if (!settingsVC)
    {
        settingsVC = (SMSettingsVC *)[storyboard  instantiateViewControllerWithIdentifier:SM_SETTINGS_VC];
    }
    
    return settingsVC;
}

- (SMHelpVC *)helpVC
{
    if (!_helpVC)
    {
//        _helpVC = [[SMHelpVC alloc] init];
        _helpVC = (SMHelpVC *)[storyboard  instantiateViewControllerWithIdentifier:SM_HELP_VC];
    }
    
    return _helpVC;
}

- (SMLoginVC *)logInVC{
    if(!logInVC){
        logInVC  = (SMLoginVC *)[storyboard  instantiateViewControllerWithIdentifier:SM_LOGIN_VC];
    }
    return logInVC;
}

- (NSMutableArray *) getTotalPositionObjects{
    
    return   [[NSMutableArray alloc] initWithArray:@[@"0",@"00",@"0009090909093356735463765476357645675445567547568678",@"202",@"3",@"4"]];
}




#pragma mark - NOTIFICATIONS VIEW

- (void)  setUpNotificationsView{
    
    //  setup  BG view
    if(!_notiView)
    {
        float screenWidth  =  [UIScreen mainScreen].bounds.size.width;
        float screenHeight =  [UIScreen mainScreen].bounds.size.height;
        
        _notiView = [[NotificationView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        UIView *bGView  =  [[UIView alloc]  initWithFrame:CGRectMake(20, NAVIGATION_HEIGHT, screenWidth  -  (2 * 20), screenHeight/3 )];
        [bGView setTag:HOME_NOTIFICATIONVIEW_TAG];
        [bGView setBackgroundColor:[UIColor appGreenColor]];
        [[bGView layer] setCornerRadius:5.0f];
        [[bGView layer] setBorderColor:[UIColor clearColor].CGColor];
        [[bGView layer] setBorderWidth:1.0f];
        [[bGView layer]  setMasksToBounds:YES];
        
        bGView.layer.masksToBounds = NO;
        bGView.layer.shadowOffset = CGSizeMake(-15, 20);
        bGView.layer.shadowRadius = 5;
        bGView.layer.shadowOpacity = 0.5;
        
        UITableView *  tbleView  =  [[UITableView  alloc] initWithFrame:CGRectMake(20, 20, CGRectGetWidth(bGView.frame)  -  (2 * 20), CGRectGetHeight(bGView.frame) - 40)];
        [tbleView setBackgroundColor:[UIColor appGreenColor]];
        [tbleView setShowsVerticalScrollIndicator:NO];
        [tbleView setDelegate:self.delegate];
        [tbleView setDataSource:self.delegate];
        
        notificationsTbleView  = tbleView;
        
        [bGView addSubview:notificationsTbleView];
        [_notiView addSubview:bGView];
        
    }
    UIView *window = [(AppDelegate *)[[UIApplication sharedApplication] delegate] window];
    [window addSubview:_notiView];
}


- (void) makeServerCallForSavedJobs{
    APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_SAVEDJOBS ModuleName:MODULE_JOBS MethodType:METHOD_TYPE_POST Parameters:nil SuccessCallBack:@selector(serverCallSavedJobsSuccessRespone:) AndFailureCallBack:@selector(serverCallSavedJobsFailureRespone:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
    [service makeWebServiceCall];
}

#pragma mark - Saved Jobs Call Back Method

-(void)serverCallSavedJobsSuccessRespone:(WebServiceCalls *)service
{
    [_delegate serverCallSavedJobsSuccessRespone:service.responseData];
}

-(void)serverCallSavedJobsFailureRespone:(WebServiceCalls *)service
{
    NSString *string = nil;
    @try {
        string = [service.responseError.userInfo objectForKey:@"NSLocalizedDescriptionKey"];
    }
    @catch (NSException *exception) {
    }
    @finally {
        if(!string)
            string = [service.responseData objectForKey:@"error"];
        if(string.length  ==  0){
            string  =  @"something went wrong.";
        }
        [_delegate serverCallSavedJobsFailureRespone:string];
    }
}



#pragma mark - TABLE  VIEW  DELEGATE  METHODS

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ReusedMethods setSeperatorProperlyForCell:cell];
}


- (NSInteger)  tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _notificationsListArray.count;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *  cellIdendifier  =  [NSString  stringWithFormat:@"Cell %@",@"NotificationsTableCell"];
    
    NotificationsTableCell  *cell =  [tableView dequeueReusableCellWithIdentifier:cellIdendifier];
    if(!cell){
        
        cell  =  [[NotificationsTableCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdendifier frameWidth:tableView.frame.size.width];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [tableView  setSeparatorColor:[UIColor appWhiteColor]];
    
    
    if(_notificationsListArray.count){
    [cell  setUpNotificationData:[_notificationsListArray objectAtIndex:indexPath.row]];
    [cell adjustCellFramesWithInfo:[_notificationsListArray objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    float  height =  30 ;
    
    NSString *  cellIdendifier  =  [NSString  stringWithFormat:@"Cell %@",@"NotificationsTableCell"];
    
    NotificationsTableCell  *cell =  [tableView dequeueReusableCellWithIdentifier:cellIdendifier];
    if(!cell){
        
        cell  =  [[NotificationsTableCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdendifier frameWidth:tableView.frame.size.width];
    }
    
    @try {
        height  =  [cell getCellHeightWithDict:[_notificationsListArray objectAtIndex:indexPath.row]];
        return height;
    }
    @catch (NSException *exception) {
        
        return 30;
    }
}
#pragma mark - NOTIFICATIONS LIST

- (void)makeApiCallForNotificationsList{
    
  //  NSLog(@"   push  notification status  %hhd", [[UIApplication sharedApplication] isRegisteredForRemoteNotifications]);
    if(![[UIApplication sharedApplication] isRegisteredForRemoteNotifications]){
        return;
    }
    
    APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_NOTIFICATIONS ModuleName:MODULE_SETTINGS MethodType:METHOD_TYPE_POST Parameters:nil SuccessCallBack:@selector(notificationsListApiSuccess:) AndFailureCallBack:@selector(notificationsApiFailed:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
    service.isLoaderHidden  =  YES;
    [service makeWebServiceCall];
}

- (void) notificationsListApiSuccess:(WebServiceCalls *) service{
    
    NSDictionary * dropDownData = [service responseData];
    NSMutableArray *notificationsArray = [[NSMutableArray alloc] init];
    [notificationsArray removeAllObjects];
    [notificationsArray addObjectsFromArray:[dropDownData objectForKey:@"success"]];
    
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"updated_at" ascending:NO];
    NSArray *descriptors=[NSArray arrayWithObject: descriptor];
    NSArray *reverseOrder=[notificationsArray sortedArrayUsingDescriptors:descriptors];
    [_notificationsListArray removeAllObjects];
    [_notificationsListArray addObjectsFromArray:reverseOrder];
    
    if(_notificationsListArray.count){
    [autocompleteTableView reloadData];
    }
    [_delegate notificationSuccessCall];
    
}

- (void) notificationsApiFailed:(NSError *)error{
//    if([error isKindOfClass:[NSError class]]){
//        
//        RBACustomAlert  * alert  =  [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:[error.userInfo objectForKey:@"NSLocalizedDescriptionKey"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    }
}

- (void) notificationSuccessCall{
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    NSLog(@"touches began");
    UITouch *touch = [touches anyObject];
    if(touch.view!=autocompleteTableView){
        autocompleteTableView.hidden = YES;
    }
}

# pragma mark - GET DROP DOWNLIST DATA


- (void) callDropDownListMethods{
    
    [self  makeApiCallForDropDownListForSignUpPositionField];
}

- (void)makeApiCallForDropDownListForSignUpPositionField{
    
    APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_DROPDOWNDATA ModuleName:MODULE_DROPDOWN MethodType:METHOD_TYPE_GET Parameters:nil SuccessCallBack:@selector(dropDownListApiSuccess:) AndFailureCallBack:@selector(dropDownListApiFailed:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
    service.isLoaderHidden  =  YES;
    [service makeWebServiceCall];
}

- (void) dropDownListApiSuccess:(WebServiceCalls *) service{
    
    NSDictionary * dropDownData = [service responseData];
    [[ReusedMethods sharedObject].dropDownListDict addEntriesFromDictionary:dropDownData];
    
    //Apply the new filtering
    [ReusedMethods applyTextFilteringForCompensationPreferences];
}

- (void) dropDownListApiFailed:(NSError *)error{
    if([error isKindOfClass:[NSError class]]){
        
        RBACustomAlert  * alert  =  [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:[error.userInfo objectForKey:@"NSLocalizedDescriptionKey"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}






@end
