//
//  ReusedMethods.m
//  SwissMonkey
//
//  Created by Kasturi on 23/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import "ReusedMethods.h"
#import "SMLoginVC.h"
#import "SMHomeVC.h"
#import  "SMUserProfileDescriptionVC.h"
//#import <AdSupport/AdSupport.h>
#import <AVFoundation/AVFoundation.h>
#import "UIView+InnerShadow.h"

static ReusedMethods * sharedObject;
static UIView * darkGrayView;

@interface ReusedMethods ()

@end

@implementation ReusedMethods

@synthesize dropDownListDict;

+(ReusedMethods *) sharedObject{
    if(!sharedObject){
        sharedObject  =  [[ReusedMethods alloc] init];
        sharedObject.dropDownListDict  =  [[NSMutableDictionary alloc] init];
        sharedObject.userProfileInfo =  [[NSMutableDictionary alloc] init];
    }
    return sharedObject;
}

+ (void) setupDeviceModel{
    CGRect frame = [UIScreen mainScreen].bounds;
    float deviceWidth = CGRectGetWidth( frame );
    float deviceHeight = CGRectGetHeight( frame );
    if(deviceHeight < 500){
        sharedObject.dModel = kDeviceModeliPhone4;
        NSLog(@"Present Device Model is iPhone 4 / 4S");
    }
    else if (deviceWidth == 320){
        sharedObject.dModel = kDeviceModeliPhone5;
        NSLog(@"Present Device Model is iPhone 5 / 5C / 5S / 5SE");
    }
    else if (deviceWidth == 375 && deviceHeight == 667){
        sharedObject.dModel = kDeviceModeliPhone6;
        NSLog(@"Present Device Model is iPhone 6 / 6S");
    }
    else if (deviceWidth == 414 && deviceHeight == 736){
        sharedObject.dModel = kDeviceModeliPhone6;
        NSLog(@"Present Device Model is iPhone 6 Plus / 6S Plus");
    }
    else
    {
        sharedObject.dModel = kDeviceModelUnKnown;
        NSLog(@"Present Device Model is UNKNOWN");
    }
}

+ (DeviceModel) deviceModel{
    return sharedObject.dModel;
}

+(void)setSeperatorProperlyForCell:(UITableViewCell *)cell
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        //[cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 20)];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        //[cell setLayoutMargins:UIEdgeInsetsZero];
        [cell  setLayoutMargins:UIEdgeInsetsMake(0, 20, 0, 20)];
    }
}

// moveback to particular VC
+ (void) moveToViewController:(Class)className andNavigationController:(UINavigationController *) navController{
    for (UIViewController * VC  in  navController.viewControllers)  {
        if([VC isKindOfClass:className] ){
            
            [navController  pushViewController:VC animated:YES];
        }
    }
    
}

// pop up set up method

+ (void) setupPopUpViewForTextField:(UITextField *) currentTxtFld
                   withDisplayArray:(NSMutableArray *) displayObjectsArray
                            withDel:(id)delegate
                         displayKey:(NSString *) keyString
                          returnKey:(NSString *) returnKey
                            withTag:(int) tag
                      isMultiSelect:(BOOL)isMulti
                   selectedPosItems:(NSArray *)selectedPosItems  {
    
    // remove keyboard exists
    [self dismissKeyboardonView:[currentTxtFld superview]];
    
    if (isMulti) {
        [ReusedMethods addMultiplePopupViewWithVC:delegate
                                        dataArray:displayObjectsArray
                                          dataKey:keyString
                                           idName:returnKey
                                        textField:currentTxtFld
                                 andSelectedItems:selectedPosItems
                                          withTag:tag];
    }
    else {
        UIView * popUpView  =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 200)];
        [popUpView setBackgroundColor:[UIColor appWhiteColor]];
        
        // search bar implementation
        UISearchBar *search = [[UISearchBar alloc] init];
        [search setTintColor:[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0]];
        search.frame = CGRectMake(0, 0,CGRectGetWidth(popUpView.frame) ,40);
        [popUpView addSubview:search];
        
        // set up tableView
        UITableView * popUpTbleVw  =  [[UITableView  alloc] initWithFrame:CGRectMake(0, 40,CGRectGetWidth(popUpView.frame),160)];
        [popUpView addSubview:popUpTbleVw];
        
        //  window  object to display the popup view
        UIWindow *  window  =  [[[UIApplication sharedApplication] delegate] window];
        
        // rba popup setup
        if (!isMulti) {
            RBAPopup *searchPopUp  =  [[RBAPopup alloc] initWithCustomView:popUpView];
            [searchPopUp presentPointingAtView:currentTxtFld inView:window animated:YES];
            searchPopUp.textFeild  =  currentTxtFld;
            searchPopUp.allData =  [[NSMutableArray alloc] initWithArray:displayObjectsArray];
            searchPopUp.contactsArray = [[NSMutableArray alloc] initWithArray:displayObjectsArray];
            searchPopUp.delegate  = delegate;
            searchPopUp.key  = keyString;
            searchPopUp.keyId = returnKey;
            searchPopUp.tag = tag;
            search.delegate  =  searchPopUp;
        }
        
    }

}


+ (void) setupPopUpViewForTextField:(UITextField *) currentTxtFld withDisplayArray:(NSMutableArray *) displayObjectsArray withDel:(id)delegate displayKey:(NSString *) keyString returnKey:(NSString *) returnKey  withTag:(int) tag{
    
    [ReusedMethods setupPopUpViewForTextField:currentTxtFld withDisplayArray:displayObjectsArray withDel:delegate displayKey:keyString returnKey:returnKey withTag:tag isMultiSelect:NO selectedPosItems:nil];
}

+ (void) setupDownPopUpViewForTextField:(UITextField *) currentTxtFld withDisplayArray:(NSMutableArray *) displayObjectsArray withDel:(id)delegate displayKey:(NSString *) keyString returnKey:(NSString *) returnKey  withTag:(int) tag
{
    // remove keyboard exists
    
    [self dismissKeyboardonView:[currentTxtFld superview]];
    
    UIView * popUpView  =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 200)];
    [popUpView setBackgroundColor:[UIColor appWhiteColor]];
    
    // search bar implementation
    UISearchBar *search = [[UISearchBar alloc] init];
    [search setTintColor:[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0]];
    search.frame = CGRectMake(0, 0,CGRectGetWidth(popUpView.frame) ,40);
    [popUpView addSubview:search];
    
    // set up tableView
    UITableView * popUpTbleVw  =  [[UITableView  alloc] initWithFrame:CGRectMake(0, 40,CGRectGetWidth(popUpView.frame),160)];
    [popUpView addSubview:popUpTbleVw];
    
    //  window  object to display the popup view
    UIWindow *  window  =  [[[UIApplication sharedApplication] delegate] window];
    
    
    // rba popup setup
    RBAPopup *  searchPopUp  =  [[RBAPopup alloc] initWithCustomView:popUpView];
    searchPopUp.textFeild  =  currentTxtFld;
    searchPopUp.allData =  [[NSMutableArray alloc] initWithArray:displayObjectsArray];
    searchPopUp.contactsArray = [[NSMutableArray alloc] initWithArray:displayObjectsArray];
    searchPopUp.delegate  = delegate;
    searchPopUp.key  = keyString;
    searchPopUp.keyId = returnKey;
    searchPopUp.tag = tag;
    
    BOOL isAdvancedSearch  =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"isAdvancedSearch"] boolValue];
    
    searchPopUp.preferredPinDirection = isAdvancedSearch? PinDirectionAny : PinDirectionDown;
    [searchPopUp presentPointingAtView:currentTxtFld inView:window animated:YES];
    
    search.delegate  =  searchPopUp;
}

+ (void) setupPopUpViewForView:(id ) currentFld withDisplayArray:(NSMutableArray *) displayObjectsArray withDel:(id)delegate displayKey:(NSString *) keyString returnKey:(NSString *) returnKey  withTag:(int) tag{
    // remove keyboard exists
    
    [self dismissKeyboardonView:[currentFld superview]];
    
    UIView * popUpView  =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 200)];
    [popUpView setBackgroundColor:[UIColor appWhiteColor]];
    
    // search bar implementation
    UISearchBar *search = [[UISearchBar alloc] init];
    [search setTintColor:[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0]];
    search.frame = CGRectMake(0, 0,CGRectGetWidth(popUpView.frame) ,40);
    [popUpView addSubview:search];
    
    // set up tableView
    UITableView * popUpTbleVw  =  [[UITableView  alloc] initWithFrame:CGRectMake(0, 40,CGRectGetWidth(popUpView.frame),160)];
    popUpTbleVw.tag  =   DISPLAY_STATES_TABLEVIEW_TAG;
    [popUpView addSubview:popUpTbleVw];
    
    
    //  window  object to display the popup view
    UIWindow *  window  =  [[[UIApplication sharedApplication] delegate] window];
    
    
    // rba popup setup
    RBAPopup *  searchPopUp  =  [[RBAPopup alloc] initWithCustomView:popUpView];
    [searchPopUp presentPointingAtView:currentFld inView:window animated:YES];
    searchPopUp.textFeild  =  [currentFld isKindOfClass:[UITextField class]] ?  currentFld : nil;
    searchPopUp.allData =  [[NSMutableArray alloc] initWithArray:displayObjectsArray];
    searchPopUp.contactsArray = [[NSMutableArray alloc] initWithArray:displayObjectsArray];
    searchPopUp.delegate  = delegate;
    searchPopUp.key  = keyString;
    searchPopUp.keyId = returnKey;
    searchPopUp.tag = tag;
    
    search.delegate  =  searchPopUp;
}



// pop up set up method
+ (void) setupPopUpViewForTextView:(UITextView *) currentTxtFld withDisplayArray:(NSMutableArray *) displayObjectsArray withDel:(id)delegate displayKey:(NSString *) keyString returnKey:(NSString *) returnKey  withTag:(int) tag
{
    // remove keyboard exists
    
    [self dismissKeyboardonView:[currentTxtFld superview]];
    
    UIView * popUpView  =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 200)];
    [popUpView setBackgroundColor:[UIColor appWhiteColor]];
    
    // search bar implementation
    UISearchBar *search = [[UISearchBar alloc] init];
    [search setTintColor:[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0]];
    search.frame = CGRectMake(0, 0,CGRectGetWidth(popUpView.frame) ,40);
    [popUpView addSubview:search];
    
    // set up tableView
    UITableView * popUpTbleVw  =  [[UITableView  alloc] initWithFrame:CGRectMake(0, 40,CGRectGetWidth(popUpView.frame),160)];
    [popUpView addSubview:popUpTbleVw];
    
    //  window  object to display the popup view
    UIWindow *  window  =  [[[UIApplication sharedApplication] delegate] window];
    
    
    // rba popup setup
    RBAPopup *  searchPopUp  =  [[RBAPopup alloc] initWithCustomView:popUpView];
    [searchPopUp presentPointingAtView:currentTxtFld inView:window animated:YES];
    searchPopUp.textFeild  =  currentTxtFld;
    searchPopUp.allData =  [[NSMutableArray alloc] initWithArray:displayObjectsArray];
    searchPopUp.contactsArray = [[NSMutableArray alloc] initWithArray:displayObjectsArray];
    searchPopUp.delegate  = delegate;
    searchPopUp.key  = keyString;
    searchPopUp.keyId = returnKey;
    searchPopUp.tag = tag;
    
    search.delegate  =  searchPopUp;
}


+(RBAMultiplePopup *)addMultiplePopupViewWithVC:(id)curentVC dataArray:(NSMutableArray *)dataArray dataKey:(NSString *)dataKey idName:(NSString *)idName textField:(id)txtFld andSelectedItems:(NSArray *)selectedItems withTag:(int)tag
{
    float viewWidth  =  250;
    float viewHeight = 300;
    float searchViewHeight = 40;
    
    UITableView * popUpTbleVw  =  [[UITableView  alloc] initWithFrame:CGRectMake(0, searchViewHeight,viewWidth,viewHeight - (2 *searchViewHeight))];
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight - searchViewHeight)];
    [customView addSubview:popUpTbleVw];
    
    float doneButtonWidth = 50;
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, searchViewHeight)];
    [searchView setBackgroundColor:[UIColor appWhiteColor]];
    
    UISearchBar *searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, viewWidth - doneButtonWidth, searchViewHeight)];
    [searchView addSubview:searchbar];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(viewWidth - doneButtonWidth, 0, doneButtonWidth, searchViewHeight);
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor appWhiteColor] forState:UIControlStateNormal];
    [doneButton setBackgroundColor:[UIColor appLightPinkColor]];
    [doneButton.layer setBorderWidth:1.0f];
    [doneButton.layer setBorderColor:[UIColor appLightPinkColor].CGColor];
    [doneButton.layer setCornerRadius:5.0f];
    [doneButton.layer setMasksToBounds:YES];
    //[doneButton setBackgroundImage:[UIImage imageNamed:@"Login"] forState:UIControlStateNormal];
    [searchView addSubview:doneButton];
    [customView addSubview:searchView];
    
    popUpTbleVw.tag = 100;
    RBAMultiplePopup *    popTipView = [[RBAMultiplePopup alloc]initWithCustomView:customView];
    popTipView.contactsArray = [[NSMutableArray alloc] init];
    [popTipView.contactsArray addObjectsFromArray:dataArray];
    popTipView.allData = [[NSMutableArray alloc] init];
    [popTipView.allData addObjectsFromArray:dataArray];
    popTipView.selectedRowsArray = [[NSMutableArray alloc] init];
    if (selectedItems)  [popTipView.selectedRowsArray addObjectsFromArray:selectedItems];
    popTipView.key = dataKey;
    popTipView.textFeild = txtFld;
    popTipView.idName = idName;
    [popUpTbleVw reloadData];
    
    // Setting search bar delegate..
    [searchbar setDelegate:popTipView];
    // Adding target for Done button.
    
    popTipView.backgroundColor = [UIColor appWhiteColor];
    popTipView.borderColor = [UIColor appGreenColor];
    popTipView.delegate = curentVC;
    popTipView.cornerRadius = 5.0f;
    popTipView.dismissTapAnywhere = YES;
    popTipView.tag = tag;
    [doneButton addTarget:popTipView action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIWindow *  window  =  [[[UIApplication sharedApplication] delegate] window];
    [popTipView presentPointingAtView:txtFld inView:window animated:YES];
    return popTipView;
}
+ (void)dismissKeyboardonView:(UIView *) view
{
    [view endEditing:YES];
}

+ (RESideMenu *) setUpResideMenuControllerWithContentVC:(UIViewController *) contentVC bottomVC:(UIViewController *) bottomVC{
    
    UIStoryboard * storyBoard =  [UIStoryboard storyboardWithName:SM_STORY_BOARD bundle:nil];
    
    RESideMenu *reSideMenu = [storyBoard  instantiateViewControllerWithIdentifier:SM_RE_SIDE_MENU_VC];
    
    reSideMenu.contentViewController  =  contentVC;
    reSideMenu.leftMenuViewController  =  bottomVC;
    
    reSideMenu.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    reSideMenu.contentViewShadowColor = [UIColor blackColor];
    reSideMenu.contentViewShadowOffset = CGSizeMake(0, 0);
    reSideMenu.contentViewShadowOpacity = 0.6;
    reSideMenu.contentViewShadowRadius = 12;
    reSideMenu.contentViewShadowEnabled = YES;
    
    id delegate  = [[UIApplication sharedApplication] delegate];
    
    reSideMenu.delegate  = delegate;
    
    return reSideMenu;
}

+ (void) logout{
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isUserExist"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [ReusedMethods checkAppFlow];
    
    // sending device token while logout.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [defaults objectForKey:@"deviceToken"];
    NSMutableDictionary *  parametersDict  =  [[NSMutableDictionary  alloc] init];
    [parametersDict setObject:deviceToken.length ? deviceToken : @"" forKey:@"deviceToken"];
    
    
    APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_LOGOUT ModuleName:MODULE_USER MethodType:METHOD_TYPE_POST Parameters:parametersDict SuccessCallBack:@selector(logoutAPISuccess:) AndFailureCallBack:@selector(logoutAPIFailed:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
    [service makeWebServiceCall];
    
}

+ (void) logoutAPISuccess:(NSDictionary *)success{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isUserExist"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isAdvancedSearch"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstTime"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:USER_NOTIFICATIONS_COUNT];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:NOTIFICATIONS_ARRAY];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:USER_DEFAULTS_AUTHTKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[ReusedMethods sharedObject] setTermsAndConditionsAccepted:NO];
    
//    [SMSharedFilesClass removeAllObjectAtPath:[SMSharedFilesClass getProfileImagesArray] type:imageType];
//    [SMSharedFilesClass  removeAllTempObjectAtPath:[SMSharedFilesClass getProfileImagesArray] type:imageType];
//    [SMSharedFilesClass removeAllObjectAtPath:[SMSharedFilesClass getProfileVideosArray] type:videoType];
//    [SMSharedFilesClass  removeAllTempObjectAtPath:[SMSharedFilesClass getProfileVideosArray] type:videoType];
//    
//    [SMSharedFilesClass removeAllObjectAtPath:[SMSharedFilesClass getProfileResumesArray] type:resumeType];
//    [SMSharedFilesClass  removeAllTempObjectAtPath:[SMSharedFilesClass getProfileResumesArray] type:resumeType];
//    
//    [SMSharedFilesClass removeAllObjectAtPath:[SMSharedFilesClass getProfileLettersOfRecommendatationsArray] type:recommendationType];
//    [SMSharedFilesClass  removeAllTempObjectAtPath:[SMSharedFilesClass getProfileLettersOfRecommendatationsArray] type:recommendationType];
//    
//    [SMSharedFilesClass removeAllObjectAtPath:[SMSharedFilesClass allFilesAtPath:[SMSharedFilesClass profilePicturePath]] type:pictureType];
//    [SMSharedFilesClass removeAllTempObjectAtPath:[SMSharedFilesClass allFilesAtPath:[SMSharedFilesClass profileTempPicturePath]] type:pictureType];
    
    
    [[ReusedMethods sharedObject].userProfileInfo removeAllObjects];
    [ReusedMethods checkAppFlow];
}

+ (void) logoutAPIFailed:(NSDictionary *)failure{
    
}


+ (void) checkAppFlow{
    
    AppDelegate *appDelegate  =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    BOOL isUserExists  =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"isUserExist"] boolValue];
//    BOOL appLaunch  =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"appLaunch"] boolValue];
    BOOL isAdvancedSearch  =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"isAdvancedSearch"] boolValue];
    UIStoryboard * storyBoard =  [UIStoryboard storyboardWithName:SM_STORY_BOARD bundle:nil];
    
    if(isUserExists) {

        
        NSString *  identifierName  =  isAdvancedSearch  ?  SM_ADVANCED_SEARCH_VC : SM_HOME_VC ;
        
        SMHomeVC *   homeVC  =  [storyBoard instantiateViewControllerWithIdentifier:identifierName];
        
        

        
//        UIViewController *  bottomVC  =  [storyBoard instantiateViewControllerWithIdentifier:SM_HOME_BOTTOM_VC];
//        RESideMenu * resideMenu  =   [ReusedMethods setUpResideMenuControllerWithContentVC:appDelegate.navController bottomVC:bottomVC];
//        [appDelegate.window  setRootViewController:resideMenu];
        
        appDelegate.tabBarController = [storyBoard instantiateViewControllerWithIdentifier:SM_TABBAR_VC];
        UIViewController *menuController  =  [storyBoard instantiateViewControllerWithIdentifier:SM_LEFT_SIDE_MENU_VC];
        appDelegate.navController = [[SlideNavigationController alloc] initWithRootViewController:appDelegate.tabBarController];
        [SlideNavigationController sharedInstance].leftMenu = menuController;
        
        [appDelegate.window  setRootViewController:appDelegate.navController];
        
    }else{
        UIViewController *  logInVC  =  [storyBoard instantiateViewControllerWithIdentifier:SM_LOGIN_VC];
        appDelegate.navController = [[SlideNavigationController alloc] initWithRootViewController:logInVC];
        
        [appDelegate.window  setRootViewController:appDelegate.navController];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isHome"];
    [[NSUserDefaults  standardUserDefaults] synchronize];
    
    [appDelegate.navController  setNavigationBarHidden:YES];
}


#pragma mark - Navigation Bar

+(void)setNavigationViewOnView: (UIView *)selfView WithTitle:(NSString *)title andBackgroundColor:(UIColor *) BGcolor
{
    float width =  [UIScreen mainScreen].bounds.size.width;// CGRectGetWidth(selfView.frame);
    float navHt = NAVIGATION_HEIGHT;
    
    NSLog(@"navigation view  width  for welcome  screen  %f screen - %@",width , selfView);
    
    //Navigation view
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, navHt)];
    [navView setBackgroundColor:BGcolor];
    [navView setTag:NAVIGATION_VIEW_TAG];
    navView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [selfView addSubview:navView];
    
    //Status bar  Label
    UILabel *statusBarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 20)];
    [statusBarLabel setBackgroundColor:[UIColor clearColor]];
    statusBarLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [navView addSubview:statusBarLabel];
    
    //Title Label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20., width, navHt - 20.)];
    [titleLabel setText:title];
    [titleLabel setTextColor:[UIColor colorWithRed:125./255. green:39./255. blue:125./255. alpha:1.]];
    [titleLabel setTag:NAV_VIEW_TITLE_LABEL_TAG];
    [titleLabel setFont: [UIFont appLatoBlackFont24]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setNumberOfLines:0];
    [titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [navView addSubview:titleLabel];
    
    [navView addInnerShadowWithRadius:6.0f
                             andColor:[UIColor colorWithWhite:0 alpha:0.1f]
                          inDirection:NLInnerShadowDirectionBottom];
    
    [selfView bringSubviewToFront:navView];
 
}

/*!
 set up left side button on the navigation view
 */
+ (void) setUpLeftButton:(UIViewController *)vc withImageName:(NSString *) leftButtonImageName{
    // back button
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame :CGRectMake(16, 35, 29, 20)];
    [leftButton setBackgroundColor: [UIColor clearColor]];
    [leftButton setImage:[UIImage imageNamed:leftButtonImageName] forState:UIControlStateNormal];
   // [[leftButton titleLabel] setFont:[UIFont appNormalFont]];
    [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [leftButton setTag:LEFT_BUTTON_TAG];
    [leftButton addTarget:vc action:@selector(navViewLeftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [vc.view addSubview:leftButton];
}

/*!
 set up right side button on the navigation view
 */
+ (UIButton *) setUpRightButton:(UIViewController *)vc withImageName:(NSString *)rightButtonImageName withNotificationsCount:(NSInteger) notificationCount{
    
    float screenWidth  =   [[UIScreen mainScreen] bounds].size.width;
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame :CGRectMake(screenWidth - 50, 20, 45, 45)];
    [rightButton setBackgroundColor: [UIColor clearColor]];
    [rightButton setImage:[UIImage imageNamed:rightButtonImageName] forState:UIControlStateNormal];
    //[[homeButton titleLabel] setFont:[UIFont appNormalFont]];
    [rightButton  setTag:RIGHT_BUTTON_TAG];
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [rightButton addTarget:vc action:@selector(navViewRightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [vc.view addSubview:rightButton];
    
    //  align label  for  notifications  number display
    
    if(notificationCount <= 0)
        return rightButton;
    
    UILabel *notify_count = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(rightButton.frame) - 20, 5, 20, 20)];
    [notify_count setText:[NSString stringWithFormat:@"%ld",notificationCount]];
    [notify_count setTextColor:[UIColor whiteColor]];
    [notify_count setBackgroundColor:[UIColor appPinkColor]];
    [notify_count setFont: [UIFont appLatoLightFont10]];
    [notify_count.layer  setBorderWidth:1.0f];
    [notify_count.layer  setBorderColor:[UIColor appPinkColor].CGColor];
    [notify_count.layer  setCornerRadius:CGRectGetWidth(notify_count.frame)/2];
    [notify_count.layer  setMasksToBounds:YES];
    [notify_count setTextAlignment:NSTextAlignmentCenter];
    [rightButton addSubview:notify_count];
    
    return rightButton;
}

+ (void) changeGradientColorForWindow:(UIView *) view{
    
    UIColor *topColor = [[UIColor appPinkColor] colorWithAlphaComponent:0.3];
    UIColor *bottomColor = [[UIColor appGreenColor]colorWithAlphaComponent:0.8];
    
    // Create the gradient
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    theViewGradient.frame = view.bounds;
    
    
    [view.layer insertSublayer:theViewGradient atIndex:0];
   
}


+ (NSString *) replaceNullString:(NSString *)strValue withSpace:(BOOL) space{
    if([strValue isKindOfClass:[NSNull class]] || strValue == nil)
        strValue = @"";
    else{
        strValue = [NSString stringWithFormat:@"%@", strValue];
        
        if(space)
            strValue = [NSString stringWithFormat:@"%@", strValue];
    }
    
    return strValue;
}

+ (NSString *) agoDate:(NSString *)date{
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *now = [NSDate new];
    NSDate *oldDate = [formatter dateFromString:date];
    
    // nil handling  if date is nil then dummy string.
    if(oldDate == nil){
       // oldDate =  [NSDate new];
        return @"0 minutes";
    }
    
    NSTimeInterval distanceBetweenDates = [now timeIntervalSinceDate:oldDate];
    
    double secondsInMinute = 60;
    double minutesInAnHour = secondsInMinute * 60;
    double hoursInDay = minutesInAnHour * 24;
    double daysInMonth = hoursInDay * 30;
    double monthsInYear = daysInMonth * 12;
    
    NSString *agoString = nil;
    
    if(monthsInYear < distanceBetweenDates){
        NSInteger years = distanceBetweenDates / monthsInYear;
        distanceBetweenDates = distanceBetweenDates - (monthsInYear * years);
        agoString = [NSString stringWithFormat:@"%ld year", (long)years];
        
        if(years > 1)
            agoString = [agoString stringByAppendingString:@"s"];
//        NSLog(@"years : %ld", years);
        
        return agoString;
    }
    
    if(daysInMonth < distanceBetweenDates){
        NSInteger months = distanceBetweenDates / daysInMonth;
        distanceBetweenDates = distanceBetweenDates - (daysInMonth * months);
        
        if(!agoString)
            agoString = [NSString stringWithFormat:@"%ld month", (long)months];
        else
            agoString = [agoString stringByAppendingFormat:@" %ld month", (long)months];
        
        if(months > 1)
            agoString = [agoString stringByAppendingString:@"s"];
//        NSLog(@"months : %ld", months);
        
        return agoString;
    }
    
    if(hoursInDay < distanceBetweenDates){
        NSInteger days = distanceBetweenDates / hoursInDay;
        distanceBetweenDates = distanceBetweenDates - (hoursInDay * days);
        
        if(!agoString)
            agoString = [NSString stringWithFormat:@"%ld day", (long)days];
        else
            agoString = [agoString stringByAppendingFormat:@" %ld day", (long)days];
        
        if(days > 1)
            agoString = [agoString stringByAppendingString:@"s"];
//        NSLog(@"days : %ld", days);
        
        return agoString;
    }
    
    if(minutesInAnHour < distanceBetweenDates){
        NSInteger hours = distanceBetweenDates / minutesInAnHour;
        distanceBetweenDates = distanceBetweenDates - (minutesInAnHour * hours);
        if(!agoString){
            agoString = [NSString stringWithFormat:@"%ld hour", (long)hours];
            
            if(hours > 1)
                agoString = [agoString stringByAppendingString:@"s"];
        }
//        NSLog(@"hours : %ld", hours);
        
        return agoString;
    }
    
    if(secondsInMinute < distanceBetweenDates){
        NSInteger minutes = distanceBetweenDates / secondsInMinute;
        distanceBetweenDates = distanceBetweenDates - (secondsInMinute * minutes);
        if(!agoString){
            agoString = [NSString stringWithFormat:@"%ld minute", (long)minutes];
            
            if(minutes > 1)
                agoString = [agoString stringByAppendingString:@"s"];
        }
//        NSLog(@"minutes : %ld", minutes);
        
        return agoString;
    }
    if(agoString.length  == 0 && 1 < distanceBetweenDates){
        NSInteger seconds = distanceBetweenDates;
        distanceBetweenDates = distanceBetweenDates - (1 * seconds);
        if(!agoString){
            agoString = [NSString stringWithFormat:@"%ld second", (long)seconds];
            
            if(seconds > 1)
                agoString = [agoString stringByAppendingString:@"s"];
        }
        //        NSLog(@"minutes : %ld", minutes);
        
        return agoString;
    }

        // if agostring is nil
    
    if(agoString.length == 0){
//            return @"0 minutes";
        return @"1 second";
    }
//    NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
    
    return agoString;
}

+ (NSString *) changeDisplayFormatOfDateString:(NSString *) serverDateString withEmptyString:(NSString *) emptyString{
    
    if (serverDateString.length == 0) {
      return emptyString;
    }
    // conerts server date 0000-00-00 to 00/00/0000
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone: [NSTimeZone timeZoneWithName:@"UTC"]];
    //[formatter setDateFormat:SERVER_DATE_FORMATE];
    [formatter setDateFormat:SERVER_SAVING_DATE_FORMATE];
    NSDate *date = [formatter dateFromString:serverDateString];
    [formatter setDateFormat:APP_DISPLAY_DATE_FORMATE];
    return  [formatter stringFromDate:date];
}


+ (NSString *) changeDisplayFormatOfDateString:(NSString *) serverDateString inTheFormate:(NSString *)serverFormate WithEmptyString:(NSString *) emptyString{
    
    if (serverDateString.length == 0) {
        return emptyString;
    }
    // conerts server date 0000-00-00 to 00/00/0000
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone: [NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:serverFormate];
    NSDate *date = [formatter dateFromString:serverDateString];
    [formatter setDateFormat:APP_DISPLAY_DATE_FORMATE];
    return  [formatter stringFromDate:date];
}


+ (NSDate *) getServerFormatedDateFromDate:(NSDate *) currentDate{
    
    // conerts server date 0000-00-00 to 00/00/0000
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone: [NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:SERVER_DATE_FORMATE];
    return  [formatter dateFromString:[formatter stringFromDate:currentDate]];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    return  [formatter stringFromDate:date];
}

#pragma mark - Savigin and Getting ProfileI Images

+ (NSMutableArray *) profileImages{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:kPROFILEIMAGES];
}

+ (void) setProfileImages:(NSMutableArray *) profileImages{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:profileImages forKey: kPROFILEIMAGES];
    [userDefaults synchronize];
    
//    for (NSURL *url in profileImages) {
//        UIImage *image = [self imageFromUrl:url];
//        NSLog(@"image : %@", image);
//    }
}

+ (NSData *) dataFromImage:(UIImage *)image{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
    if(!imageData){
        imageData = UIImagePNGRepresentation(image);
    }
    return imageData;
}

+ (UIImage *) imageFromUrl:(NSURL *) referenceURL{
    UIImage *image = nil;
//    NSURL * referenceURL = [info objectForKey: UIImagePickerControllerReferenceURL];
    if(referenceURL == NULL)
    {
        NSLog( @"reference URL is null");
    }
    else
    {
        NSData * imageData = [NSData dataWithContentsOfURL: referenceURL];
        if(imageData == NULL)
        {
            NSLog( @"no image data found for URL %@", [referenceURL absoluteString] );
        } else {
            UIImage * theActualImage = [UIImage imageWithData: imageData];
            if(theActualImage == NULL)
            {
                NSLog( @"the data at URL %@ is not an image", [referenceURL absoluteString] );
            }
            else
            {
                image = theActualImage;
            }
        }
    }
    return image;
}

#pragma mark - Saving User Profile

+ (void) setUserProfile:(NSDictionary *)userprofile
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userprofile forKey:@"userProfile"];
    [userDefaults synchronize];
}

+ (NSDictionary *) userProfile
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"userProfile"];
}

#pragma mark - Saving Old User Profile

+ (void) setOldUserProfile:(NSDictionary *)userprofile
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userprofile forKey:@"oldUserProfile"];
    [userDefaults synchronize];
}

+ (NSDictionary *) oldUserProfile
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"oldUserProfile"];
}

+ (void) saveUserProfile
{
    [self setUserProfile:[[self sharedObject] userProfileInfo]];
    
    //Set apply filter for positions
    [[[self sharedObject] userProfileInfo] setObject:[[[self sharedObject] userProfileInfo] objectForKey:POSITION_IDS]
                                              forKey:POSITION];
    
    
    [self saveProfiledataToServer];
}

#pragma mark - Server call

+ (void) saveProfiledataToServer
{
    APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_SAVE ModuleName:MODULE_PROFILE MethodType:METHOD_TYPE_POST Parameters:[NSMutableDictionary dictionaryWithDictionary:[self userProfile]] SuccessCallBack:@selector(successResponseCall:) AndFailureCallBack:@selector(showErrorMessages:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:[self sharedObject]];
    [service makeWebServiceCall];
}

#pragma mark - Server response callback methods

- (void) showErrorMessages:(WebServiceCalls *)error
{
    NSString * errorMsg;
    if(error.responseError){
        errorMsg =  [[error responseError].userInfo objectForKey:@"NSLocalizedDescriptionKey"];
    }else{
        if ([[[error responseData] objectForKey:@"error"] length]) {
            errorMsg  = [[error responseData] objectForKey:@"error"];
        }
    }
    [[[RBACustomAlert  alloc] initWithTitle:APP_TITLE message:errorMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
  
}

- (void) successResponseCall:(WebServiceCalls *)profileInfo
{
    NSLog(@"Profile Info : %@", profileInfo);
    
    NSString *  responseString  = [profileInfo.responseData objectForKey:@"success"];
    
    if([responseString isEqualToString:UPDATE_EMAIL_ID_KEY]){
        RBACustomAlert * logoutAlert  = [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"Please verify your updated email address.\n Note: You will be logged out of the application." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [logoutAlert show];
        
    }else if ([responseString isEqualToString:UPDATE_EMAIL_EXISTED_KEY]){
        RBACustomAlert * emailExistedAlert  = [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:responseString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [emailExistedAlert show];
    }else{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"saveCurrentProfileDetail" object:nil];

    }
}
- (void) alertView:(RBACustomAlert *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == [alertView cancelButtonIndex] && alertView.tag != TERMS_AND_CONDITIONS_ALERT_TAG){
        [ReusedMethods logout];
    }else if (alertView.tag == TERMS_AND_CONDITIONS_ALERT_TAG){
        [ReusedMethods sendUserTermsAndConditionsAccepted];
    }
}


+ (NSString *) authToken{
    return [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULTS_AUTHTKEN];
}

+ (void) setAuthToken:(NSString *) authToken{
    [[NSUserDefaults standardUserDefaults] setObject:authToken forKey:USER_DEFAULTS_AUTHTKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *) username{
    return [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULTS_USERNAME];
}

+ (void) setUsername:(NSString *) username{
    username = [username stringByReplacingOccurrencesOfString:@"+" withString:@""];
    username = [username stringByReplacingOccurrencesOfString:@"@" withString:@""];
    username = [username stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:USER_DEFAULTS_USERNAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *) userStatus{
    return [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULTS_USERSTATUS];
}

+ (void) setUserStatus:(NSString *) userStatus{
    [[NSUserDefaults standardUserDefaults] setObject:[userStatus lowercaseString] forKey:USER_DEFAULTS_USERSTATUS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL) isAccountInActive{
    return [[self userStatus] isEqualToString:@"activated"];
}

+ (NSString *) replaceEmptyString:(NSString *) contentString emptyString:(NSString *) empty{
//    NSString * noDataString  = @"-";
    
    return contentString.length ? contentString :empty;
}

# pragma  mark  device token  server call

+ (void)makeApiCallForDeviceToken{
    
    NSMutableDictionary * dict =  [[NSMutableDictionary alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *authToken = [ReusedMethods authToken];
    NSString *deviceToken = [defaults objectForKey:@"deviceToken"];
    
    if (authToken.length > 0 && deviceToken.length > 0) {
        [dict setObject:deviceToken forKey:@"token"];
        
        APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_DEVICE_REGISTRATION ModuleName:MODULE_USER MethodType:METHOD_TYPE_POST Parameters:dict SuccessCallBack:@selector(deviceTokenApiSuccess:) AndFailureCallBack:@selector(deviceTokenApiFailed:)];
        
        WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
        [service makeWebServiceCall];
    }
    
}

+ (void) deviceTokenApiSuccess:(WebServiceCalls *) service{
    
    //    NSDictionary * dropDownData = [service responseData];
    //    [[ReusedMethods sharedObject].dropDownListDict addEntriesFromDictionary:dropDownData];
}

+ (void) deviceTokenApiFailed:(WebServiceCalls *)serverError {
    
    NSString * errmsg;
    if(serverError.responseError){
        errmsg =[[serverError responseError].userInfo objectForKey:@"NSLocalizedDescriptionKey"];
    }else{
        if ([[[serverError responseData] objectForKey:@"error"] length]) {
            errmsg = [[serverError responseData] objectForKey:@"error"];
            
        }
    }
    
    RBACustomAlert  * alert  =  [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:errmsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];

    
}


#pragma mark - GUID

+ (NSString *) GUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    NSString *guid = (__bridge NSString *)string;;
    guid = [guid stringByReplacingOccurrencesOfString:@"-" withString:[NSString stringWithFormat:@"%d", rand() % 10]];
    guid = [NSString stringWithFormat:@"%@%@", [self username], guid];
    return guid;
}

#pragma mark - YES/NO OPTIONS DICTIONARY

+ (NSMutableArray *) getAvailabityOptionsDictionary{
    NSMutableArray *  availabilityArray  =  [[NSMutableArray alloc]init];
    for (int i = 0; i<=2; i++) {
        NSMutableDictionary *  dict  =  [[NSMutableDictionary alloc] init];
        if(i  ==  2){
           [dict setObject:[NSString stringWithFormat:@"%@",@"N/A"] forKey:@"boolean_name"];
        }else{
        [dict setObject:[NSString stringWithFormat:@"%@",i == 0 ? @"NO":@"YES"] forKey:@"boolean_name"];
        }
        [dict setObject:[NSNumber numberWithInt:i] forKey:@"boolean_id"];
        [availabilityArray addObject:dict];
    }
    return availabilityArray;
}

+ (NSMutableArray *) getAvailabityOptionsDictionaryForVirtualInterView{
    NSMutableArray *  availabilityArray  =  [[NSMutableArray alloc]init];
    for (int i = 0; i<=1; i++) {
        NSMutableDictionary *  dict  =  [[NSMutableDictionary alloc] init];
        [dict setObject:[NSString stringWithFormat:@"%@",i == 0 ? @"NO":@"YES"] forKey:@"boolean_name"];
        [dict setObject:[NSNumber numberWithInt:i] forKey:@"boolean_id"];
        [availabilityArray addObject:dict];
    }
    return availabilityArray;
}


+(NSArray *) getArrayFromString:(NSString *) skillsString{
    
    return  [skillsString componentsSeparatedByString: @","];
}

+ (NSString *) getcorrespondingStringWithId:(NSNumber *) idNumber andKey:(NSString *) keyString{
    NSString * groupKeyString =  [ReusedMethods getGroupKeyFromKeyString:keyString];
    NSString * nameString  = [ReusedMethods getNameKeyFromServerKeyString:keyString];
    NSString * idString  =  [ReusedMethods getIdKeyFromServerKeyString:keyString];
    
    NSDictionary * dropDowndict  = [ReusedMethods sharedObject].dropDownListDict;
    NSArray *groupArray  =  [dropDowndict objectForKey:groupKeyString];
    
    NSInteger   skillID = [idNumber integerValue];
    NSString *strPredicate = [NSString stringWithFormat:@"%@ = %ld",idString, (long)skillID];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:strPredicate];
    NSString * string = [[[groupArray filteredArrayUsingPredicate:predicate] firstObject] objectForKey:nameString];
    
    NSMutableArray *subCategoryDictArr = [[NSMutableArray alloc] init];
    
    NSNumber *parentId = 0;
    
    for (NSDictionary *dict in groupArray) {
        if ([[dict valueForKey:@"parent_id"] isKindOfClass:[NSNumber class]]) {
            [subCategoryDictArr addObject:[dict valueForKey:@"software_type_id"]];
            parentId = [dict valueForKey:@"parent_id"];
        }
    }
    if (parentId != 0 && [NSNumber numberWithInteger:skillID].intValue == parentId.intValue) {
        string = [NSString stringWithFormat:@"Par-%@",string];
    }
    for (NSNumber *num in subCategoryDictArr) {
        if (num.intValue == [NSNumber numberWithInteger:skillID].intValue){
            string = [NSString stringWithFormat:@"Sub-%@",string];
        }
    }
    
    return string;
}


+ (NSString *) getcorrespondingStringFromLocalOptionsDictioriesWithId:(NSNumber *)idNumber andKey:(NSString *)keyString{
    
    NSArray *groupArray  ;
    if([keyString isEqualToString:BOARD_CERTIFIED]){
        groupArray  =  [ReusedMethods  getAvailabityOptionsDictionary];
    }
    if([keyString isEqualToString:VIRTUAL_INTERVIEW]){
         groupArray  =  [ReusedMethods  getAvailabityOptionsDictionaryForVirtualInterView];
    }
    
    if(![idNumber isKindOfClass:[NSNumber class]]){
        return SPACE;
    }
    
    
    NSString *strPredicate = [NSString stringWithFormat:@"boolean_id = %@",idNumber];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:strPredicate];
    NSString * string = [[[groupArray filteredArrayUsingPredicate:predicate] firstObject] objectForKey:@"boolean_name"];
    return string;

}
 
+ (NSString *) getGroupKeyFromKeyString:(NSString *)keyString{
    if ([keyString  isEqualToString: POSITION])
        return @"positions";
    else if ([keyString  isEqualToString: EXPERIENCE])
        return @"experience";
    else if ([keyString  isEqualToString: JOB_TYPE])
        return @"jobtype";
    else if ([keyString  isEqualToString: WORK_AVAILABILITY])
        return @"work_availability";
    else if ([keyString  isEqualToString: LOCATION_RANGE])
        return @"location_range";
    else if ([keyString  isEqualToString: PRACTICE_MANAGEMENT])
        return @"praticeManagementSoftware";
    else if ([keyString  isEqualToString: COMRANGE])
        return @"comprange";
    else if ([keyString  isEqualToString: SKILLS])
        return @"software_proficiency";
    else if ([keyString  isEqualToString: LICENSE_VERIFICATION_STATES])
        return @"state_list";
    else
        return @"";
}
 
+ (NSString *) getIdKeyFromServerKeyString:(NSString *)keyString{
    if ([keyString  isEqualToString: POSITION])
        return @"position_id";
    else if ([keyString  isEqualToString: EXPERIENCE])
        return @"experience_range_id";
    else if ([keyString  isEqualToString: JOB_TYPE])
        return @"job_type_id";
    else if ([keyString  isEqualToString: WORK_AVAILABILITY])
        return @"work_id";
    else if ([keyString  isEqualToString: LOCATION_RANGE])
        return @"range_id";
    else if ([keyString  isEqualToString: PRACTICE_MANAGEMENT])
        return @"software_id";
    else if ([keyString  isEqualToString: COMRANGE])
        return @"compensation_id";
    else if ([keyString  isEqualToString: SKILLS])
        return @"software_type_id";
    else if ([keyString  isEqualToString: LICENSE_VERIFICATION_STATES])
        return @"state_id";

    else
        return @"";
}

+ (NSString *) getNameKeyFromServerKeyString:(NSString *)keyString{
    if ([keyString  isEqualToString: POSITION])
        return @"position_name";
    else if ([keyString  isEqualToString: EXPERIENCE])
        return @"experience_range";
    else if ([keyString  isEqualToString: JOB_TYPE])
        return @"job_type";
    else if ([keyString  isEqualToString: WORK_AVAILABILITY])
        return @"work_availabilty_name";
    else if ([keyString  isEqualToString: LOCATION_RANGE])
        return @"miles_range";
    else if ([keyString  isEqualToString: PRACTICE_MANAGEMENT])
        return @"software";
    else if ([keyString  isEqualToString: COMRANGE])
        return @"compensation_name";
    else if ([keyString  isEqualToString: SKILLS])
        return @"software_type_name";
    else if ([keyString  isEqualToString: LICENSE_VERIFICATION_STATES])
        return @"state_name";
    else
        return @"";
    
}

+ (NSString *)getCombainedStringFromServerResponseArrayHavingServerkey:(NSString *) serverObjectKey{
    NSDictionary *  dict  =  [[ReusedMethods sharedObject] userProfileInfo];
    NSMutableArray *selectedDataStrings = [[NSMutableArray alloc] init];
    if([dict objectForKey:serverObjectKey] && [[dict objectForKey:serverObjectKey] isKindOfClass:[NSArray class]]){
        for (NSNumber * num in [dict objectForKey:serverObjectKey]) {
            NSString * valueString =[ReusedMethods getcorrespondingStringWithId:num andKey:serverObjectKey];
            if (valueString)
            {
                [selectedDataStrings addObject:valueString];
            }

        }
    }
    return  [selectedDataStrings componentsJoinedByString: @", "];
}


+ (BOOL) isObjectClassNameString:(id) object{
    return  [object isKindOfClass:[NSString class]] ? YES : NO;
}

+(float)profileProgresValue
{
     int totalUploadedFieldsCount, requiredFieldsCount;
    NSMutableArray *compleatedFieldsArray;
    
    compleatedFieldsArray = [NSMutableArray  arrayWithArray:[[self userProfile] allKeys]];
    
    if([compleatedFieldsArray containsObject:@"video"])
    {
        [compleatedFieldsArray removeObject: @"video"];
    }
    if([compleatedFieldsArray containsObject:@"image"])
    {
        [compleatedFieldsArray removeObject: @"image"];
    }
    if([compleatedFieldsArray containsObject:@"recomendationLettrs"])
    {
        [compleatedFieldsArray removeObject: @"recomendationLettrs"];
    }
    if([compleatedFieldsArray containsObject:@"resume"])
    {
        [compleatedFieldsArray removeObject: @"resume"];
    }
    if([compleatedFieldsArray containsObject:@"resume_url"])
    {
        [compleatedFieldsArray removeObject: @"resume_url"];
    }
    if([compleatedFieldsArray containsObject:@"videoThumbnail"])
    {
        [compleatedFieldsArray removeObject: @"videoThumbnail"];
    }
    if([compleatedFieldsArray containsObject:@"video_url"])
    {
        [compleatedFieldsArray removeObject: @"video_url"];
    }
    if([compleatedFieldsArray containsObject:@"recomendationLettrs_url"])
    {
        [compleatedFieldsArray removeObject: @"recomendationLettrs_url"];
    }
    if([compleatedFieldsArray containsObject:@"image_url"])
    {
        [compleatedFieldsArray removeObject: @"image_url"];
    }
    if([compleatedFieldsArray containsObject:@"bilingual_languages"])
    {
        [compleatedFieldsArray removeObject: @"bilingual_languages"];
    }
    if([compleatedFieldsArray containsObject:@"newPracticeSoftware"])
    {
        [compleatedFieldsArray removeObject: @"newPracticeSoftware"];
    }
    if([compleatedFieldsArray containsObject:@"profile_url"])
    {
        [compleatedFieldsArray removeObject: @"profile_url"];
    }
    if([compleatedFieldsArray containsObject:@"newEmail"])
    {
        [compleatedFieldsArray removeObject: @"newEmail"];
    }
    if([compleatedFieldsArray containsObject:@"workAvailabilityDate"])
    {
        [compleatedFieldsArray removeObject: @"workAvailabilityDate"];
    }
    if([compleatedFieldsArray containsObject:@"shifts"])
    {
        [compleatedFieldsArray removeObject: @"shifts"];
    }
    if([compleatedFieldsArray containsObject:@"skills"])
    {
        [compleatedFieldsArray removeObject: @"skills"];
    }
    if([compleatedFieldsArray containsObject:@"licenseVerifiedStates"])
    {
        [compleatedFieldsArray removeObject: @"licenseVerifiedStates"];
    }
    if([compleatedFieldsArray containsObject:@"practiceManagementID"])
    {
        [compleatedFieldsArray removeObject: @"practiceManagementID"];
    }


    int compleatedFieldsCount = (int)compleatedFieldsArray.count;
    int uploadedImagesCount =  (int)[[[ReusedMethods userProfile] objectForKey:@"image"] count] ? 1: 0;//(int)[SMSharedFilesClass listFileAtPath:[SMSharedFilesClass profileImagesPath]];
    int uploadedVideosCount =  (int)[[[ReusedMethods userProfile] objectForKey:@"video"] count]? 1 : 0;//(int)[SMSharedFilesClass listFileAtPath:[SMSharedFilesClass profileVideosPath]];
    int uploadedResumesCount = (int)[[[ReusedMethods userProfile] objectForKey:@"resume"] count]? 1 :0; //(int)[SMSharedFilesClass listFileAtPath:[SMSharedFilesClass profileResumePath]];
    int uploadedRecomendationCount =  (int)[[[ReusedMethods userProfile] objectForKey:@"recomendationLettrs"] count] ? 1 :0;// (int)[SMSharedFilesClass listFileAtPath:[SMSharedFilesClass profilePRecommendationLettersPath]];
    int skillsCount  = (int)[[[ReusedMethods userProfile] objectForKey:@"skills"] count] ? 1: 0;
    int statesCount  =  (int)[[[ReusedMethods userProfile] objectForKey:@"licenseVerifiedStates"] count] ? 1: 0;
    int practiceManagementId  = (int) [[[ReusedMethods userProfile] objectForKey:@"practiceManagementID"] count] ? 1: 0;
    
    int shiftsCount =  (int)[[[ReusedMethods userProfile] objectForKey:@"shifts"]  count]? 1: 0;
    
    if(shiftsCount){
        for (NSDictionary *  dict  in [[ReusedMethods userProfile] objectForKey:@"shifts"]) {
            if([[dict objectForKey:@"days"] count]){
                shiftsCount  =  1;
                break;
            }else{
                shiftsCount  =  0;
            }
        }
    }

    
    
    requiredFieldsCount = PROFILE_FIELDS_COUNT;  //+ 5 + 5 + 1 + 1;
    totalUploadedFieldsCount = compleatedFieldsCount + uploadedImagesCount + uploadedVideosCount + uploadedResumesCount + uploadedRecomendationCount + shiftsCount +skillsCount + statesCount + practiceManagementId;
    
    NSLog(@"===requiredFieldsCount = %d ====totalUploadedFieldsCount= %d",requiredFieldsCount,totalUploadedFieldsCount);
    
    float  progresValue =  (float)totalUploadedFieldsCount / (float)requiredFieldsCount ;
    return progresValue;
}


+(void)generateThumbImage : (NSString *)filepath withImageView:(id) videoImageView
{
    NSURL *url = [NSURL URLWithString:filepath];
    //
    //    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:url options:nil];
    ////    AVAsset *asset = [AVAsset assetWithURL:url];
    //    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    //    CMTime time = [asset duration];
    //    time.value = 0;
    //    CGImageRef imgRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:nil];
    //    UIImage* thumbnail = [[UIImage alloc] initWithCGImage:imgRef scale:UIViewContentModeScaleAspectFit orientation:UIImageOrientationUp];
    //    return thumbnail;
    
    
    // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    
    //    //Getting the video thumb nail image.
    //    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:url options:nil];
    //    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    //    generator.appliesPreferredTrackTransform=TRUE;
    //    CMTime thumbTime = CMTimeMakeWithSeconds(0,30);
    //
    //    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
    //        if (result != AVAssetImageGeneratorSucceeded) {
    //            NSLog(@"couldn't generate thumbnail, error:%@", error);
    //        }
    //
    //         UIImage *image = [UIImage imageWithCGImage:im];
    //        if([videoImageView isKindOfClass:[UIButton class]])
    //            [(UIButton *)videoImageView setImage:image forState:UIControlStateNormal];
    //        else
    //            [(UIImageView *)videoImageView setImage:image];
    //    };
    //
    //    CGSize maxSize = CGSizeMake(320, 180);
    //    generator.maximumSize = maxSize;
    //    [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
    //   // });
    
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            AVURLAsset* asset = [AVURLAsset URLAssetWithURL:url options:nil];
            AVAssetImageGenerator* generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
            generator.appliesPreferredTrackTransform = YES;
            CGImageRef  ref  =  [generator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:nil];
            UIImage* image = [UIImage imageWithCGImage:ref];
    
           // dispatch_async(dispatch_get_main_queue(), ^{
    
                if([videoImageView isKindOfClass:[UIButton class]])
                    [(UIButton *)videoImageView setImage:image forState:UIControlStateNormal];
                else
                    [(UIImageView *)videoImageView setImage:image];
            //});
        //});
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:url];
//        
//        UIImage *thumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
//        [player stop];
//        if([videoImageView isKindOfClass:[UIButton class]])
//            [(UIButton *)videoImageView setImage:thumbnail forState:UIControlStateNormal];
//        else
//            [(UIImageView *)videoImageView setImage:thumbnail];
//        
//    });
//    
//    
//      });

    
    
    
    
}



+ (BOOL) validationsForProfileData:(int)indexProfileDetailPage {
    
    NSDictionary *  profileDict  =  [[ReusedMethods sharedObject] userProfileInfo];
    
    if (indexProfileDetailPage == 0) {  // For first profile detail page
        
        if(![SMValidation emptyTextValidation:[profileDict objectForKey:CITY]]){
            [[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:MANDATORY_FIELDS_ALERT delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
            return NO;
        }
        else if(![SMValidation emptyTextValidation:[profileDict objectForKey:STATE]]){
            [[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:MANDATORY_FIELDS_ALERT delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return NO;
        }
        else if(![SMValidation emptyTextValidation:[profileDict objectForKey:ZIP]]){
            [[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:MANDATORY_FIELDS_ALERT delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return NO;
        }
        else  if([SMValidation emptyTextValidation:[profileDict objectForKey:PHONE_NUMBER]]){
            if(![SMValidation validatePhoneNumberlWithString:[SMValidation formatePhoneNumberTxtFieldString:[profileDict objectForKey:PHONE_NUMBER]]]){
                [[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"Please enter valid phone number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                return NO;
            }
        }
        if([SMValidation emptyTextValidation:[profileDict objectForKey:ZIP]]){
            //  here  string  contains  alpha numerics
            if ([SMValidation isCharectersString:[profileDict objectForKey:ZIP]]) {
                
                if([SMValidation stringContainsOnlyCharacters:[profileDict objectForKey:ZIP]]){
                    [[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"Please enter valid Zip Code" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    return NO;
                    
                }else{
                    if([SMValidation isNumericString:[profileDict objectForKey:ZIP]]){
                        if(![SMValidation isValidZipCode:[profileDict objectForKey:ZIP]]){
                            [[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"Please enter valid Zip Code" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                            return NO;
                        }
                    }
                    
                }
            }else{
                [[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"Please enter valid Zip Code" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                return NO;
            }
            
            
        }
        if(![SMValidation isNewmailId:[profileDict objectForKey:NEW_EMAIL] differWithOldMailId:[profileDict objectForKey:EMAIL]]){
            [[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"Email address not changed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return NO;
        }
        if(![SMValidation validateNewMailId:[profileDict objectForKey:NEW_EMAIL]]){
            [[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"Please enter valid email address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return NO;
        }
        
        NSString *profileURL = [[ReusedMethods userProfile] valueForKey:@"profile_url"];
        if(!profileURL.length){
            [[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"Please add your profile picture" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return NO;
        }
        
        return YES;
    }
    else if (indexProfileDetailPage == 1) { // For second profile detail page
        if(![SMValidation emptyNumberValidation:[profileDict objectForKey:EXPERIENCE]]){
            [[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"Please select the experience." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return NO;
        }
        
        if (![profileDict objectForKey:POSITION_IDS] || [[profileDict objectForKey:POSITION_IDS] count] == 0) {
            [[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"Please select the position." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return NO;
        }
        
        return YES;
    }
    else if (indexProfileDetailPage == 2) { // For third profile detail page
        if([SMValidation isWorkAvailabilityDateIDSelected:[profileDict objectForKey:WORK_AVAILABILITY]]){
            if(![SMValidation emptyTextValidation:[profileDict objectForKey:WORK_AVAILABILITY_AFTER_DATE]]){
                [[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"Please enter available date for work availability" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                return NO;
            }
        }
        
        
        if ([SMValidation isSubCategorySkillsSelectedAndValidated:[profileDict objectForKey:SKILLS]]) {
            NSLog(@"Valid");
        }else{
            NSLog(@"Not valid");
            [[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"Please select at least one from the selected category." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return NO;
        }
        
        return YES;
    }
    else if (indexProfileDetailPage == 3) { // For fourth profile detail page
        NSString *fromSalary = @"";
        NSString *toSalary = @"";
        if ([profileDict objectForKey:FROM_SALARY]){
            fromSalary = [profileDict objectForKey:FROM_SALARY];
        }
        
        if ([profileDict objectForKey:TO_SALARY]) {
            toSalary = [profileDict objectForKey:TO_SALARY];
        }
        
        if (fromSalary.length > 0 && toSalary.length > 0) {
            if (fromSalary.intValue > toSalary.intValue) {
                [[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"Maximum expected salary should be greater than Minimum expected salary." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                return NO;
            }
        }
        
        BOOL isTermsServicesChecked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"TermsAndServiceChecked"] boolValue];
        if (!isTermsServicesChecked) {
            [[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"Please check the Terms and Services." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return NO;
        }
        
        
        return YES;
    }

    return YES;
}

+ (NSString *) capitalizedString:(NSString *)string{
    return [string capitalizedString];
}

+ (NSString *) getValidString:(NSString *) string{
    if([string isKindOfClass:[NSString class]]){
        return string;
    }
    else{
        return EMPTY_STRING;
    }
}

+ (NSMutableArray *) getSelectedItemsArrayWithSelectedKeyArray:(NSArray *) dropDownListArray serverKey:(NSString *) serverKey filterWithKeyString: (NSString *) nameString IdString:(NSString *) idString  {
    
    NSMutableArray *  selectedObjectsArray  =  [[NSMutableArray alloc] init];
    NSDictionary * dict  =  [[ReusedMethods sharedObject] userProfileInfo];
    NSArray  *  dropDownlistSkillsArray  =  dropDownListArray;// [[[ReusedMethods  sharedObject] dropDownListDict]  objectForKey:@"software_proficiency"];
    
    //id arrayDataString  =  [dict objectForKey:SKILLS];
    id arrayDataString  =  [dict objectForKey:serverKey];
    
    if ([arrayDataString isKindOfClass:[NSString  class]]) {
        NSArray * stringsArray  =  [ReusedMethods getArrayFromString:arrayDataString];
        for (NSString * nameString in stringsArray) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%@ = %@)",nameString,nameString];
            NSArray * array = [dropDownlistSkillsArray  filteredArrayUsingPredicate:predicate];
            [selectedObjectsArray addObjectsFromArray:array];
        }
    }else if ([arrayDataString isKindOfClass:[NSArray  class]]) {
        for (NSNumber * typeId  in arrayDataString) {
            // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%@ = %@)",idString,typeId];
            NSInteger   skillID = [typeId integerValue];
            NSString *strPredicate = [NSString stringWithFormat:@"%@ = %ld",idString, (long)skillID]; //DB_CN_WORKSITE_MINERAL_ID
            NSPredicate *predicate = [NSPredicate predicateWithFormat:strPredicate];
            NSArray *array = [dropDownlistSkillsArray filteredArrayUsingPredicate:predicate];
            [selectedObjectsArray addObjectsFromArray:array];
        }
    }
    return selectedObjectsArray;
}


+ (NSMutableAttributedString *) getAttributeString:(NSString *)labelText{
    return [self getAttributeString:labelText withAlignment:NSTextAlignmentLeft];
}

+ (NSMutableAttributedString *) getAttributeString:(NSString *)labelText withAlignment:(NSTextAlignment)textAlignment{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [paragraphStyle setAlignment:textAlignment];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    return attributedString;
}

+ (BOOL) isPermissionGranted{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    return (authStatus != AVAuthorizationStatusDenied);
}

+ (void) showPermissionRequiredAlert{
    [[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"Swiss Monkey don't have permission to access your camera. Please turn on access from Device Settings -> Swiss Monkey." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
}

+ (BOOL) isProfileFilled{
    float progress = [self profileProgresValue];
    return progress > 0.98;
//    NSDictionary *profileData = [ReusedMethods userProfile];
//    NSString *zipCode = [profileData objectForKey:@"zipcode"];
//    return (zipCode && zipCode.length);
}

+ (BOOL) isZipCodeAvailable{
    NSDictionary *profileData = [ReusedMethods userProfile];
    NSString *zipCode = [profileData objectForKey:@"zipcode"];
    return (zipCode && zipCode.length);
}

+ (NSString *) getVideoIdFromLink:(NSString *) videourl{
    
    NSString *vID = nil;
    NSString *url = videourl ;//@"http://www.youtube.com/watch?v=cAcqdjLCN7s";
    
    if([SMValidation isValidYouTubeUrl:url]){
        NSString *query = [url componentsSeparatedByString:@"?"][1];
        NSArray *pairs = [query componentsSeparatedByString:@"&"];
        for (NSString *pair in pairs) {
            NSArray *kv = [pair componentsSeparatedByString:@"="];
            if ([kv[0] isEqualToString:@"v"]) {
                vID = kv[1];
                break;
            }
        }
        
        NSLog(@"%@", vID);
        return vID;
    }else{
        return nil;
    }
}

+(NSMutableDictionary *)removeNullsInDict:(NSMutableDictionary *)dict
{
    for (NSString *key in [dict allKeys]) {
        if ([dict[key] isEqual:[NSNull null]]) {
            dict[key] = @"";//or [NSNull null] or whatever value you want to change it to
        }
        if ([dict[key] isKindOfClass:[NSDictionary class]])
        {
            NSMutableDictionary * sub = [[NSMutableDictionary alloc] initWithDictionary:[dict objectForKey:key]];
            NSMutableDictionary * subDict =  [self removeNullsInDict:sub];
            [dict setObject:subDict forKey:key];
        }
    }
    return dict;
}

+ (id)cleanJsonToObject:(id)data {
    NSError* error;
    if (data == (id)[NSNull null]){
        return [[NSObject alloc] init];
    }
    id jsonObject;
    if ([data isKindOfClass:[NSData class]]){
        jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    } else {
        jsonObject = data;
    }
    if ([jsonObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *array = [jsonObject mutableCopy];
        for (int i = array.count-1; i >= 0; i--) {
            id a = array[i];
            if (a == (id)[NSNull null]){
                [array removeObjectAtIndex:i];
            } else {
                array[i] = [self cleanJsonToObject:a];
            }
        }
        return array;
    } else if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dictionary = [jsonObject mutableCopy];
        for(NSString *key in [dictionary allKeys]) {
            id d = dictionary[key];
            if (d == (id)[NSNull null]){
                dictionary[key] = @"";
            } else {
                dictionary[key] = [self cleanJsonToObject:d];
            }
        }
        return dictionary;
    } else {
        return jsonObject;
    }
}

#pragma mark - TEXT FIELD CAPITALIZATION

+ (void) setCapitalizationForFirstLetterOfField:(id) field{
    
    // set  capitalization for  textfield  object
    if([field isKindOfClass:[UITextField  class]]){
         UITextField * textField = field;
        if (textField.text.length > 0) {
            NSString *text = [textField text];
            NSString *capitalized = [[[text substringToIndex:1] uppercaseString] stringByAppendingString:[text substringFromIndex:1]];
            
            NSLog(@"%@ uppercased is %@", text, capitalized);
            textField.text = capitalized;
        }
    }
    // set  capitalization for  textview  object

    if([field isKindOfClass:[UITextView  class]]){
        UITextView * textView = field;
        if (textView.text.length > 0) {
            NSString *text = [textView text];
            NSString *capitalized = [[[text substringToIndex:1] uppercaseString] stringByAppendingString:[text substringFromIndex:1]];
            
            NSLog(@"%@ uppercased is  %@", text, capitalized);
            textView.text = capitalized;
        }
    }

}

#pragma mark - TERMS & CONDITIONS Methods

+ (void) checkForUserTermsAndConditionsAccepted{
    if (![[ReusedMethods sharedObject] termsAndConditionsAccepted]) {
        NSString *authToken = [ReusedMethods authToken];
        if (authToken.length > 0) {
            NSMutableDictionary *  parametersDict  =  [[NSMutableDictionary  alloc] init];
            [parametersDict setObject:authToken.length ? authToken : @"" forKey:@"authtoken"];
            
            
            APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_GET_TandC_STATUS ModuleName:MODULE_USER MethodType:METHOD_TYPE_POST Parameters:parametersDict SuccessCallBack:@selector(termsAndConditionsStatusSuccessCall:) AndFailureCallBack:@selector(termsAndConditionsStatusFailed:)];
            
            WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
            [service makeWebServiceCall];
        }
    }

}

+ (void) termsAndConditionsStatusSuccessCall:(WebServiceCalls *)success{
    NSDictionary *dict = success.responseData;
    if ([[dict valueForKey:@"privacy_policy_status"] intValue] == 1) {
        NSLog(@"No need to show T & C Message");
        [[ReusedMethods sharedObject] setTermsAndConditionsAccepted:YES];
    }else{
        NSLog(@"Need to show T & C Message");
        
        NSString* path = [[NSBundle mainBundle] pathForResource:@"Terms of Conditions_Privacy Policy_Swiss Monkey"
                                                         ofType:@"txt"];
        NSString* content = [NSString stringWithContentsOfFile:path
                                                      encoding:NSUTF8StringEncoding
                                                         error:NULL];
        
        RBACustomAlert *tandCAlert = [[RBACustomAlert alloc] initWithTitle:@"Terms of Services & Privacy Policy." message:content delegate:[ReusedMethods sharedObject] cancelButtonTitle:@"AGREE" otherButtonTitles:nil,nil];
        tandCAlert.tag = TERMS_AND_CONDITIONS_ALERT_TAG;
        [tandCAlert show];
    }
}

+ (void) termsAndConditionsStatusFailed:(WebServiceCalls *)failure{
    NSLog(@"Getting user T & C status failed");
}

+ (void) sendUserTermsAndConditionsAccepted{
        NSString *email = [[ReusedMethods userProfile] valueForKey:@"email"];
        NSMutableDictionary *  parametersDict  =  [[NSMutableDictionary  alloc] init];
        [parametersDict setObject:email.length ? email : @"" forKey:@"email"];
        
        
        APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_ACCEPT_TandC ModuleName:MODULE_USER MethodType:METHOD_TYPE_POST Parameters:parametersDict SuccessCallBack:@selector(termsAndConditionsAcceptedSuccessCall:) AndFailureCallBack:@selector(termsAndConditionsAcceptFailed:)];
        
        WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
        [service makeWebServiceCall];
}

+ (void) termsAndConditionsAcceptedSuccessCall:(WebServiceCalls *)success{
    [[ReusedMethods sharedObject] setTermsAndConditionsAccepted:YES];
}

+ (void) termsAndConditionsAcceptFailed:(WebServiceCalls *)failure{
    NSLog(@"T & C accept server call failed.");
}


//#pragma mark  -----------  POPUP VIEW WITH SCROLLABLE TEXT  METHODS  -------------
//
//+  (UIView *) ShowPopUpWithTitleTitle:(NSString *) title descriptionContent:(NSString *)  description{
//    
//    float  xPos  =   10;
//    float verticalgap  =  10;
//    
//    //To add contetView and darkGrayView
//    float width = CGRectGetWidth(darkGrayView.frame) - (2 * xPos);
//    float height = 300;
//    
//    // place  white  popup
//    UIView *  whitePopupView = [[UIView alloc] initWithFrame:CGRectMake(xPos, 0, width, height/3)];
//    [[whitePopupView layer] setCornerRadius:10.0f];
//    [[whitePopupView  layer] setBorderWidth:1.0f];
//    [[whitePopupView layer] setBorderColor:[UIColor clearColor].CGColor];
//    [whitePopupView  setBackgroundColor:[UIColor appWhiteColor]];
////    [ReusedMethods setBackroundOnView:whitePopupView];
//    [darkGrayView addSubview:whitePopupView];
//    
//    float yPos = 10;
//    
//    //  arrange  title label  for  display  item of  checklist  object
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, width - (2 * xPos), 50)];
////    titleLabel.font = [UIFont appBigFont];
//    [titleLabel setText:title];
//    [titleLabel setBackgroundColor:[UIColor clearColor]];
//    [titleLabel setTextColor:[UIColor appBrightTextColor]];
//    [titleLabel setTextAlignment:NSTextAlignmentCenter];
//    [whitePopupView addSubview:titleLabel];
//    
//    [titleLabel resizeToFit];//  resize  title label  based  on text.
//    
//    yPos = CGRectGetMaxY(titleLabel.frame) + verticalgap;
//    
//    UILabel *lblLine = [[UILabel alloc] initWithFrame:CGRectMake(0, yPos, width, 0.5)];
//    [lblLine setBackgroundColor:[UIColor  appLightGrayColor]];
//    [whitePopupView addSubview:lblLine];
//    
//    yPos =  CGRectGetMaxY(lblLine.frame) + verticalgap;
//    
//    NSString *contentInfo;
//    if(description.length)
//        contentInfo = description;
//    else
//        contentInfo = @"No information available";
//    
//    // UIScrollView *  scrlVw  =   [ReusedMethods setUpTextOnScrollableViewWithframe:CGRectMake(0, yPos, width, height) displayText:description withFont:[UIFont appPopUPDescriptionFont] andTextColor:[UIColor appGrayColor]];
//    UIView *  scrlVw  =   [ReusedMethods setUpTextOnScrollableTextViewWithframe:CGRectMake(0, yPos, width, height) displayText:description withFont:[UIFont systemFontOfSize:14] andTextColor:[UIColor appGrayColor]];
//    [whitePopupView addSubview:scrlVw];
//    
//    // resize  white popup frame  based on maximum  length.
//    yPos = CGRectGetMaxY(scrlVw.frame) + verticalgap;
//    
//    CGRect frame = [whitePopupView bounds];
//    frame.size.height = yPos;
//    [whitePopupView setFrame:frame];
//    [whitePopupView setCenter:CGPointMake(darkGrayView.center.x, darkGrayView.center.y)];
//    
//    return darkGrayView;
//}
//
//+ (UIView *) setUpTextOnScrollableTextViewWithframe: (CGRect) viewFrame  displayText:(NSString *) text withFont:(UIFont *) fontName andTextColor:(UIColor *) textColor{
//    
//    UIView  *BGView = [[UIView alloc] initWithFrame:viewFrame];
//    
//    UITextView *  descriptionTextView  =   [[UITextView alloc] initWithFrame:CGRectMake(5, 0, viewFrame.size.width - (2 * 5), viewFrame.size.height)];
//    [descriptionTextView setBackgroundColor:[UIColor clearColor]];
//    [descriptionTextView setTextColor:textColor];
//    [descriptionTextView setFont:fontName];
//    [descriptionTextView setEditable:NO];
//    [descriptionTextView setDataDetectorTypes:UIDataDetectorTypeAll];
//    [descriptionTextView setText:text];
//    [descriptionTextView setTextAlignment:NSTextAlignmentLeft];
//    descriptionTextView.showsVerticalScrollIndicator=NO;
//    [descriptionTextView setContentInset:UIEdgeInsetsMake(-1.0, 0, 0, 0)];
//    [descriptionTextView setTextContainerInset:UIEdgeInsetsZero];
//    [BGView addSubview:descriptionTextView];
//    
//    
//    CGSize newSize = [descriptionTextView sizeThatFits:CGSizeMake(viewFrame.size.width - (2 * 5), MAXFLOAT)];
//    
//    CGFloat  contentHeight  = newSize.height;
//    
//    float scrlHeight = contentHeight - viewFrame.size.height;
//    if(scrlHeight < 0){
//        scrlHeight = contentHeight ;
//    }
//    else
//        scrlHeight = viewFrame.size.height;
//    
//    // resize frames
//    
//    CGRect  descFrame =   descriptionTextView.frame;
//    descFrame.size.height  =   scrlHeight;
//    descriptionTextView.frame  =   descFrame;
//    
//    CGRect  scrlFrame =   BGView.frame;
//    scrlFrame.size.height  =   scrlHeight;
//    BGView.frame  =   scrlFrame;
//    
//    return BGView;
//}
//
//+ (void) setUpPopUpViewOnViewController:(UIViewController *) viewControlr{
//    
//    darkGrayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewControlr.view.frame.size.width , viewControlr.view.frame.size.height)];
//    [darkGrayView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
//    
//    UIButton * closeButton = [[UIButton alloc] initWithFrame: CGRectMake(darkGrayView.frame.size.width-40, 25, 25, 25)];
//    [closeButton setImage:[UIImage imageNamed:@"cross_black"] forState:UIControlStateNormal];
//    [closeButton addTarget:viewControlr
//                    action:@selector(closePopupButtonAction:) forControlEvents:UIControlEventTouchUpInside];
////    [closeButton  setTag:CLOSE_BUTTON_TAG];
//    [closeButton setBackgroundColor:[UIColor whiteColor]];
//    [darkGrayView addSubview:closeButton];
//}


#pragma mark - Top/Bottom borders for selection

+ (void)applyTopBorderIndicator:(UIView*) view {
    [self applyTopBorderIndicator:view borderWidth:5.0f borderColor:[UIColor appCustomLightGreenColor]];
}

+ (void)applyTopBorderIndicator:(UIView*) view
                    borderWidth:(float) borderWidth
                    borderColor:(UIColor*) borderColor{
    
    //Remove the existing one if there is
    [self removeTopBorder:view];
    
    float height = borderWidth;
    UIView *topBorderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, height)];
    
    UIColor *color = borderColor;
    topBorderView.backgroundColor = color;
    topBorderView.tag = 99999;
    [view addSubview:topBorderView];
    
    
    NSLayoutConstraint *leadingContraint = [NSLayoutConstraint constraintWithItem:topBorderView
                                                                        attribute:NSLayoutAttributeLeading
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:view
                                                                        attribute:NSLayoutAttributeLeading
                                                                       multiplier:1.0
                                                                         constant:0];
    
    NSLayoutConstraint *trailingContraint = [NSLayoutConstraint constraintWithItem:topBorderView
                                                                         attribute:NSLayoutAttributeTrailing
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:view
                                                                         attribute:NSLayoutAttributeTrailing
                                                                        multiplier:1.0
                                                                          constant:0];
    
    NSLayoutConstraint *topContraint = [NSLayoutConstraint constraintWithItem:topBorderView
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:view
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0
                                                                     constant:0];
    
    NSLayoutConstraint *heightContraint = [NSLayoutConstraint constraintWithItem:topBorderView
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:height];
    
    
    [NSLayoutConstraint activateConstraints:@[leadingContraint, trailingContraint, topContraint, heightContraint]];
    topBorderView.translatesAutoresizingMaskIntoConstraints = FALSE;
}

+ (void)removeTopBorder:(UIView*)view{
    UIView *subView = [view viewWithTag:99999];
    if (subView) {
        [subView removeFromSuperview];
    }
}


+ (void)applyBottomBorderIndicator:(UIView*) view {
    [self applyBottomBorderIndicator:view borderWidth:5.0f borderColor:[UIColor appCustomBrightBlueColor]];
}

+ (void)applyBottomBorderIndicator:(UIView*) view
                       borderWidth:(float) borderWidth
                       borderColor:(UIColor*) borderColor{
    
    //Remove the existing one if there is
    [self removeBottomBorder:view];
    
    float height = borderWidth;
    UIView *bottomBorderView = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - height, view.frame.size.width, height)];
    
    UIColor *color = borderColor;
    bottomBorderView.backgroundColor = color;
    bottomBorderView.tag = 88888;
    [view addSubview:bottomBorderView];
    
    NSLayoutConstraint *leadingContraint = [NSLayoutConstraint constraintWithItem:bottomBorderView
                                                                        attribute:NSLayoutAttributeLeading
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:view
                                                                        attribute:NSLayoutAttributeLeading
                                                                       multiplier:1.0
                                                                         constant:0];
    
    NSLayoutConstraint *trailingContraint = [NSLayoutConstraint constraintWithItem:bottomBorderView
                                                                         attribute:NSLayoutAttributeTrailing
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:view
                                                                         attribute:NSLayoutAttributeTrailing
                                                                        multiplier:1.0
                                                                          constant:0];
    
    NSLayoutConstraint *bottomContraint = [NSLayoutConstraint constraintWithItem:bottomBorderView
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:view
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0
                                                                        constant:0];
    
    NSLayoutConstraint *heightContraint = [NSLayoutConstraint constraintWithItem:bottomBorderView
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:height];

    
    [NSLayoutConstraint activateConstraints:@[leadingContraint, trailingContraint, bottomContraint, heightContraint]];
    bottomBorderView.translatesAutoresizingMaskIntoConstraints = FALSE;
}

+ (void)removeBottomBorder:(UIView*)view{
    UIView *subView = [view viewWithTag:88888];
    if (subView) {
        [subView removeFromSuperview];
    }
}

#pragma mark - Apply 3D shadow for view

+ (void)applyShadowToView:(UIView*)view {
    
    [self applyShadowToView:view
                     radius:5.0f
                borderWidth:0.1f
              shadowOpacity:0.2f
               shadowRadius:2.0f];
    
}

+ (void)applyShadowToView:(UIView*)view
                   radius:(float)radius
              borderWidth:(float)borderWidth
            shadowOpacity:(float)shadowOpacity
             shadowRadius:(float)shadowRadius {
    
    [view.layer setCornerRadius:radius];
    [view.layer setBorderWidth:borderWidth];
    [view.layer setBorderColor:[UIColor appLightGrayColor].CGColor];
    
    [view.layer setShadowColor:[UIColor blackColor].CGColor];
    [view.layer setShadowOpacity:shadowOpacity];
    [view.layer setShadowRadius:shadowRadius];
    [view.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    
}

#pragma mark - Button Customization

+ (void)applyPurpleButtonStyle: (UIButton*)button {
    
    [self applyButtonStyle:button color:[UIColor appCustomPurpleColor] cornerRadius:0];
}

+ (void)applyBlueButtonStyle: (UIButton*)button {
    
    [self applyButtonStyle:button color:[UIColor appCustomBrightBlueColor] cornerRadius:7.f];
}

+ (void)applyGreenButtonStyle: (UIButton*)button {
    
    [self applyButtonStyle:button color:[UIColor appCustomLightGreenColor] cornerRadius:7.f];
}

+ (void)applyButtonStyle: (UIButton*)button color:(UIColor*)color cornerRadius:(float)radius{
    button.backgroundColor = color;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
   
    float cornerRadius = radius > 0. ? radius : 10.f;
    [button.layer setBorderWidth:.1f];
    [button.layer setCornerRadius:cornerRadius];
    [button.layer setBorderColor:color.CGColor];
    
    [button.layer setShadowColor:[UIColor blackColor].CGColor];
    [button.layer setShadowOpacity:0.3];
    [button.layer setShadowRadius:2.5];
    [button.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
}


#pragma mark - Job Types

+ (NSArray*)arrayJobTypes {
    
    return @[@{@"key" : @"FULL_TIME", @"value" : @"Full-time"},
             @{@"key" : @"PART_TIME", @"value" : @"Part-time"},
             @{@"key" : @"EXTERNSHIP", @"value" : @"Externship"},
//             @{@"key" : @"DAILY", @"value" : @"Daily"},
             @{@"key" : @"TEMP", @"value" : @"Temporary"},
//             @{@"key" : @"TEMP_IMMEDIATE", @"value" : @"Temp - Immediate (needed within 24 hours)"},
             @{@"key" : @"OTHER", @"value" : @"Other"}];
}

#pragma mark - Compensation Preference

+ (void)applyTextFilteringForCompensationPreferences {
    
    NSString *COMPRANGE = @"comprange";
    NSArray *arrayCompRange = [[ReusedMethods sharedObject].dropDownListDict objectForKey:COMPRANGE];
    
    if (arrayCompRange && arrayCompRange.count) {
        NSMutableArray *arrayNewComps = [NSMutableArray arrayWithCapacity:4];
        
        for (NSDictionary *dicComp in arrayCompRange) {
            NSString *strCompName = [dicComp objectForKey:@"compensation_name"];
            NSMutableDictionary *dicNewComp = [NSMutableDictionary dictionaryWithDictionary:dicComp];
            
            if ([strCompName.lowercaseString isEqualToString:@"daily"]) {
                [dicNewComp setObject:@"Hourly" forKey:@"compensation_name"];
                [arrayNewComps addObject:dicNewComp];
            }
            else if ([strCompName.lowercaseString isEqualToString:@"salary"]) {
                [dicNewComp setObject:@"Monthly" forKey:@"compensation_name"];
                [arrayNewComps addObject:dicNewComp];
            }
            else if ([strCompName.lowercaseString isEqualToString:@"hourly"]) {
                [dicNewComp setObject:@"Annually" forKey:@"compensation_name"];
                [arrayNewComps addObject:dicNewComp];
            }
            else if ([strCompName.lowercaseString isEqualToString:@"other"]) {
                [dicNewComp setObject:@"Other" forKey:@"compensation_name"];
                [arrayNewComps addObject:dicNewComp];
            }
        }
        
        [[ReusedMethods sharedObject].dropDownListDict setObject:arrayNewComps forKey:COMPRANGE];
        
    }
}
@end
