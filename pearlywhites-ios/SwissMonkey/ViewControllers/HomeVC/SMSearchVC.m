//
//  SMSearchVC.m
//  SwissMonkey
//
//  Created by Baalu on 3/11/16.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import "SMSearchVC.h"
#import "SMJobResultsVC.h"
#import "SMJobProfileDescriptionVC.h"

@interface SMSearchVC ()<SMSearchModelDelegate>

@end

@implementation SMSearchVC{
    BOOL isAdvancedSearch;
    MARKRangeSlider *rangeSlider;
}

@synthesize smSearchModel, findNowButton, titleLabel, rangeDecrementButton, rangeIncrementButton;


#pragma mark - LIFE CYCLE  METHODS

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    isAdvancedSearch  =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"isAdvancedSearch"] boolValue];
    _smJobResultsVC  =  [self.storyboard  instantiateViewControllerWithIdentifier:SM_JOBRESULTS_VC];
    [self commonInit];
    [self  updateUI];
    [UIFont appLatoLightFont14];
    //    [ReusedMethods saveUserProfile];
    
//    if(![[[ReusedMethods sharedObject].dropDownListDict allKeys] count])
    [smSearchModel callDropDownListMethods];
    // set  up  navigation  view  on the  view
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isHome"] boolValue]){
        
        NSString * titleString  = isAdvancedSearch  ? @"Advanced Search"  :  @"Welcome";
        NSString *  imagName  = isAdvancedSearch  ?  @"back" : @"nav_menu_toggle";
        NSInteger  notificationCount  =  isAdvancedSearch  ?  0  :  smSearchModel.notificationsListArray.count;
        NSString * rightImgname  = isAdvancedSearch  ? @"" :  @"alert_btn";
        [ReusedMethods setNavigationViewOnView:self.view WithTitle:titleString andBackgroundColor:[UIColor whiteColor]];
//        [ReusedMethods setNavigationViewOnView:self.view WithTitle:titleString andBackgroundColor:[UIColor applightNavColor]];
        [ReusedMethods setUpLeftButton:self withImageName:imagName];
        
        _rightButton = [ReusedMethods setUpRightButton:self withImageName:rightImgname withNotificationsCount:notificationCount];
        [self.menuButton addTarget:self action:@selector(navViewLeftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
//        if ([ReusedMethods isAccountInActive] && isAdvancedSearch == 0) {
          //  [self addActivityView:_rightButton];
           // [smSearchModel makeApiCallForNotificationsList];
//        }
        
        
        //  make  notifications  call  only  for  first  time after login
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        BOOL firstTime = [userDefaults boolForKey:@"firstTime"];
        if(firstTime){
            [smSearchModel makeApiCallForNotificationsList];
        }
        
    }
    
    // Setting notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(PushNotificationCountUpdate)
                                                 name:@"PushNotificationCountUpdate" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    isAdvancedSearch? : [self notificationSuccessCall];
    
    // call  notifications  method for display
}


- (void) addActivityView:(UIView *) button{
    if(![[UIApplication sharedApplication] isRegisteredForRemoteNotifications]){
        return;
    }
    if(!_progress)
    {
        _progress = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(button.frame.size.width/2, button.frame.size.height/2, 20, 20)];
//        _progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _progress.color = [UIColor blackColor];
        //_progress.center  = button.center;
        [_progress startAnimating];
    }
    [button addSubview:_progress];
    //button.userInteractionEnabled = NO;
}

- (void) removeActiviyIndicator{
    [_progress stopAnimating];
    [_progress removeFromSuperview];
    //_rightButton.userInteractionEnabled = YES;
}

- (void) updateUI{
    
    //Customize the Find Now Button
    [ReusedMethods applyPurpleButtonStyle:self.findNowButton];

    if(isAdvancedSearch){
        
        [self updateWorkDayPreferencesConstaintswithBooleanValue:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"jobtype"]];
        
        //Remove the bottom line from the selectors
        [[(JVFloatLabeledTextField*)self.positionTxtFld botomBorder] setHidden:YES];
        self.experienceTxtFld.botomBorder.hidden = YES;
        self.jobTypeTxtFld.botomBorder.hidden = YES;
        self.compensationTimingsTextFld.botomBorder.hidden = YES;
        
        //Apply the shadow effect on the selectors
        [ReusedMethods applyShadowToView:self.positionContainerView];
        [ReusedMethods applyShadowToView:self.experienceContainerView];
        [ReusedMethods applyShadowToView:self.jobTypeContainerView];
        [ReusedMethods applyShadowToView:self.compensationContainerView];
        [ReusedMethods applyShadowToView:self.workDayPreferencesView];
        
        //Populate the job types from Profile
        NSArray *arrayJobtypes = [[[ReusedMethods sharedObject] userProfileInfo] objectForKey:JOB_TYPES];
        if (!arrayJobtypes) arrayJobtypes = [NSArray array];
        NSPredicate *predict = [NSPredicate predicateWithFormat:@"key IN %@", arrayJobtypes];
        arrayJobtypes = [[ReusedMethods arrayJobTypes] filteredArrayUsingPredicate:predict];
        
        if (arrayJobtypes.count) {
            [smSearchModel.searchDict setObject:[arrayJobtypes valueForKey:@"key"] forKey:JOB_TYPE];
        }
        
        NSString *strJobTypes = [[arrayJobtypes valueForKey:@"value"] componentsJoinedByString:@", "];
        self.jobTypeTxtFld.text = strJobTypes;
        
        
        
    }
    else {
        
        [ReusedMethods applyShadowToView:self.selectPositionContainerView
                                  radius:10.0f
                             borderWidth:0.1f
                           shadowOpacity:0.5f
                            shadowRadius:5.0f];
        
        
    }
}

#pragma mark - Menu Helper Functions
- (void)commonInit{
    smSearchModel  =  [[SMSearchModel alloc] init];
    smSearchModel.delegate  = self;
    [self setAllDefaultData2Dict];
    [smSearchModel menuPopoverOfViewController:self];
}

- (void) setAllDefaultData2Dict{
    NSInteger minimumSearchMiles =  [[[[[[ReusedMethods sharedObject] dropDownListDict] objectForKey:@"location_range"] objectAtIndex:kMIN_MILES_INDEX] objectForKey:@"to_range"] integerValue];
    [self setMilesInDict:kMIN_MILES];
    [self setFromValue:kLEFT_DEFAULT_SLIDER * 1000 toValue:kRIGHT_DEFAULT_SLIDER * 1000];
    
    NSArray *arrayShifts = [[ReusedMethods sharedObject].dropDownListDict objectForKey:@"shifts"];
    for (NSDictionary *dict in arrayShifts) {
        NSMutableDictionary *shiftDict = [NSMutableDictionary dictionaryWithObject:[dict objectForKey:@"shift_id"] forKey:@"shiftID"];
        [smSearchModel.shiftsArray addObject:shiftDict];
    }
}

- (void) setFromValue:(NSInteger) from toValue:(NSInteger) to{
    if(isAdvancedSearch){
        [smSearchModel.searchDict setObject:@(from) forKey:@"fromCompensation"];
        [smSearchModel.searchDict setObject:@(to) forKey:@"toCompensation"];
    }
}

- (void) setMilesInDict:(NSInteger) miles{
    [smSearchModel.searchDict setObject:@(miles) forKey:@"miles"];
}

#pragma mark - UI Dropdown Interactions

- (IBAction)clickedSelectPosition:(id)sender {
    
    NSMutableDictionary  *totalListDict = [[ReusedMethods sharedObject] dropDownListDict];
    NSString *keyString =  @"positions";
    
    NSDictionary *selectAllDict = [NSDictionary dictionaryWithObjects:@[@"Select All",@0] forKeys:@[@"position_name", @"position_id"]];
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithArray:[totalListDict  objectForKey:keyString]];
    
    if (dataArray.count > 0){
        if (smSearchModel.selectedPositionsArray.count == dataArray.count) {
            [smSearchModel.selectedPositionsArray insertObject:selectAllDict atIndex:0];
        }
        [dataArray insertObject:selectAllDict atIndex:0];
    }
    
    [ReusedMethods addMultiplePopupViewWithVC:self
                                    dataArray:dataArray
                                      dataKey:@"position_name"
                                       idName:@"position_id"
                                    textField:self.positionTxtFld
                             andSelectedItems:smSearchModel.selectedPositionsArray
                                      withTag:kPosition];
    
}

- (IBAction)clickedExperiece:(id)sender {
    UITextField *textField = self.experienceTxtFld;
    NSMutableDictionary  *  totalListDict  =  [[ReusedMethods sharedObject] dropDownListDict];
    NSString *  keyString  =  [smSearchModel getKeyForDropDownListOfTextFieldTag:[textField  tag]];
    
    [ReusedMethods setupPopUpViewForTextField:textField
                             withDisplayArray:[totalListDict objectForKey:keyString]
                                      withDel:self
                                   displayKey:@"experience_range"
                                    returnKey:@"experience_range_id"
                                      withTag:kExperience];
}

- (IBAction)clickedJobType:(id)sender {
    UITextField *textField = self.jobTypeTxtFld;
    
    NSArray *arrayJobtypes = [smSearchModel.searchDict objectForKey:JOB_TYPE];
    if (!arrayJobtypes) arrayJobtypes = [NSArray array];
    NSPredicate *predict = [NSPredicate predicateWithFormat:@"key IN %@", arrayJobtypes];
    arrayJobtypes = [[ReusedMethods arrayJobTypes] filteredArrayUsingPredicate:predict];
    
    [ReusedMethods setupPopUpViewForTextField:textField
                             withDisplayArray:[ReusedMethods arrayJobTypes]
                                      withDel:self
                                   displayKey:@"value"
                                    returnKey:@"value"
                                      withTag:kJobType
                                isMultiSelect:YES
                             selectedPosItems:arrayJobtypes];
}

- (IBAction)clickedCompensation:(id)sender {
    UITextField *textField = self.compensationTimingsTextFld;
    NSMutableDictionary  *  totalListDict  =  [[ReusedMethods sharedObject] dropDownListDict];
    NSString *  keyString  =  [smSearchModel getKeyForDropDownListOfTextFieldTag:[textField  tag]];
    
    [ReusedMethods setupPopUpViewForTextField:textField
                             withDisplayArray:[totalListDict objectForKey:keyString]
                                      withDel:self
                                   displayKey:@"compensation_name"
                                    returnKey:@"compensation_id"
                                      withTag:kCompRange];
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
    
    if(![ReusedMethods isZipCodeAvailable])
    {
        RBACustomAlert *alert = [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"We recommend to update your profile for better search result." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert setTag:12];
        [alert show];
        return;
    }
    
    [smSearchModel setUpNotificationsView];
    //  make  notifications  call  only  for  first  time after login
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL firstTime = [userDefaults boolForKey:@"firstTime"];
    if(firstTime){
        [self addActivityView:smSearchModel.bGView];

    }else{
        
        // viewed objects  APi
        [smSearchModel makeApiCallForViewedNotificationsList];
    }

}



- (IBAction)findNowButtonAction:(id)sender {

    [self.view endEditing:YES];
    //Checking for user activation.
    if([ReusedMethods isZipCodeAvailable])
    {
        if ([ReusedMethods isAccountInActive]) {
            BOOL isValidZip = NO;
            BOOL isValidRange = !isAdvancedSearch;
            BOOL isValidForJobType = !isAdvancedSearch;
            
            //        NSString *fullTime = @"FullTime".lowercaseString;
            //        NSString *selectedString = [_jobTypeTxtFld.text lowercaseString];
            //        selectedString = [selectedString stringByReplacingOccurrencesOfString:@"-" withString:@""];
            //        if(![fullTime isEqualToString:selectedString] && selectedString.length > 0){
            //            for (NSDictionary *dict in [self.smSearchModel.searchDict valueForKey:@"shifts"]) {
            //                if ([[dict valueForKey:@"days"] count]) {
            //                    isValidForJobType = YES;
            //                }
            //            }
            //        }
            //        else{
            //            isValidForJobType = YES;
            //        }
            isValidForJobType = YES;
            
            //Initialize the search zip code
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"searchZipCode"];
            
            //Checking for valid zip code
            if (![SMValidation emptyTextValidation:_locationTxtFld.text]) {
                isValidZip = YES;
            }else{
                if ([SMValidation isCharectersString:_locationTxtFld.text]) {
                    if ([SMValidation isNumericString:_locationTxtFld.text]) {
                        if ([SMValidation isValidZipCode:_locationTxtFld.text]) {
                            isValidZip = YES;
                            
                            //Store the zipcode
                            [[NSUserDefaults standardUserDefaults] setObject:_locationTxtFld.text forKey:@"searchZipCode"];
                        }else{
                            isValidZip = NO;
                        }
                    }else{
                        isValidZip = YES;
                    }
                    
                }else{
                    isValidZip = NO;
                }
            }
            
            if (isValidZip && isValidForJobType) {
                if(!isValidRange){
                    NSString *strFRange = [self.rangeFromTxtFld.text stringByReplacingOccurrencesOfString:@"$" withString:@""];
                    NSString *strTRange = [self.rangeToTxtFld.text stringByReplacingOccurrencesOfString:@"$" withString:@""];
                    
                    if (self.compensationTimingsTextFld.text.length > 0) {
                        if(strFRange.length > 0 && strTRange.length > 0){
                            float from = -1;
                            
                            if(strTRange.length)
                                from = [strFRange floatValue];
                            float to = [strTRange floatValue];
                            isValidRange = from < to;
                        }else{
                            [[[RBACustomAlert alloc] initWithTitle:@"Please enter valid compensation range" message:@"Please enter both compensation values" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                            return;
                        }
                    }else{
                        if((strFRange.length == 0 && strTRange.length == 0) || (strFRange.length > 0 && strTRange.length > 0)){
                            float from = -1;
                            
                            if(strTRange.length)
                                from = [strFRange floatValue];
                            float to = [strTRange floatValue];
                            isValidRange = from < to;
                        }else{
                            [[[RBACustomAlert alloc] initWithTitle:@"Please enter valid compensation range" message:@"Please enter both compensation values" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                            return;
                        }
                    }
                    
                }
                
                if(isValidRange)
                {
                    [smSearchModel makeServerCallForJobSearch];

                }
                else
                    [[[RBACustomAlert alloc] initWithTitle:@"Please enter valid comensation range" message:@"'To Range' should be greater than 'From Range'" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }else{
                [[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"Please enter valid data." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            
        }else{
            [[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:ACCOUNT_DEACTIVATED_MESSAGE delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }else{
        RBACustomAlert *alert = [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"We recommend to update your profile for better search result." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert setTag:12];
        [alert show];
    }
}

- (IBAction)advancedSearchButtonAction:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isAdvancedSearch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.titleLabel  setText:@"Advanced Search"];
    UIButton *  rightButton  =  (UIButton *) [self.view  viewWithTag:RIGHT_BUTTON_TAG];
    //[rightButton removeFromSuperview];
    //[ReusedMethods  setUpRightButton:self withImageName:@"home" withNotificationsCount:0];
    [rightButton setHidden:YES];
//    //[ReusedMethods checkAppFlow];
    
    SMSearchVC  * search  =  [self.storyboard  instantiateViewControllerWithIdentifier:SM_ADVANCED_SEARCH_VC];

    [self.navigationController  pushViewController:search animated:YES];
}

- (IBAction)rangeIncrementButtonAction:(id)sender {
    [self incrOrDecrMiles:sender];
}

- (IBAction)rangeDecrementButtonAction:(id)sender {
    [self incrOrDecrMiles:sender];
}

- (void) incrOrDecrMiles:(id) sender{
//    NSInteger miles = [smSearchModel  updateRangeTextFieldText:[self.rangeTxtFld text] withSender:sender];
//    [self setMilesInDict:miles];
//    self.rangeTxtFld.text = [NSString stringWithFormat:@"%ld miles",miles];
    
    NSDictionary *rangeDict = [smSearchModel  updateRangeTextFieldTextDict:[self.rangeTxtFld text] withSender:sender];
    [self setMilesInDict:[[rangeDict objectForKey:@"to_range"] integerValue]];
    self.rangeTxtFld.text = [rangeDict  objectForKey:@"miles_range"];//[NSString stringWithFormat:@"%ld miles",miles];
 
}

- (IBAction) workDayPreferencesButtonAction:(id)sender{
    [smSearchModel changeWorkDayPreferencesButtonStateOfButton:(UIButton *) [self.workDayPreferencesView  viewWithTag:[sender tag]]];
}

#pragma mark - PROGRESS VIEW  METHOPDS


- (void) setupProgressView{
    _compensationRangeProgressView.hidden = YES;
    self.rangeFromTxtFld.tag = HOME_COMPENSATION_FROM_FIELD;
    self.rangeToTxtFld.tag = HOME_COMPENSATION_TO_FIELD;
    rangeSlider = [smSearchModel  setUpProgressViewOnView:self.compensationRangeProgressView];
    [self.rangeFromTxtFld  setText:[NSString  stringWithFormat:@"$%d",(int)roundf(rangeSlider.leftValue ) * 1000]];
    [self.rangeToTxtFld  setText:[NSString  stringWithFormat:@"$%d",(int)roundf(rangeSlider.rightValue) * 1000]];
}

#pragma mark - TEXTFIELD  DELEGATE  METHODS
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    return [smSearchModel textFieldShouldBeginEditing:textField];
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    [smSearchModel textFieldDidEndEditing:textField];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    return [smSearchModel textFieldShouldReturn:textField];
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return [smSearchModel textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

#pragma mark - RBAPOPUP DELEGATE  METHODS

- (void) selectedMultipleValueData:(NSMutableArray *)selectedData withkeyId:(NSString *)keyId andKey:(NSString *)key andDataType:(PopupType)dataType{
    
    if (dataType == kJobType) {
        
        NSArray *valueArray = [selectedData valueForKey:@"key"];
        [smSearchModel.searchDict setObject:valueArray forKey:JOB_TYPE];
        
    }
    else if (dataType == kPosition) {
    
        NSString *keyType = @"position";
        smSearchModel.selectedPositionsArray = selectedData;
        NSMutableArray * selectedIdsArray = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in selectedData) {
            [selectedIdsArray addObject:[dict objectForKey:keyId]];
        }
        
        [smSearchModel.searchDict setObject:selectedIdsArray forKey:keyType];
    }
}

- (void) selectedValue:(id)value withKeyId:(NSString *) keyId titleName:(NSString *)titleName withKey:(NSString *)key selectedCell:(UITableViewCell *)selectedCell withType:(PopupType) typePopup{
    NSString *keyType = @"position";
    switch (typePopup) {
        case kExperience:
            
            keyType = @"experience";
            break;
        case kCompRange:
            
            keyType = COMRANGE;
            break;
            
        default:
            
            break;
        case kJobType:
            ;
            keyType = @"job_type";
//            NSString *fullTime = @"FullTime".lowercaseString;
//            NSString *selectedString = [titleName lowercaseString];
//            selectedString = [selectedString stringByReplacingOccurrencesOfString:@"-" withString:@""];
//            keyType = @"jobtype";
//            if(![fullTime isEqualToString:selectedString]){
                [smSearchModel.searchDict setObject:smSearchModel.shiftsArray forKey:@"shifts"];
//            }
//            else{
//                [smSearchModel.searchDict removeObjectForKey:@"shifts"];
//            }
            break;
            
    }
    [smSearchModel.searchDict setObject:value forKey:keyType];
    [self updateWorkDayPreferencesConstaintswithBooleanValue:smSearchModel.searchDict];
    
    //    NSLog(@"%@", smHomeModel.searchDict);
}

- (void)popTipViewWasDismissedByUser:(RBAPopup *)popTipView{
    
}

- (void) moveToJobResultsVC{
    _smJobResultsVC.viewTitleString = @"Job Results";
    _smJobResultsVC.arrayJobs = _jobs;
    _smJobResultsVC.savedJobs = _savedJobs;
    
    //SMSearchVC  * search  =  [self.storyboard  instantiateViewControllerWithIdentifier:SM_ADVANCED_SEARCH_VC];
    
    [self.navigationController  pushViewController:_smJobResultsVC animated:YES];
}

#pragma mark - Model Delegate Methods

-(void)serverCallSuccessRespone:(NSDictionary *)jobDict{
    _jobs = nil;
    _jobs = [jobDict objectForKey:@"jobs"];
    if(_jobs.count){
        [self moveToJobResultsVC];
       // [smSearchModel makeServerCallForSavedJobs];
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

- (void)rangeSliderValueDidChange:(MARKRangeSlider *)slider {
    //    NSLog(@"%0.2f - %0.2f", slider.leftValue, slider.rightValue);
    //    [self.rangeFromTxtFld  setText:[NSString  stringWithFormat:@"$%d",(int)roundf(rangeSlider.leftValue )]];
    //    [self.rangeToTxtFld  setText:[NSString  stringWithFormat:@"$%d",(int)roundf(rangeSlider.rightValue)]];
    NSInteger from = roundf(rangeSlider.leftValue ) * 1000;
    NSInteger to = roundf(rangeSlider.rightValue) * 1000;
    [self.rangeFromTxtFld  setText:[NSString  stringWithFormat:@"$%ld", from]];
    [self.rangeToTxtFld  setText:[NSString  stringWithFormat:@"$%ld",to]];
    [self setFromValue:from toValue:to];
}

- (void) updateWorkDayPreferencesConstaintswithBooleanValue:(NSMutableDictionary *) updateDataDict{
    if (updateDataDict[@"jobtype"]){
//        if([[updateDataDict objectForKey:@"jobtype"] intValue] == 1){
//            
//            [self.workDayPreferencesView setHidden:YES];
//            [self.workDayPreferencesLabel setHidden:YES];
//            
//            self.workDayPreferencesLabelHeight.constant  =  0;
//            self.workDayPreferencesViewHeight.constant  = 0 ;
//            self.compensationTimingsLabelHeightConstraint.constant = 0;
//            
//            
//            self.contentHeightConstraignt.constant  =  950 - 240;
//            
//        }else
        {
            [self.workDayPreferencesView setHidden:NO];
            [self.workDayPreferencesLabel setHidden:NO];
            
            self.workDayPreferencesLabelHeight.constant  =  20;
            self.workDayPreferencesViewHeight.constant  =  220;
            self.compensationTimingsLabelHeightConstraint.constant = 10;

            
            self.contentHeightConstraignt.constant  =  1100;
        }
        
        [self.contentView setNeedsDisplay];
    }
}

- (void) alertView:(RBACustomAlert *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 12){
        if(buttonIndex == alertView.cancelButtonIndex){
            self.navigationController.viewControllers = @[smSearchModel.profileVC];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isHome"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber  numberWithBool:NO] forKey:@"isAdvancedSearch"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

// notifications

- (void) notificationSuccessCall{
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:NOTIFICATIONS_ARRAY];
    NSMutableArray *savedArray = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    
    [smSearchModel.notificationsListArray removeAllObjects];
    [smSearchModel.notificationsListArray addObjectsFromArray:savedArray];
    
    if(smSearchModel.notificationsListArray.count){
        [smSearchModel.bGView addSubview:smSearchModel.notificationsTbleView];
        [smSearchModel.footerSectionTitle  removeFromSuperview];
        
    }else{
        [smSearchModel.notificationsTbleView removeFromSuperview];
        [smSearchModel displayNoItemsFoundMessage];
        // [self  removeActiviyIndicator];
        
    }
    
    
    NSNumber  *nonVisitedNotificationsCount  = [[NSUserDefaults standardUserDefaults] objectForKey:USER_NOTIFICATIONS_COUNT];
    
    NSString * titleString  = isAdvancedSearch  ? @"Advanced Search"  :  @"Welcome";
    NSString *  imagName  =  isAdvancedSearch  ?  @"back" : @"nav_menu_toggle";
    int  notificationCount  =  isAdvancedSearch  ?  0  : [nonVisitedNotificationsCount intValue] ;
    NSString * rightImgname  = isAdvancedSearch  ? @"" :  @"alert_btn";
    
    
    //Removing navigation view from view
    for (UIView *navView in self.view.subviews) {
        if (navView.tag == NAVIGATION_VIEW_TAG||navView.tag == LEFT_BUTTON_TAG||navView.tag == RIGHT_BUTTON_TAG) {
            [navView removeFromSuperview];
        }
    }
    
    // set  up  navigation  view  on the  view
    [ReusedMethods setNavigationViewOnView:self.view WithTitle:titleString andBackgroundColor: [UIColor whiteColor]];
    [ReusedMethods setUpLeftButton:self withImageName:imagName];
    [ReusedMethods setUpRightButton:self withImageName:rightImgname withNotificationsCount:notificationCount];
    [self.menuButton addTarget:self action:@selector(navViewLeftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self removeActiviyIndicator];
    [smSearchModel.notificationsTbleView reloadData];
    
}

#pragma mark - NOTIFIATIONS  TABLE VIEW DELEGATE METHODS

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [smSearchModel  tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

- (NSInteger)  tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [smSearchModel tableView:tableView numberOfRowsInSection:section];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [smSearchModel numberOfSectionsInTableView:tableView];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [smSearchModel tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [smSearchModel tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [self moveToJobResultsVC];
    // [[tableView  superview]  removeFromSuperview];
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

-(void) notificationsViewJobButtonAction:(NSDictionary *) jobDetails{
    
    SMJobProfileDescriptionVC * smJobProfileDescVC  =  [self.storyboard instantiateViewControllerWithIdentifier:SM_JOB_PROFILE_DESC_VC];
    [smJobProfileDescVC setJobDetails:jobDetails];
    [self.navigationController pushViewController:smJobProfileDescVC animated:YES];
}

-(void) PushNotificationCountUpdate{
    
    [self notificationSuccessCall];
    
}



#pragma mark - Slide Menu Display
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
