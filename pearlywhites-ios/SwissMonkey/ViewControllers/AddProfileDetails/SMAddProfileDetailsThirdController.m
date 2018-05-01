//
//  SMAddProfileDetailsThirdController.m
//  MBXPageController
//
//  Created by Kasturi on 2/3/16.
//  Copyright (c) 2016 Moblox. All rights reserved.
//

#import "SMAddProfileDetailsThirdController.h"
#import "CircleLoaderView.h"

@interface SMAddProfileDetailsThirdController ()
{
    SMAddProfileThirdVCModel * smAddProfileThirdVCModel;
}

@end

@implementation SMAddProfileDetailsThirdController

@synthesize workAvailabilityTextField,workavailabilityDateTextFld,opportunitiesTextView,performanceManagementSkillsTextView,additionalSkillsTextView,languagesTextFld,otherPracticeSoftwareDescriptionTxtFld,languagesFieldHeightConstraint , specializedAssistantTriningTxtView, specializedAssTrainingHeightConstraint, otherPracticeSoftwareExperienceHeightConstraight,workavailabilityDateTextFieldHeightConstraint, mornLabel,afterNoonLbel,eveningLabel;

@synthesize workAvailabilityTextFieldBG, workavailabilityDateTextFldBG, opportunitiesTextViewBG, performanceViewBG, skillsViewBG;

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [mornLabel  setText:[NSString stringWithFormat:kMORNING]];
    [afterNoonLbel  setText:[NSString stringWithFormat:kAFTERNOON]];
    [eveningLabel  setText:[NSString stringWithFormat:kEVENING]];
    
    _contentViewContraints.constant  =  1100;//570;
    [self.contentView setNeedsDisplay];
//    [self updateUI:[ReusedMethods sharedObject].userProfileInfo];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [smAddProfileThirdVCModel.toolsView setHidden:YES];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
//    CGFloat height   =  [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    height  =  MAX(height, CGRectGetMaxY(_progressView.frame));
    
    [self addLoader];
    [self performSelector:@selector(removeLoader) withObject:nil afterDelay:0.5];
}

- (void) addLoader{
    [CircleLoaderView addToWindow];
}

- (void) removeLoader{
    [CircleLoaderView removeFromWindow];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(profileUpdateNotificationForCurrentVC)
                                                 name:@"profileUpdateNotificationForCurrentVC" object:nil];
    
    smAddProfileThirdVCModel = [[SMAddProfileThirdVCModel alloc] init];
    smAddProfileThirdVCModel.delegate = self;
    [smAddProfileThirdVCModel setupDatePicker];
    [self prepareDelegatesAndTags];
    
    NSArray *arrayShifts = [[ReusedMethods sharedObject].dropDownListDict objectForKey:@"shifts"];
//    for (NSDictionary *dict in arrayShifts)
//    {
//        NSMutableDictionary *shiftDict = [NSMutableDictionary dictionaryWithObject:[dict objectForKey:@"shift_id"] forKey:@"shiftID"];
//        [smAddProfileThirdVCModel.profileShiftsArray addObject:shiftDict];
//    }
    
    for (int i = 0 ; i < arrayShifts.count; i++)
    {
        NSDictionary *dict = [arrayShifts objectAtIndex:i];
        NSMutableDictionary *shiftDict = [NSMutableDictionary dictionaryWithObject:[dict objectForKey:@"shift_id"] forKey:@"shiftID"];
        NSMutableArray *  selectedShiftsArray  =  [[NSMutableArray alloc] initWithArray:[[[[ReusedMethods sharedObject] userProfileInfo] objectForKey:SHIFTS] mutableCopy]];
        if (selectedShiftsArray.count > i && selectedShiftsArray.count) {
            
            NSMutableDictionary *shiftServerDict = [[selectedShiftsArray objectAtIndex:i] mutableCopy];
            NSMutableArray *arrayDays =  [[NSMutableArray alloc] initWithArray: [[shiftServerDict objectForKey:@"days"] mutableCopy]];
            
            [shiftDict setObject:arrayDays forKey:@"days"];
        }
        
        [smAddProfileThirdVCModel.profileShiftsArray addObject:shiftDict];
    }
    self.progressView.progress  =  [ReusedMethods profileProgresValue];
    
    //Customize the UI Elements
    [ReusedMethods applyShadowToView:_jobTypeTextFieldBG];
    [ReusedMethods applyShadowToView:workAvailabilityTextFieldBG];
    [ReusedMethods applyShadowToView:workavailabilityDateTextFldBG];
    [ReusedMethods applyShadowToView:opportunitiesTextViewBG];
    [ReusedMethods applyShadowToView:performanceViewBG];
    [ReusedMethods applyShadowToView:skillsViewBG];
    [ReusedMethods applyShadowToView:_specializedDentalViewBG];
    
    _jobTypeTextField.botomBorder.hidden = YES;
    workAvailabilityTextField.botomBorder.hidden = YES;
    workavailabilityDateTextFld.botomBorder.hidden = YES;
    opportunitiesTextView.botomBorder.hidden = YES;
    performanceManagementSkillsTextView.botomBorder.hidden = YES;
    additionalSkillsTextView.botomBorder.hidden = YES;
    specializedAssistantTriningTxtView.botomBorder.hidden = YES;
    
    /*
    additionalSkillsTextView.textContainer.maximumNumberOfLines = 2;
    additionalSkillsTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    additionalSkillsTextView.bounces = NO;
    
    specializedAssistantTriningTxtView.textContainer.maximumNumberOfLines = 2;
    specializedAssistantTriningTxtView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    specializedAssistantTriningTxtView.bounces = NO;
    
    performanceManagementSkillsTextView.textContainer.maximumNumberOfLines = 2;
    performanceManagementSkillsTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    performanceManagementSkillsTextView.bounces = NO;
     
     */
//    [self updateUI:[ReusedMethods sharedObject].userProfileInfo];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateUI:[ReusedMethods sharedObject].userProfileInfo];
    [self updateWorkDayPreferences];
}

- (void) prepareDelegatesAndTags
{
    _jobTypeTextField.delegate                      = self;
    workAvailabilityTextField.delegate              = self;
    workavailabilityDateTextFld.delegate            = self;
    opportunitiesTextView.delegate                  = self;
    performanceManagementSkillsTextView.delegate    = self;
    additionalSkillsTextView.delegate               = self;
    specializedAssistantTriningTxtView.delegate     = self;
    
    _jobTypeTextField.tag                   = PROFILE_JOB_TYPE_TXTFLD_TAG;
    workAvailabilityTextField.tag           = PROFILE_WORK_AVAILALABILITY_TXTFLD_TAG;
    workavailabilityDateTextFld.tag         = PROFILE_WORK_AVAILABILITY_AFTER_DATE_TEXTFLD_TAG;
    opportunitiesTextView.tag               = PROFILE_LOOKING_FOR_OPPORTUNITIES_TXTVIEW_TAG;
    performanceManagementSkillsTextView.tag = PROFILE_PERFORMANCE_MANAGEMENT_TXTVIEW_TAG;
    additionalSkillsTextView.tag            = PROFILE_ADDITIONAL_SKILLS_TXTVIEW_TAG;
    specializedAssistantTriningTxtView.tag  = PROFILE_SPECIALIZED_ASSISTANT_TRAINING_TXTVIEW_TAG;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Dropdown User Actions
- (IBAction)clickOnJobType:(id)sender{
    [smAddProfileThirdVCModel clickedProfileJobType:self.jobTypeTextField];
}

- (IBAction)clickOnWorkAvailability:(id)sender{
    [smAddProfileThirdVCModel clickedProfileWorkAvailability:self.workAvailabilityTextField];
}

- (IBAction)clickOnAvailabilityDate:(id)sender{
    [smAddProfileThirdVCModel clickedProfileWorkAvailiabilityAfterDateAvailability:self.workavailabilityDateTextFld];
}

- (IBAction)clickOnOpportunities:(id)sender{
    [smAddProfileThirdVCModel clickedProfileOpportunityDistance:self.opportunitiesTextView];
}

- (IBAction)clickOnPracticeSoftwareExperience:(id)sender{
    [smAddProfileThirdVCModel clickedProfilePerformanceManagement:self.performanceManagementSkillsTextView];
}

- (IBAction)clickOnAdditionalSkills:(id)sender{
    [smAddProfileThirdVCModel clickedProfileAdditionalSkills:self.additionalSkillsTextView];
}

- (IBAction)clickOnSpecializedDental:(id)sender{
    [smAddProfileThirdVCModel clickedProfileSpecializedAssisting:self.specializedAssistantTriningTxtView];
}



#pragma mark - TEXTFIELD  DELEGATE  METHODS
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    [self.view endEditing:YES];
    return [smAddProfileThirdVCModel textFieldShouldBeginEditing:textField];
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    [smAddProfileThirdVCModel textFieldDidEndEditing:textField];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    return [smAddProfileThirdVCModel textFieldShouldReturn:textField];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return [smAddProfileThirdVCModel textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

- (IBAction)workDayButtonAction:(UIButton *)button
{
    [smAddProfileThirdVCModel changeWorkDayPreferencesButtonStateOfButton:button];
}


#pragma mark -  SELECTION POPUP DELEGATE METODS

- (void) selectedValue:(id)value withKeyId:(NSString *) keyId titleName:(NSString *)titleName withKey:(NSString *)key selectedCell:(UITableViewCell *)selectedCell withType:(PopupType) typePopup
{
    smAddProfileThirdVCModel.isPopOverPresent = NO;
    NSString * serverKey = nil;
    
    switch (typePopup) {
        case kJobType:
            serverKey  = JOB_TYPE;
            break;
        case kWorkAvailability:
            serverKey  = WORK_AVAILABILITY;
            break;
        case kAvialabilityOptions:
            serverKey  = VIRTUAL_INTERVIEW;
            break;
        case kOpportunitiesRange:
            serverKey  = LOCATION_RANGE;
            break;
        case kPracticeManagement:
            serverKey  = PRACTICE_MANAGEMENT;
            break;
        case kAdditionalSkills:
            serverKey  = SKILLS;
            break;
        default:
            break;
    }
    
    if (serverKey)
        [[[ReusedMethods sharedObject] userProfileInfo] setObject:value  forKey:serverKey];
    
    if([serverKey  isEqualToString:WORK_AVAILABILITY]){
        [self updateWorkDayAvailabilityAfterDateViewBasedOnselectedWorkAvailabilityID:value];
    }
}

- (void)popTipViewWasDismissedByUser:(RBAPopup *)popTipView
{
    smAddProfileThirdVCModel.isPopOverPresent = NO;
}

- (void) itemSelectedwithData:(NSDictionary *)data andDataType:(PopupType) dataType selected:(BOOL)isSelected {
    
    if (![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    if (dataType  == kAdditionalSkills && [[NSString stringWithFormat:@"%@",[data objectForKey:@"software_type_id"]] isEqualToString:@"15"] ){
     
        NSArray *  softwareProficiencyObjectsArray =  [[[ReusedMethods  sharedObject] dropDownListDict] objectForKey:@"software_proficiency"];
        NSMutableArray *subCategoryDictArr = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in softwareProficiencyObjectsArray) {
            if ([[dict valueForKey:@"parent_id"] isKindOfClass:[NSNumber class]]) {
                [subCategoryDictArr addObject:dict];
            }
        }
        
        NSMutableArray * selecteditemsArray = [self getSelectedItemsArrayWithSelectedKeyArray:softwareProficiencyObjectsArray serverKey:SKILLS filterWithKeyString:@"software_type_name" IdString:@"software_type_id"];
        
        [ReusedMethods addMultiplePopupViewWithVC:self dataArray:subCategoryDictArr dataKey:@"software_type_name" idName:@"software_type_id" textField:[self.view viewWithTag:PROFILE_ADDITIONAL_SKILLS_TXTVIEW_TAG] andSelectedItems:selecteditemsArray withTag:kAdditionalSkills];
    }
}

- (NSMutableArray *) getSelectedItemsArrayWithSelectedKeyArray:(NSArray *) dropDownListArray serverKey:(NSString *) serverKey filterWithKeyString: (NSString *) nameString IdString:(NSString *) idString  {
    
    NSMutableArray *  selectedObjectsArray  =  [[NSMutableArray alloc] init];
    NSDictionary * dict  =  [[ReusedMethods sharedObject] userProfileInfo];
    NSArray  *  dropDownlistSkillsArray  =  dropDownListArray;// [[[ReusedMethods  sharedObject] dropDownListDict]  objectForKey:@"software_proficiency"];
    
    //id arrayDataString  =  [dict objectForKey:SKILLS];
    id arrayDataString  =  [dict objectForKey:serverKey];
    
    if ([arrayDataString isKindOfClass:[NSString  class]]) {
        if(![arrayDataString isEqualToString:@""]){
            NSArray * stringsArray  =  [ReusedMethods getArrayFromString:arrayDataString];
            for (NSString * nameStr in stringsArray) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%@ = %@)",nameString,nameStr];
                NSArray * array = [dropDownlistSkillsArray  filteredArrayUsingPredicate:predicate];
                [selectedObjectsArray addObjectsFromArray:array];
            }
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

- (void) selectedMultipleValueData:(NSMutableArray *)selectedData withkeyId:(NSString *)keyId andKey:(NSString *)key andDataType:(PopupType)dataType{
    
    smAddProfileThirdVCModel.isPopOverPresent = NO;
    
    if (dataType == kJobType) {
        NSArray *valueArray = [selectedData valueForKey:@"key"];
        [[[ReusedMethods sharedObject] userProfileInfo] setObject:valueArray forKey:JOB_TYPES];
    }
    else {
        NSMutableArray * selectedIdsArray = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in selectedData) {
            [selectedIdsArray addObject:[dict objectForKey:keyId]];
        }
        
        NSString * selectedkey = nil;
        
        if(dataType  == kPracticeManagement){
            selectedkey  = PRACTICE_MANAGEMENT;
        }else if (dataType  == kAdditionalSkills){
            selectedkey  = SKILLS;
        }
        
        NSMutableArray *lastSelectedList = [[NSMutableArray alloc] init];
        
        [lastSelectedList addObjectsFromArray:[[[ReusedMethods sharedObject] userProfileInfo] valueForKey:selectedkey]];
        
        if (!lastSelectedList) {
            lastSelectedList = [[NSMutableArray alloc] init];
        }
        
        NSArray *  softwareProficiencyObjectsArray =  [[[ReusedMethods  sharedObject] dropDownListDict] objectForKey:@"software_proficiency"];
        NSMutableArray *subCategoryDictArr = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in softwareProficiencyObjectsArray) {
            if ([[dict valueForKey:@"parent_id"] isKindOfClass:[NSNumber class]]) {
                [subCategoryDictArr addObject:[dict valueForKey:@"software_type_id"]];
            }
        }
        
        
        
        NSMutableArray *lastSelObjectsList = [[NSMutableArray alloc] init];
        
        if (smAddProfileThirdVCModel.isSubCategoryTF) {
            for (NSString *number in lastSelectedList) {
                NSNumber *num = [NSNumber numberWithInt:number.intValue];
                if (![subCategoryDictArr containsObject:num]) {
                    [lastSelObjectsList addObject:num];
                }
            }
        }else{
            for (NSString *number in lastSelectedList) {
                NSNumber *num = [NSNumber numberWithInt:number.intValue];
                if ([subCategoryDictArr containsObject:num]) {
                    [lastSelObjectsList addObject:num];
                }
            }
        }
        
        
        for (NSNumber *num in lastSelectedList) {
            if ([selectedIdsArray containsObject:num]) {
                [lastSelObjectsList addObject:num];
            }
        }
        
        [selectedIdsArray addObjectsFromArray:lastSelObjectsList];
        
        NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:selectedIdsArray];
        NSArray *arrayWithoutDuplicates = [orderedSet array];
        
        [[[ReusedMethods sharedObject] userProfileInfo] setObject:arrayWithoutDuplicates forKey:selectedkey];
        if([selectedkey isEqualToString:SKILLS])
            [self updateLanguagesViewBasedOnselectedAdditionalSkillsArray:arrayWithoutDuplicates];
        if([selectedkey isEqualToString:PRACTICE_MANAGEMENT])
            [self updateOtherPracticeSoftwareExperienceBasedOnselectedOther:arrayWithoutDuplicates];

        
    }
}

#pragma mark - TEXT VIEW  DELEGATE  METHODS

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self.view endEditing:YES];
    return [smAddProfileThirdVCModel textViewShouldBeginEditing:textView];
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
     return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
   return  [smAddProfileThirdVCModel textView:textView shouldChangeTextInRange:range replacementText:text];
}
- (void)textViewDidChange:(UITextView *)textView
{
    [smAddProfileThirdVCModel textViewDidChange:textView];
}
#pragma mark - Update UI Methods

- (void) updateUI:(NSDictionary *)profileInfo
{
    NSString *  workAvilabityString , * locationRangeString ,* performanceManagementSkillsString,*additionalTextviewString;
    
    workAvilabityString  = ![ReusedMethods isObjectClassNameString:[profileInfo objectForKey:WORK_AVAILABILITY]] ?   [ReusedMethods getcorrespondingStringWithId:[profileInfo objectForKey:WORK_AVAILABILITY]  andKey:WORK_AVAILABILITY]:[profileInfo objectForKey:WORK_AVAILABILITY] ;
    locationRangeString  = ![ReusedMethods isObjectClassNameString:[profileInfo objectForKey:LOCATION_RANGE]] ? [ReusedMethods getcorrespondingStringWithId:[profileInfo objectForKey:LOCATION_RANGE]  andKey:LOCATION_RANGE]:[profileInfo objectForKey:LOCATION_RANGE] ;
    performanceManagementSkillsString = ![ReusedMethods isObjectClassNameString:[profileInfo objectForKey:PRACTICE_MANAGEMENT]] ? [ReusedMethods getCombainedStringFromServerResponseArrayHavingServerkey:PRACTICE_MANAGEMENT]:[profileInfo objectForKey:PRACTICE_MANAGEMENT];
    additionalTextviewString = ![ReusedMethods isObjectClassNameString:[profileInfo objectForKey:SKILLS]] ? [ReusedMethods getCombainedStringFromServerResponseArrayHavingServerkey:SKILLS]:[profileInfo objectForKey:SKILLS];
    
    //Get Job Types combined string
    NSString *jobTypeString = @"";
    NSArray *jobTypesArray = [profileInfo objectForKey:JOB_TYPES];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(self.key IN %@)", jobTypesArray];
    NSArray *jobTypeNamesArray = [[ReusedMethods arrayJobTypes] filteredArrayUsingPredicate:predicate];
    jobTypeString = [[jobTypeNamesArray valueForKey:@"value"] componentsJoinedByString: @", "];
    
    //Separating the sub categories strings.
    NSArray *stringsArr = [additionalTextviewString componentsSeparatedByString:@","];
    NSMutableString *subCatStrings = [[NSMutableString alloc] init];
    NSMutableString *skillsStrings = [[NSMutableString alloc] init];
    for (NSString *str in stringsArr) {
        if ([str containsString:@"Sub-"]) {
            [subCatStrings appendString:[NSString stringWithFormat:@" %@,",[str stringByReplacingOccurrencesOfString:@"Sub-" withString:@""]]];
        }else{
            NSString *skillsStr = str;
            if ([str containsString:@"Par-"]) {
                skillsStr = [str stringByReplacingOccurrencesOfString:@"Par-" withString:@""];
            }
            [skillsStrings appendString:[NSString stringWithFormat:@" %@,",skillsStr]];
        }
    }
    
    if (subCatStrings.length > 0) {
        
        subCatStrings = (NSMutableString *)[subCatStrings substringToIndex:[subCatStrings length]-1];
        
        NSString *trimmedSubString = [subCatStrings stringByTrimmingCharactersInSet:
                                      [NSCharacterSet whitespaceCharacterSet]];
        
        //Removing the morethan one spaces from string.
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"  +" options:NSRegularExpressionCaseInsensitive error:&error];
        
        trimmedSubString = [regex stringByReplacingMatchesInString:trimmedSubString options:0 range:NSMakeRange(0, [trimmedSubString length]) withTemplate:@" "];
        
         specializedAssistantTriningTxtView.text = [ReusedMethods replaceEmptyString:trimmedSubString emptyString:SPACE];
    }
    
    skillsStrings = (NSMutableString *)[skillsStrings substringToIndex:[skillsStrings length]-1];
    
    NSString *trimmedString = [skillsStrings stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    //Removing the morethan one spaces from string.
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"  +" options:NSRegularExpressionCaseInsensitive error:&error];
    
    trimmedString = [regex stringByReplacingMatchesInString:trimmedString options:0 range:NSMakeRange(0, [trimmedString length]) withTemplate:@" "];
    
    additionalSkillsTextView.text = [ReusedMethods replaceEmptyString:trimmedString emptyString:SPACE];
    
    _jobTypeTextField.text = [ReusedMethods replaceEmptyString:jobTypeString emptyString:SPACE];
    workAvailabilityTextField.text = [ReusedMethods replaceEmptyString:workAvilabityString emptyString:SPACE];
    workavailabilityDateTextFld.text  = [ReusedMethods changeDisplayFormatOfDateString:[profileInfo objectForKey:WORK_AVAILABILITY_AFTER_DATE] inTheFormate:SERVER_DATE_FORMATE WithEmptyString:SPACE];
    opportunitiesTextView.text = [ReusedMethods replaceEmptyString:locationRangeString emptyString:SPACE];
    performanceManagementSkillsTextView.text = [ReusedMethods replaceEmptyString:performanceManagementSkillsString emptyString:SPACE];
    languagesTextFld.text  =  [profileInfo objectForKey:BILINGUAL_LANGUAGES];
    otherPracticeSoftwareDescriptionTxtFld.text = [profileInfo objectForKey:OTHER_PRACTICE_DESCRIPTION_SOFTWARE];
    
    [self updateWorkDayPreferences];
    [self updateOtherPracticeSoftwareExperienceBasedOnselectedOther:[profileInfo  objectForKey:PRACTICE_MANAGEMENT]];
    [self updateWorkDayAvailabilityAfterDateViewBasedOnselectedWorkAvailabilityID:[profileInfo objectForKey:WORK_AVAILABILITY]];
    [self updateLanguagesViewBasedOnselectedAdditionalSkillsArray:[profileInfo objectForKey:SKILLS]];

 }
- (void) updateWorkDayPreferences{
    
    NSMutableArray *  daysInfoArray  =  [[ReusedMethods sharedObject].dropDownListDict objectForKey:@"shifts"];
    NSMutableArray *  parametersArray  =  [[ReusedMethods  sharedObject].userProfileInfo objectForKey:SHIFTS];
    
    for (NSDictionary *shift in daysInfoArray) {
        NSInteger index = [daysInfoArray indexOfObject:shift] + 1;
        NSString *predicateString = [NSString stringWithFormat:@"shiftID = %@", [shift objectForKey:@"shift_id"]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
        NSArray *array = [parametersArray filteredArrayUsingPredicate:predicate];
        
        NSDictionary *dictSh = [array firstObject];
        NSArray *days = [dictSh objectForKey:@"days"];
        NSArray *  weekDayLabelArray  =  KWEEKDAYSARRAY;
        
        for (NSString *string in weekDayLabelArray) {
            if([days containsObject: string]){
                
                NSString *tagString  = [NSString stringWithFormat:@"%d%d%d",5,(int)(index - 1),(int)[weekDayLabelArray indexOfObject:string]];
                NSInteger  tagInteger  =  [tagString  integerValue];
                
                UIButton * button  =  (UIButton *)[self.workPreferencesView viewWithTag:tagInteger];
                [button setSelected:YES];
                switch (index) {
                    case 1:
                        
                        [button setImage:[UIImage imageNamed:@"sel1"] forState:UIControlStateNormal];
                        
                        break;
                        
                    case 2:
                        
                        [button setImage:[UIImage imageNamed:@"sel2"] forState:UIControlStateNormal];
                        break;
                        
                    case 3:
                        
                        [button setImage:[UIImage imageNamed:@"sel3"] forState:UIControlStateNormal];
                        break;
                        
                    default:
                        [button setImage:[UIImage  imageNamed:@"unsel"] forState:UIControlStateNormal];
                        
                        break;
                }
                
            }
            
        }
    }
}

- (void) updateLanguagesViewBasedOnselectedAdditionalSkillsArray:(NSMutableArray *) selectedSkillsArray{
    
    NSArray *  softwareProficiencyObjectsArray =  [[[ReusedMethods  sharedObject] dropDownListDict] objectForKey:@"software_proficiency"];
//    
//   // NSInteger   skillID = 2;
//    NSString *strPredicate = [NSString stringWithFormat:@"%@ = %d",@"software_type_id", 2];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:strPredicate];
//    NSDictionary * bilingualObject_server = [[selectedSkillsArray filteredArrayUsingPredicate:predicate] firstObject];
    
    NSMutableArray *subCategoryDictArr = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in softwareProficiencyObjectsArray) {
        if ([[dict valueForKey:@"parent_id"] isKindOfClass:[NSNumber class]]) {
            [subCategoryDictArr addObject:dict];
        }
    }
    
    BOOL isSubCategory = NO;
    NSDictionary *subCat = [subCategoryDictArr firstObject];
    if ([selectedSkillsArray containsObject:[NSNumber numberWithInt:((NSString *)[subCat valueForKey:@"parent_id"]).intValue]]) {
        for (NSString *numStr in selectedSkillsArray) {
            NSNumber *numberValue = [NSNumber numberWithInt:numStr.intValue];
            for (NSDictionary *subDict in subCategoryDictArr) {
                if (([(NSNumber *)[subDict valueForKey:@"software_type_id"] intValue]) == [numberValue intValue]) {
                    isSubCategory = YES;
                }
            }
        }
    }
    
    if ([selectedSkillsArray count] > 0) {
        if ([[selectedSkillsArray firstObject] isKindOfClass:[NSString class]]) {
            if ([selectedSkillsArray containsObject:[NSString stringWithFormat:@"%@",[subCat valueForKey:@"parent_id"]]]) {
                for (NSString *numStr in selectedSkillsArray) {
                    NSNumber *numberValue = [NSNumber numberWithInt:numStr.intValue];
                    for (NSDictionary *subDict in subCategoryDictArr) {
                        if (([(NSNumber *)[subDict valueForKey:@"parent_id"] intValue]) == [numberValue intValue]) {
                            isSubCategory = YES;
                        }
                    }
                }
            }
        }else if ([[selectedSkillsArray firstObject] isKindOfClass:[NSNumber class]]){
            if ([selectedSkillsArray containsObject:[subCat valueForKey:@"parent_id"]]) {
                for (NSString *numStr in selectedSkillsArray) {
                    NSNumber *numberValue = [NSNumber numberWithInt:numStr.intValue];
                    for (NSDictionary *subDict in subCategoryDictArr) {
                        if (([(NSNumber *)[subDict valueForKey:@"parent_id"] intValue]) == [numberValue intValue]) {
                            isSubCategory = YES;
                        }
                    }
                }
            }
        }
    }

    
    NSMutableDictionary *subCatDict = [[NSMutableDictionary alloc] init];
    if ([subCategoryDictArr count] > 0) {
        [subCatDict setObject:subCategoryDictArr forKey:[[subCategoryDictArr firstObject] valueForKey:@"parent_id"]];
    }
    
    NSString *str = @"Bilingual";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(software_type_name BEGINSWITH[c] %@)", str];
    id bilingualResultID = [[[softwareProficiencyObjectsArray filteredArrayUsingPredicate:pred] firstObject] objectForKey:@"software_type_id"];
    
    NSNumber *parentId = 0;
    NSString *string = @"";//Specialized assistant training";
    if ([[subCatDict allKeys] count] > 0) {
        parentId = [[subCatDict allKeys] firstObject];
    }
    
    for (NSDictionary *objDict in softwareProficiencyObjectsArray) {
        if ([(NSNumber *)[objDict objectForKey:@"software_type_id"] intValue] == parentId.intValue) {
            string = [objDict valueForKey:@"software_type_name"];
            break;
        }
    }
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(software_type_name BEGINSWITH[c] %@)", string];
    id specAssTrResultID = [[[softwareProficiencyObjectsArray filteredArrayUsingPredicate:predicate] firstObject] objectForKey:@"software_type_id"];
    
    
    if(selectedSkillsArray && [selectedSkillsArray isKindOfClass:[NSArray class]]){
        if([[selectedSkillsArray firstObject] isKindOfClass:[NSString class]]){
            bilingualResultID  =  [NSString stringWithFormat:@"%@",bilingualResultID];
            specAssTrResultID = [NSString stringWithFormat:@"%@",specAssTrResultID];
        }
        
        if([selectedSkillsArray containsObject:specAssTrResultID] || isSubCategory){
            specializedAssTrainingHeightConstraint.constant  =  85;
            self.specializedAssistantTriningTxtView.placeholder = string;
        }else{
            specializedAssTrainingHeightConstraint.constant  =  0;
            //Removing Subcategory fields data.
            NSArray *selectedSkillsArray = [[[ReusedMethods sharedObject] userProfileInfo] valueForKey:SKILLS];
            NSMutableArray *subCatArr = [[NSMutableArray alloc] init];
            for (NSDictionary *subDict in subCategoryDictArr) {
                [subCatArr addObject:[subDict valueForKey:@"software_type_id"]];
            }
            NSMutableArray *removedSubCatArr = [[NSMutableArray alloc] init];
            for (NSNumber *subCatNumber in selectedSkillsArray) {
                if (![subCatArr containsObject:subCatNumber]) {
                    [removedSubCatArr addObject:subCatNumber];
                }
            }
            [[[ReusedMethods sharedObject] userProfileInfo] setObject:removedSubCatArr forKey:SKILLS];
            self.specializedAssistantTriningTxtView.text = SPACE;
        }
        
        if([selectedSkillsArray containsObject:bilingualResultID]){
            languagesFieldHeightConstraint.constant  =  55;
            
        }else{
            languagesFieldHeightConstraint.constant  =  0;
            [[[ReusedMethods sharedObject] userProfileInfo] setObject:SPACE forKey:BILINGUAL_LANGUAGES];
        }
    }else{
        languagesFieldHeightConstraint.constant  =  0;
        specializedAssTrainingHeightConstraint.constant = 0;
    }
}

- (void) updateOtherPracticeSoftwareExperienceBasedOnselectedOther:(NSMutableArray *) selectedPracticeSoftwareExperienceArray{
    
    NSArray *  practiceSoftwareExperienceArray =  [[[ReusedMethods  sharedObject] dropDownListDict] objectForKey:@"praticeManagementSoftware"];
    //
    //   // NSInteger   skillID = 2;
    //    NSString *strPredicate = [NSString stringWithFormat:@"%@ = %d",@"software_type_id", 2];
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:strPredicate];
    //    NSDictionary * bilingualObject_server = [[selectedSkillsArray filteredArrayUsingPredicate:predicate] firstObject];
    
    
    NSString *str = @"Other";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(software BEGINSWITH[c] %@)", str];
    id resultID = [[[practiceSoftwareExperienceArray filteredArrayUsingPredicate:pred] firstObject] objectForKey:@"software_id"];
    
    if(selectedPracticeSoftwareExperienceArray && [selectedPracticeSoftwareExperienceArray isKindOfClass:[NSArray class]]){
        if([[selectedPracticeSoftwareExperienceArray firstObject] isKindOfClass:[NSString class]]){
            resultID  =  [NSString stringWithFormat:@"%@",resultID];
        }
        
        
        if([selectedPracticeSoftwareExperienceArray containsObject:resultID]){
            otherPracticeSoftwareExperienceHeightConstraight.constant  =  55;
            
        }else{
            otherPracticeSoftwareExperienceHeightConstraight.constant  =  0;
            [[[ReusedMethods sharedObject] userProfileInfo] setObject:SPACE forKey:OTHER_PRACTICE_DESCRIPTION_SOFTWARE];
        }
    }else{
        otherPracticeSoftwareExperienceHeightConstraight.constant  =  0;
    }
    
}


- (void) updateWorkDayAvailabilityAfterDateViewBasedOnselectedWorkAvailabilityID:(id) workAvailabilityId{
    
//    NSArray *  softwareProficiencyObjectsArray =  [[[ReusedMethods  sharedObject] dropDownListDict] objectForKey:@"work_availability"];
//    
//    NSString *str = @"Available after";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(work_availabilty_name BEGINSWITH[c] %@)", str];
//    id resultID = [[[softwareProficiencyObjectsArray filteredArrayUsingPredicate:pred] firstObject] objectForKey:@"work_id"];
//    
//    if(workAvailabilityId  ==  resultID){
    
    if([SMValidation isWorkAvailabilityDateIDSelected:workAvailabilityId]){
        workavailabilityDateTextFieldHeightConstraint.constant  =  55;
    }else{
        workavailabilityDateTextFieldHeightConstraint.constant  =  0;
         [[[ReusedMethods sharedObject] userProfileInfo] setObject:@"" forKey:WORK_AVAILABILITY_AFTER_DATE];
    }
}


#pragma  mark - DATEPICKER DELEGATE METHODS

- (void) selectedExpiryDate:(NSDate *)expiryDate withDateString:(NSString *)dateString monthString:(NSString *)month andYearString:(NSString *)yearString
{
    [self.view endEditing:YES];
   // [workavailabilityDateTextFld setText:dateString];
    
    NSDateFormatter * formater  =  [[NSDateFormatter alloc]  init];
    [formater setDateFormat:SERVER_DATE_FORMATE];
    NSString *string = [formater stringFromDate:expiryDate];
    
    
    NSDateFormatter *  formatter2  =   [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:APP_DISPLAY_DATE_FORMATE];
    NSString *string2 = [formatter2 stringFromDate:expiryDate];
    
    [workavailabilityDateTextFld setText:string2];


    
    [[[ReusedMethods sharedObject] userProfileInfo] setObject:string forKey:WORK_AVAILABILITY_AFTER_DATE];
}

- (void) profileUpdateNotificationForCurrentVC{
    
}



@end
