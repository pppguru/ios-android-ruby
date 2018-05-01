//
//  SMSearchModel.m
//  SwissMonkey
//
//  Created by Baalu on 3/11/16.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import "SMSearchModel.h"
#import "NotificationsTableCell.h"
#import "SMHelpVC.h"
#import "SMSearchVC.h"
@interface SMSearchModel ()<UITableViewDelegate, UITableViewDataSource>


@end

@implementation SMSearchModel{
}
@synthesize notificationsTbleView,bGView,footerSectionTitle;


#pragma mark - Custom Accessors

- (id) init{
    
    if(self){
        self  =  [super init];
        _storyboard  =  [UIStoryboard storyboardWithName:SM_STORY_BOARD bundle:nil];
        _userProfileDescriptionStoryboard  = [UIStoryboard storyboardWithName:SM_USER_PROFILE_DESCRIPTION_STORYBOARD bundle:nil];
        _searchDict = [[NSMutableDictionary alloc] init];
        _shiftsArray = [[NSMutableArray alloc] init];
        _notificationsListArray = [[NSMutableArray alloc] init];
        _selectedPositionsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (JVMenuItems *)menuItems
{
    if(!_menuItems)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        _menuItems = [[JVMenuItems alloc] initWithMenuImages:@[[UIImage imageNamed:@"home-1"],[UIImage imageNamed:@"profile"],[UIImage imageNamed:@"settings"],[UIImage imageNamed:@"about"], [UIImage imageNamed:@"logout"]] menuTitles:@[@"Welcome", @"Profile", @"Settings", @"Support", @"Sign Out" ] menuCloseButtonImage:[UIImage imageNamed:@"cross"]];
        
        _menuItems.menuSlideInAnimation = YES;
    }
    
    return _menuItems;
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

- (void) appDidEnterBackground{
    if([[ReusedMethods sharedObject] menuOpened])
        [_menuPopover closeMenuWithOutAnimation];
}

# pragma mark - GET DROP DOWNLIST DATA


- (void) callDropDownListMethods{
    
    [self  makeApiCallForDropDownListForSignUpPositionField];
}

- (void)makeApiCallForDropDownListForSignUpPositionField{
    
    APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_DROPDOWNDATA ModuleName:MODULE_DROPDOWN MethodType:METHOD_TYPE_GET Parameters:nil SuccessCallBack:@selector(dropDownListApiSuccess:) AndFailureCallBack:@selector(dropDownListApiFailed:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
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


- (NSInteger) updateRangeTextFieldText:(NSString *) rangeTxtFldText withSender:(id) sender{
    NSInteger textFieldNum  = [[[rangeTxtFldText componentsSeparatedByCharactersInSet:
                                 [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                componentsJoinedByString:@""] integerValue];
    
    if([sender tag]  ==  HOME_RANGE_INCREMENT_TAG){
        textFieldNum   =  (textFieldNum < kMAX_MILES) ? (textFieldNum + kINT_MILES): kMAX_MILES;
    }
    else{
        textFieldNum   =  (textFieldNum > kMIN_MILES) ? (textFieldNum - kINT_MILES) : kMIN_MILES ;
    }
    return  textFieldNum;
}

- (NSDictionary *) updateRangeTextFieldTextDict:(NSString *) rangeTxtFldText withSender:(id) sender{
    NSArray * locationRageArray = [[[ReusedMethods sharedObject] dropDownListDict] objectForKey:@"location_range"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF[%@] contains[cd] %@",@"miles_range", rangeTxtFldText];
    NSDictionary *  currentObject  = [[locationRageArray filteredArrayUsingPredicate:predicate] firstObject];
    NSInteger currentRangeIndex =   [locationRageArray  indexOfObject:currentObject];
    NSInteger newIndex;
    if([sender tag]  ==  HOME_RANGE_INCREMENT_TAG){
        newIndex =  (currentRangeIndex < [locationRageArray count] - 1) ?  currentRangeIndex + 1 : [locationRageArray count] - 1;
    }
    else{
        NSString *dictPredicateString = [NSString stringWithFormat:@"to_range = %d", kMIN_MILES];
        NSPredicate *dictpredicate = [NSPredicate predicateWithFormat:dictPredicateString];
        NSArray *array = [locationRageArray filteredArrayUsingPredicate:dictpredicate];
        int  minMilesIndex  =  [locationRageArray indexOfObject:[array firstObject]];
        newIndex =  (currentRangeIndex > minMilesIndex) ?  currentRangeIndex - 1 : minMilesIndex;
       // newIndex =  (currentRangeIndex > kMIN_MILES_INDEX) ?  currentRangeIndex - kMIN_MILES_INDEX : kMIN_MILES_INDEX;
    }
    return  [locationRageArray  objectAtIndex:newIndex];
}



#pragma mark - TEXTFIELD  DELEGATE  METHODS
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    if([textField tag]  ==  HOME_POSITION_TEXTFIELD_TAG || [textField tag]  == HOME_EXPERIENCE_TXTFLD_TAG ||  [textField tag] ==  HOME_JOBTYPE_TXTFLD_TAG || [textField tag] == HOME_COMPENSATION_TIMINGS_TEXTFIELD_TAG){
        return NO;
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    if([textField.text length]){
        if(textField.tag == HOME_LOCATION_TEXTFIELD_TAG){
            [_searchDict setObject:textField.text forKey:@"search"];
        }
    }
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(textField.tag == HOME_COMPENSATION_FROM_FIELD || textField.tag == HOME_COMPENSATION_TO_FIELD){
        if(textField.text.length == 0 || range.length != textField.text.length){
            if(range.length != 0 || textField.text.length < 9){
                UITextPosition *beginning = textField.beginningOfDocument;
                UITextPosition *start = [textField positionFromPosition:beginning offset:range.location];
                UITextPosition *end = [textField positionFromPosition:start offset:range.length];
                UITextRange *textRange = [textField textRangeFromPosition:start toPosition:end];
                
                // this will be the new cursor location after insert/paste/typing
                NSInteger cursorOffset = [textField offsetFromPosition:beginning toPosition:start] + string.length;
                
                // now apply the text changes that were typed or pasted in to the text field
                [textField replaceRange:textRange withText:string];
                
                // now go modify the text in interesting ways doing our post processing of what was typed...
                NSString *text = [textField.text mutableCopy];
                // ... etc
                
                // now update the text field and reposition the cursor afterwards
                if(![text hasPrefix:@"$"]){
                    text = [NSString stringWithFormat:@"$%@", text];
                    cursorOffset ++;
                }
                
                textField.text = text;
                UITextPosition *newCursorPosition = [textField positionFromPosition:textField.beginningOfDocument offset:cursorOffset];
                UITextRange *newSelectedRange = [textField textRangeFromPosition:newCursorPosition toPosition:newCursorPosition];
                
                [textField setSelectedTextRange:newSelectedRange];
            }
        }
        else
            textField.text = @"$";
        //    NSLog(@"%@ : %@", key, text);
        NSString *txt = [textField.text stringByReplacingOccurrencesOfString:@"$" withString:@""];
        txt = txt ? txt : @"";
        txt = [txt isEqualToString:@""] ? @"0" : txt;
        if (textField.tag == HOME_COMPENSATION_FROM_FIELD) {
            [self.searchDict setObject:txt forKey:@"fromCompensation"];
        }
        else
            [self.searchDict setObject:txt forKey:@"toCompensation"];
        
        return NO;
    }
    else if(textField.tag == HOME_LOCATION_TEXTFIELD_TAG){
        UITextPosition *beginning = textField.beginningOfDocument;
        UITextPosition *start = [textField positionFromPosition:beginning offset:range.location];
        UITextPosition *end = [textField positionFromPosition:start offset:range.length];
        UITextRange *textRange = [textField textRangeFromPosition:start toPosition:end];
        
        // this will be the new cursor location after insert/paste/typing
        NSInteger cursorOffset = [textField offsetFromPosition:beginning toPosition:start] + string.length;
        
        // now apply the text changes that were typed or pasted in to the text field
        [textField replaceRange:textRange withText:string];
        
        // now go modify the text in interesting ways doing our post processing of what was typed...
        NSString *text = [textField.text mutableCopy];
        // ... etc
        
        textField.text = text;
        UITextPosition *newCursorPosition = [textField positionFromPosition:textField.beginningOfDocument offset:cursorOffset];
        UITextRange *newSelectedRange = [textField textRangeFromPosition:newCursorPosition toPosition:newCursorPosition];
        
        [textField setSelectedTextRange:newSelectedRange];
        
        [_searchDict setObject:textField.text forKey:@"search"];
        return NO;
    }
    else
        return YES;
}


- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    
    NSMutableDictionary  *  totalListDict  =  [[ReusedMethods sharedObject] dropDownListDict];
    NSString *  keyString  =  [self getKeyForDropDownListOfTextFieldTag:[textField  tag]];
    
    if([textField tag]  ==  HOME_POSITION_TEXTFIELD_TAG){       
        /*
        NSDictionary *selectAllDict = [NSDictionary dictionaryWithObjects:@[@"Select All",@0] forKeys:@[@"position_name", @"position_id"]];
        NSMutableArray *dataArray = [[NSMutableArray alloc] initWithArray:[totalListDict  objectForKey:keyString]];
        
        if (dataArray.count > 0){
            if (_selectedPositionsArray.count == dataArray.count) {
                [_selectedPositionsArray insertObject:selectAllDict atIndex:0];
            }
            [dataArray insertObject:selectAllDict atIndex:0];
        }
        
        [ReusedMethods addMultiplePopupViewWithVC:_delegate dataArray:dataArray dataKey:@"position_name" idName:@"position_id" textField:textField andSelectedItems:_selectedPositionsArray withTag:kPosition];
        */
        return NO;
    }
    else if ([textField tag]  == HOME_EXPERIENCE_TXTFLD_TAG){
        [ReusedMethods setupPopUpViewForTextField:textField withDisplayArray:[totalListDict  objectForKey:keyString] withDel:_delegate displayKey:@"experience_range" returnKey:@"experience_range_id" withTag:kExperience];
        return NO;
    }
    else if([textField tag] ==  HOME_JOBTYPE_TXTFLD_TAG){
        [ReusedMethods setupPopUpViewForTextField:textField withDisplayArray:[totalListDict  objectForKey:keyString] withDel:_delegate displayKey:@"job_type" returnKey:@"job_type_id" withTag:kJobType];
        return NO;
    }else if([textField tag] ==  HOME_COMPENSATION_TIMINGS_TEXTFIELD_TAG){
        [ReusedMethods setupPopUpViewForTextField:textField withDisplayArray:[totalListDict  objectForKey:keyString] withDel:_delegate displayKey:@"compensation_name" returnKey:@"compensation_id" withTag:kCompRange];
        return NO;
    }
    
    else{
        return YES;
    }
    
}

- (NSString *) getKeyForDropDownListOfTextFieldTag:(NSInteger) tag{
    
    if (tag  ==  HOME_POSITION_TEXTFIELD_TAG) {
        return  @"positions";
    }else if (tag == HOME_EXPERIENCE_TXTFLD_TAG){
        return  @"experience";
        
    }else if (tag  ==  HOME_JOBTYPE_TXTFLD_TAG){
        return @"jobtype";
    }else if (tag  == HOME_COMPENSATION_TIMINGS_TEXTFIELD_TAG){
        return @"comprange";
    }
    return @"";
}


- (NSString *) getDay:(NSInteger) dayId{
    switch (dayId) {
        case 0:
            return @"Monday";
            break;
        case 1:
            return @"Tuesday";
            break;
        case 2:
            return @"Wednesday";
            break;
        case 3:
            return @"Thursday";
            break;
        case 4:
            return @"Friday";
            break;
        case 5:
            return @"Saturday";
            break;
        default:
            return @"Sunday";
            break;
    }
}

// work  day  preferences  related  chnages

- (void) changeWorkDayPreferencesButtonStateOfButton:(UIButton * ) button{
    
    @try {
        NSString *imageName = nil;
        NSInteger buttonRow = button.tag / 10;
        int dayFilter = 500;
        NSInteger shift = 0;
        
        switch (buttonRow) {
            case 50:
                //  morning
                dayFilter = 500;
                shift = 0;
                imageName =  @"sel1";
                break;
            case 51:
                //  afternoon
                dayFilter = 510;
                shift = 1;
                imageName =  @"sel2";
                break;
            case 52:
                //  evening
                dayFilter = 520;
                shift = 2;
                imageName =  @"sel3";
                break;
                
            default:
                break;
        }
        NSInteger day = button.tag % dayFilter;
        NSString *strDay = [self getDay:day];
        
        NSMutableDictionary *shiftDict = [_shiftsArray objectAtIndex:shift];
        NSMutableArray *arrayDays = [shiftDict objectForKey:@"days"];
        if(!arrayDays){
            arrayDays = [[NSMutableArray alloc] init];
        }
        
        if(![button isSelected]){
            [arrayDays addObject:strDay];
            [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateSelected];
        }
        else{
            [arrayDays removeObject:strDay];
            [button setImage:[UIImage imageNamed:@"unsel"] forState:UIControlStateNormal];
        }
        
        [button setSelected:!button.selected];
        [shiftDict setObject:arrayDays forKey:@"days"];
        NSLog(@"Shift : %ld, Day: %@", shift, strDay);
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

- (MARKRangeSlider *) setUpProgressViewOnView:(UIView *) compensationRangeProgressView{
    
    MARKRangeSlider *  rangeSlider = [[MARKRangeSlider alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(compensationRangeProgressView.frame) , compensationRangeProgressView.frame.size.height)];
    [rangeSlider addTarget:self.delegate
                    action:@selector(rangeSliderValueDidChange:)
          forControlEvents:UIControlEventValueChanged];
    rangeSlider.leftThumbImage =  [UIImage  imageNamed:@"blue circle"];
    rangeSlider.rightThumbImage =  [UIImage  imageNamed:@"purple circle"];
    rangeSlider.rangeImage  =  [UIImage imageNamed:@"unsel"];
    rangeSlider.trackImage  = [UIImage imageNamed:@"line slider"];
    rangeSlider.pushable  =  YES;
    
    [rangeSlider setMinValue:kMIN_SLIDER maxValue:kMAX_SLIDER];
    [rangeSlider setLeftValue:kLEFT_DEFAULT_SLIDER rightValue:kRIGHT_DEFAULT_SLIDER];
    
    rangeSlider.minimumDistance = 1;
    
    [compensationRangeProgressView addSubview:rangeSlider];
    
    return rangeSlider;
}

- (void) makeServerCallForJobSearch{
    if([_searchDict objectForKey:@"position"]){
        
 
        APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_SEARCH ModuleName:MODULE_JOBS MethodType:METHOD_TYPE_POST Parameters:_searchDict SuccessCallBack:@selector(serverCallSuccessRespone:) AndFailureCallBack:@selector(serverCallFailureRespone:)];
        
        WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
        [service makeWebServiceCall];
        
    }
    else{
        [[[RBACustomAlert alloc] initWithTitle:@"Please select Position" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
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


#pragma mark - Jobs Search Call Back Method

-(void)serverCallSuccessRespone:(WebServiceCalls *)service
{
    [_delegate serverCallSuccessRespone:service.responseData];
}

-(void)serverCallFailureRespone:(WebServiceCalls *)service
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
        [_delegate serverCallFailureRespone:string];
    }
}

//   saving  to navigation controllers.
- (SMHomeVC *)homeVC
{
    if (!_homeVC)
    {
        _homeVC = (SMHomeVC *)[_storyboard  instantiateViewControllerWithIdentifier:SM_SEARCH_VC];
    }
    
    return _homeVC;
}

- (SMProfileVC *)profileVC
{
    if (!_profileVC)
    {
        _profileVC = (SMProfileVC *)[_storyboard  instantiateViewControllerWithIdentifier:SM_PROFILE_VC];
    }
    
    return _profileVC;
}

- (SMScreenTitleButtonsVC *) firstProfileVC{
    if (!_firstProfileVC){
        UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:@"SMAddProfileDetails" bundle:nil];
        _firstProfileVC = (SMScreenTitleButtonsVC *)[profileStoryboard  instantiateViewControllerWithIdentifier:SM_ADD_PROFILE_FIRST_VC];
    }
    
    return _firstProfileVC;
    
}

- (SMUserProfileDescriptionVC *) userProfileDescriptionVC
{
    if (!_userProfileDescriptionVC)
    {
        _userProfileDescriptionVC = (SMUserProfileDescriptionVC *)[_userProfileDescriptionStoryboard  instantiateViewControllerWithIdentifier:SM_PROFILE_DESCRIPTION_VC];
    }
    
    return _userProfileDescriptionVC;
    
}

- (SMSettingsVC *)settingsVC
{
    if (!_settingsVC)
    {
        _settingsVC = (SMSettingsVC *)[_storyboard  instantiateViewControllerWithIdentifier:SM_SETTINGS_VC];
    }
    
    return _settingsVC;
}

- (SMHelpVC *)helpVC
{
    if (!_helpVC)
    {
        //        _helpVC = [[SMHelpVC alloc] init];
        _helpVC = (SMHelpVC *)[_storyboard  instantiateViewControllerWithIdentifier:SM_HELP_VC];
    }
    
    return _helpVC;
}

- (SMLoginVC *)logInVC{
    if(!_logInVC){
        _logInVC  = (SMLoginVC *)[_storyboard  instantiateViewControllerWithIdentifier:SM_LOGIN_VC];
    }
    return _logInVC;
}

#pragma mark - NOTIFICATIONS VIEW

- (void)  setUpNotificationsView{
    //  setup  BG view
    if(!_notiView)
    {
        float screenWidth  =  [UIScreen mainScreen].bounds.size.width;
//        float screenHeight =  [UIScreen mainScreen].bounds.size.height;
        
        _notiView = [[NotificationView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        float width =  screenWidth - 40;//  310;
        
//        UIView *bGView  =  [[UIView alloc]  initWithFrame:CGRectMake(20, NAVIGATION_HEIGHT, screenWidth  -  (2 * 20), screenHeight/3 )];
       // UIView *bGView  =  [[UIView alloc]  initWithFrame:CGRectMake((screenWidth - width) / 2.0, NAVIGATION_HEIGHT, width, 200 )];
        
        bGView  =  [[UIView alloc]  initWithFrame:CGRectMake((screenWidth - width - 10), NAVIGATION_HEIGHT, width, 200 )];
        [bGView setTag:HOME_NOTIFICATIONVIEW_TAG];
        [bGView setBackgroundColor:[UIColor appGreenColor]];
        [[bGView layer] setCornerRadius:5.0f];
        [[bGView layer] setBorderColor:[UIColor clearColor].CGColor];
        [[bGView layer] setBorderWidth:1.0f];
        [[bGView layer]  setMasksToBounds:YES];
        
        bGView.layer.masksToBounds = NO;
        bGView.layer.shadowOffset = CGSizeMake(-5, 5);
        bGView.layer.shadowRadius = 5;
        bGView.layer.shadowOpacity = 0.5;
        
        UITableView *  tbleView  =  [[UITableView  alloc] initWithFrame:CGRectMake(20, 20, CGRectGetWidth(bGView.frame)  -  (2 * 20), CGRectGetHeight(bGView.frame) - 20)];
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
    
    if (!_notificationsListArray.count) {
        [self displayNoItemsFoundMessage];
        [notificationsTbleView setHidden:YES];
    }else{
        [notificationsTbleView setHidden:NO];
    }
}


#pragma mark - TABLE  VIEW  DELEGATE  METHODS

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[ReusedMethods setSeperatorProperlyForCell:cell];
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        //[cell setSeparatorInset:UIEdgeInsetsZero];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        //[cell setLayoutMargins:UIEdgeInsetsZero];
        [cell  setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
    }

}


- (NSInteger)  tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _notificationsListArray.count ;// : _notificationsListArray.count;
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
    [tableView  setSeparatorColor:[UIColor colorWithRed:166/255.0 green:207/255.0 blue:214/255.0 alpha:1.0]];
    
//    if ([UITableView instancesRespondToSelector:@selector(setLayoutMargins:)]) {
//        [tableView setSeparatorInset:UIEdgeInsetsMake(20, 16, 20, 20)];
//        tableView.cellLayoutMarginsFollowReadableWidth = YES;
//    }
    
    if(_notificationsListArray.count){
        [cell.viewJobButton setTag:indexPath.row];
        [cell.viewJobButton addTarget:self action:@selector(notificationsViewJobButtonAction:) forControlEvents:UIControlEventTouchUpInside];
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
    UIDevice *currentDevice = [UIDevice currentDevice];
//    NSLog(@"currentDevice.name : %@", currentDevice.localizedModel);
    BOOL simulator = [currentDevice.name isEqualToString:@"iPhone Simulator"];
    if(!simulator)
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
    
   // NSMutableArray *  PushNotificationsArray  =  [[NSMutableArray  alloc] init];
   // [PushNotificationsArray  addObjectsFromArray:reverseOrder];
    
    //  predicated viewd = 0  objects  to display  count in  home  view.
    
    NSString *predicateString = [NSString stringWithFormat:@"viewed == %@", @"No"];
    predicateString  =  [NSString stringWithFormat:@"%@ CONTAINS[c] '%@'", @"viewed", @"No"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    NSArray *nonVisitedNotificationsArray = [reverseOrder filteredArrayUsingPredicate:predicate];
    
    //  if  non visited  notifications array  is less  in number 10 then  show  10
    
    if(nonVisitedNotificationsArray.count < kNOTIFICATIONS_DISPLAY_COUNT){
        NSMutableArray  *  limitedObjectsArray  = [[NSMutableArray alloc] init];
        [limitedObjectsArray  addObjectsFromArray:nonVisitedNotificationsArray];
        int  rangeValue   =  kNOTIFICATIONS_DISPLAY_COUNT  - (int) nonVisitedNotificationsArray.count;
        if(reverseOrder.count  >  kNOTIFICATIONS_DISPLAY_COUNT){
            //[limitedObjectsArray addObjectsFromArray:[reverseOrder subarrayWithRange:NSMakeRange(reverseOrder.count - rangeValue, rangeValue)]];
            [limitedObjectsArray addObjectsFromArray:[reverseOrder subarrayWithRange:NSMakeRange(0, kNOTIFICATIONS_DISPLAY_COUNT)]];
        }else{
            [limitedObjectsArray removeAllObjects];
            [limitedObjectsArray  addObjectsFromArray:reverseOrder];
        }
        //  save  count  to  userdefaults
        [[NSUserDefaults standardUserDefaults]  setObject:[NSNumber  numberWithInteger:nonVisitedNotificationsArray.count] forKey:USER_NOTIFICATIONS_COUNT];
        nonVisitedNotificationsArray = nil;
        nonVisitedNotificationsArray = limitedObjectsArray;
    }else{
        //  save  count  to  userdefaults
        [[NSUserDefaults  standardUserDefaults]  setObject:[NSNumber  numberWithInteger:nonVisitedNotificationsArray.count] forKey:USER_NOTIFICATIONS_COUNT];
    }
    NSData *pushNotificationsArrayData = [NSKeyedArchiver archivedDataWithRootObject:nonVisitedNotificationsArray];
    NSUserDefaults *  userDefaults  =  [NSUserDefaults  standardUserDefaults];
    [userDefaults  setObject:pushNotificationsArrayData forKey:NOTIFICATIONS_ARRAY];
    [userDefaults  synchronize];
    
    //  save  count  to  userdefaults
   // [userDefaults  setObject:[NSNumber  numberWithInteger:nonVisitedNotificationsArray.count] forKey:USER_NOTIFICATIONS_COUNT];
    [userDefaults  setObject:@NO forKey:@"firstTime"];
    [userDefaults  synchronize];

    [_delegate notificationSuccessCall];
    [_delegate removeActiviyIndicator];
}

- (void) notificationsApiFailed:(NSError *)error{
    [_delegate removeActiviyIndicator];
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
    if(touch.view!=notificationsTbleView){
        notificationsTbleView.hidden = YES;
    }
}

- (void) notificationsViewJobButtonAction:(id) sender{
    NSDictionary *dictJob = [_notificationsListArray objectAtIndex:[sender tag]];
   // [self updateViewedPushNotificationStatusForObject:[dictJob mutableCopy]];
    [self getJobDetails:[dictJob objectForKey:@"job_id"]];
}

#pragma mark - NOTIFICATIONS LIST VIEWED  STATUS

-(void)makeApiCallForViewedNotificationsList{
    //  get  non  viewed  notifications  avilability
    NSString *predicateString  =  [NSString stringWithFormat:@"%@ CONTAINS[c] '%@'", @"viewed", @"No"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    NSArray *nonVisitedNotificationsArray = [_notificationsListArray filteredArrayUsingPredicate:predicate];
    
    if(nonVisitedNotificationsArray.count == 0){
        [notificationsTbleView reloadData];
        return;
    }

    
    //  get all ids of noyifications  list
    NSMutableArray *  notificationIdsArray  =  [[NSMutableArray  alloc] init];
    for (NSDictionary *  dict  in nonVisitedNotificationsArray) {
        [notificationIdsArray  addObject:[dict  objectForKey:@"id"]];
    }
    
    NSMutableDictionary *  parametersDict  =  [[NSMutableDictionary  alloc] init];
    [parametersDict setObject:notificationIdsArray forKey:@"viewed_ids"];
    
    APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_VIEWED_NOTIFICATIONS ModuleName:MODULE_SETTINGS MethodType:METHOD_TYPE_POST Parameters:parametersDict SuccessCallBack:@selector(viewedNotificationsListApiSuccess:) AndFailureCallBack:@selector(viewedNotificationsApiFailed:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
    service.isLoaderHidden  =  YES;
    [service makeWebServiceCall];
}

- (void) viewedNotificationsListApiSuccess:(WebServiceCalls *)sender{
    //  update  all  notifications  objects  viewed status
    [self updateViewedJObStatus];
}

- (void) viewedNotificationsApiFailed:(id) sender{
    [_delegate removeActiviyIndicator];
}


#pragma mark - Getting Job Details

- (void) getJobDetails:(id) jobID{
    APIObject * reqObject = [[APIObject alloc] initWithMethodName:[NSString stringWithFormat:@"%@/%@", METHOD_DETAILS, jobID] ModuleName:MODULE_JOBS MethodType:METHOD_TYPE_POST Parameters:nil SuccessCallBack:@selector(apiCallSuccess:) AndFailureCallBack:@selector(apiCallFailed:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
    [service makeWebServiceCall];
}

- (void) apiCallSuccess:(WebServiceCalls *) service{
    NSDictionary *jobDetails = nil;
    if([service.responseData isKindOfClass:[NSArray class]])
        jobDetails = [service.responseData firstObject];
    else
        jobDetails = service.responseData;
    //    NSDictionary *jobDict = service.responseData;
    //    [self.delegate updateUI];
    [_notiView removeFromSuperview];
    [self.delegate notificationsViewJobButtonAction:jobDetails];
    //    NSLog(@"Response Data : %@", service.responseData);
}

- (void) apiCallFailed:(WebServiceCalls *) service{
    
}

//  DIsplaying  empty  cell data

- (void) displayNoItemsFoundMessage{
    
    footerSectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(bGView.frame.size.width/2 - 75, bGView.frame.size.height/2 - 20, 150, 40)];
    [footerSectionTitle setBackgroundColor:[UIColor clearColor]];
    [footerSectionTitle setNumberOfLines:0];
    [footerSectionTitle setLineBreakMode:NSLineBreakByWordWrapping];
    [footerSectionTitle setTextAlignment:NSTextAlignmentLeft];
    [footerSectionTitle setTextColor:[UIColor appWhiteColor]];
    [footerSectionTitle setFont:[UIFont appNormalTextFont]];
    [footerSectionTitle setText:@"No notifications to display"];
    //footerSectionTitle.center  =  bGView.center;
    [bGView addSubview:footerSectionTitle];
}


- (void) updateViewedPushNotificationStatusForObject:(NSMutableDictionary *) notificationObject{
    
    //  getting objects  from  userdefaults data.
    NSUserDefaults *  userDefaults  =  [NSUserDefaults  standardUserDefaults];
    NSData *data = [userDefaults objectForKey:NOTIFICATIONS_ARRAY];
    NSMutableArray *savedArray = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    
    [notificationObject  setValue:@"Yes" forKey:@"viewed"];
    NSNumber *  jobID  =  [notificationObject objectForKey:@"job_id"];
    NSPredicate * predicate  =  [NSPredicate predicateWithFormat:@("job_id == %@"),jobID];
    NSDictionary *  dict  = [[savedArray filteredArrayUsingPredicate:predicate] firstObject];
    NSInteger  index  =   [savedArray indexOfObject:dict];
    [savedArray replaceObjectAtIndex:index withObject:notificationObject];
    
    
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"updated_at" ascending:NO];
    NSArray *descriptors=[NSArray arrayWithObject: descriptor];
    NSArray *reverseOrder=[savedArray sortedArrayUsingDescriptors:descriptors];
      
    //  predicated viewd = 0  objects  to display  count in  home  view.
    NSString *predicateString = [NSString stringWithFormat:@"viewed = %@", @"No"];
    predicateString  =  [NSString stringWithFormat:@"%@ CONTAINS[c] '%@'", @"viewed", @"No"];
    NSPredicate *predicateCount = [NSPredicate predicateWithFormat:predicateString];
    NSArray *nonVisitedNotificationsArray = [reverseOrder filteredArrayUsingPredicate:predicateCount];
    
    //  if  non visited  notifications array  is less  in number 10 then  show  10
    
    if(nonVisitedNotificationsArray.count < kNOTIFICATIONS_DISPLAY_COUNT){
        NSMutableArray  *  limitedObjectsArray  = [[NSMutableArray alloc] init];
        [limitedObjectsArray  addObjectsFromArray:nonVisitedNotificationsArray];
        int  rangeValue   =  kNOTIFICATIONS_DISPLAY_COUNT  - (int) nonVisitedNotificationsArray.count;
        if(reverseOrder.count  >  kNOTIFICATIONS_DISPLAY_COUNT){
        //[limitedObjectsArray addObjectsFromArray:[reverseOrder subarrayWithRange:NSMakeRange(reverseOrder.count - rangeValue, rangeValue)]];
            [limitedObjectsArray addObjectsFromArray:[reverseOrder subarrayWithRange:NSMakeRange(0, kNOTIFICATIONS_DISPLAY_COUNT)]];
        }else{
            [limitedObjectsArray removeAllObjects];
            [limitedObjectsArray  addObjectsFromArray:reverseOrder];
        }
        //  save  count  to  userdefaults
        [[NSUserDefaults standardUserDefaults]  setObject:[NSNumber  numberWithInteger:nonVisitedNotificationsArray.count] forKey:USER_NOTIFICATIONS_COUNT];
        nonVisitedNotificationsArray = nil;
        nonVisitedNotificationsArray = limitedObjectsArray;
    }else{
        //  save  count  to  userdefaults
        [[NSUserDefaults  standardUserDefaults]  setObject:[NSNumber  numberWithInteger:nonVisitedNotificationsArray.count] forKey:USER_NOTIFICATIONS_COUNT];
    }
    NSData *pushNotificationsArrayData = [NSKeyedArchiver archivedDataWithRootObject:nonVisitedNotificationsArray];
    [userDefaults  setObject:pushNotificationsArrayData forKey:NOTIFICATIONS_ARRAY];
    
    //  save  count  to  userdefaults
  //  [userDefaults  setObject:[NSNumber  numberWithInteger:nonVisitedNotificationsArray.count] forKey:USER_NOTIFICATIONS_COUNT];
    
    [userDefaults  synchronize];
    
    [_delegate notificationSuccessCall];
    [_delegate removeActiviyIndicator];

    
    
}


- (void) updateViewedJObStatus{
    //  getting objects  from  userdefaults data.
    NSUserDefaults *  userDefaults  =  [NSUserDefaults  standardUserDefaults];
    NSData *data = [userDefaults objectForKey:NOTIFICATIONS_ARRAY];
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    
    NSMutableArray *savedArray = [[NSMutableArray alloc] init];
    for (NSDictionary * notificationObject  in  tempArray) {
        NSMutableDictionary  *  notificationDict  =  [[NSMutableDictionary  alloc] initWithDictionary:notificationObject];
        [notificationDict  setValue:@"Yes" forKey:@"viewed"];
        [savedArray addObject:notificationDict];
    }
    
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"updated_at" ascending:NO];
    NSArray *descriptors=[NSArray arrayWithObject: descriptor];
    NSArray *reverseOrder=[savedArray sortedArrayUsingDescriptors:descriptors];
    
    //  predicated viewd = 0  objects  to display  count in  home  view.
    
    NSString *predicateString = [NSString stringWithFormat:@"viewed = %@", @"No"];
    predicateString  =  [NSString stringWithFormat:@"%@ CONTAINS[c] '%@'", @"viewed", @"No"];
    NSPredicate *predicateCount = [NSPredicate predicateWithFormat:predicateString];
    NSArray *nonVisitedNotificationsArray = [reverseOrder filteredArrayUsingPredicate:predicateCount];
    
    
    //  if  non visited  notifications array  is less  in number 10 then  show  10
    
    if(nonVisitedNotificationsArray.count < kNOTIFICATIONS_DISPLAY_COUNT){
        NSMutableArray  *  limitedObjectsArray  = [[NSMutableArray alloc] init];
        [limitedObjectsArray  addObjectsFromArray:nonVisitedNotificationsArray];
        int  rangeValue   =  kNOTIFICATIONS_DISPLAY_COUNT  - (int) nonVisitedNotificationsArray.count;
        if(reverseOrder.count  >  kNOTIFICATIONS_DISPLAY_COUNT){
          //  [limitedObjectsArray addObjectsFromArray:[reverseOrder subarrayWithRange:NSMakeRange(reverseOrder.count - rangeValue, rangeValue)]];
            [limitedObjectsArray addObjectsFromArray:[reverseOrder subarrayWithRange:NSMakeRange(0, kNOTIFICATIONS_DISPLAY_COUNT)]];

        }else{
            [limitedObjectsArray removeAllObjects];
            [limitedObjectsArray  addObjectsFromArray:reverseOrder];
        }
        //  save  count  to  userdefaults
        [[NSUserDefaults standardUserDefaults]  setObject:[NSNumber  numberWithInteger:nonVisitedNotificationsArray.count] forKey:USER_NOTIFICATIONS_COUNT];
        nonVisitedNotificationsArray = nil;
        nonVisitedNotificationsArray = limitedObjectsArray;
        
    }else{
        
        //  save  count  to  userdefaults
        [[NSUserDefaults  standardUserDefaults]  setObject:[NSNumber  numberWithInteger:nonVisitedNotificationsArray.count] forKey:USER_NOTIFICATIONS_COUNT];
    }
    
    
    NSData *pushNotificationsArrayData = [NSKeyedArchiver archivedDataWithRootObject:nonVisitedNotificationsArray];
    [userDefaults  setObject:pushNotificationsArrayData forKey:NOTIFICATIONS_ARRAY];
    
    //  save  count  to  userdefaults
    //  [userDefaults  setObject:[NSNumber  numberWithInteger:nonVisitedNotificationsArray.count] forKey:USER_NOTIFICATIONS_COUNT];
    
    [userDefaults  synchronize];
    
    [_delegate notificationSuccessCall];
    [_delegate removeActiviyIndicator];

}




@end

