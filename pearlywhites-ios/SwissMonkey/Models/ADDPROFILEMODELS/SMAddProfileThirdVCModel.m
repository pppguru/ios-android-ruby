//
//  SMAddProfileThirdVCModel.m
//  SwissMonkey
//
//  Created by Prasad on 2/22/16.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import "SMAddProfileThirdVCModel.h"

@implementation SMAddProfileThirdVCModel{
    UIDatePicker * datePicker;
}

@synthesize toolsView;


- (id) init{
    self  =  [super init];
    if(self){
        _profileShiftsArray = [[NSMutableArray alloc] init];
    }
    return self;
}


#pragma mark - Dropdown actions

- (void)clickedProfileJobType:(UITextField*)textField {
   
    NSArray *arrayJobtypes = [[[ReusedMethods sharedObject] userProfileInfo] objectForKey:JOB_TYPES];
    if (!arrayJobtypes) arrayJobtypes = [NSArray array];
    NSPredicate *predict = [NSPredicate predicateWithFormat:@"key IN %@", arrayJobtypes];
    arrayJobtypes = [[ReusedMethods arrayJobTypes] filteredArrayUsingPredicate:predict];
    
    [ReusedMethods setupPopUpViewForTextField:textField
                             withDisplayArray:[ReusedMethods arrayJobTypes]
                                      withDel:_delegate
                                   displayKey:@"value"
                                    returnKey:@"value"
                                      withTag:kJobType
                                isMultiSelect:YES
                             selectedPosItems:arrayJobtypes];
}

- (void)clickedProfileWorkAvailability:(UITextField*)textField {
    
    NSMutableDictionary  *  totalListDict  =  [[ReusedMethods sharedObject] dropDownListDict];
    NSString *  keyString  =  [self getKeyForDropDownListOfTextFieldTag:[textField  tag]];
    
    [ReusedMethods setupPopUpViewForTextField:textField
                             withDisplayArray:[totalListDict  objectForKey:keyString]
                                      withDel:_delegate
                                   displayKey:@"work_availabilty_name"
                                    returnKey:@"work_id"
                                      withTag:kWorkAvailability];
}

- (void)clickedProfileWorkAvailiabilityAfterDateAvailability:(UITextField*)textField {
    
    [textField resignFirstResponder];
    [textField setInputView:datePicker];
    [toolsView setHidden:NO];
}

- (void)clickedProfileOpportunityDistance:(UITextView*) textView{
    NSMutableDictionary  *  totalListDict  =  [[ReusedMethods sharedObject] dropDownListDict];
    NSString *  keyString  =  [self getKeyForDropDownListOfTextFieldTag:[textView  tag]];
    
    if (!self.isPopOverPresent) {
        self.isPopOverPresent = YES;
        [ReusedMethods setupPopUpViewForTextView:textView withDisplayArray:[totalListDict  objectForKey:keyString] withDel:_delegate displayKey:@"miles_range" returnKey:@"range_id" withTag:kOpportunitiesRange];
    }
}

- (void)clickedProfilePerformanceManagement:(UITextView*) textView{
    NSMutableDictionary  *  totalListDict  =  [[ReusedMethods sharedObject] dropDownListDict];
    NSString *  keyString  =  [self getKeyForDropDownListOfTextFieldTag:[textView  tag]];
    
    [textView setUserInteractionEnabled:NO];
    NSMutableArray * selecteditemsArray = [self getSelectedItemsArrayWithSelectedKeyArray:[totalListDict  objectForKey:keyString] serverKey:PRACTICE_MANAGEMENT filterWithKeyString:@"software" IdString:@"software_id"];
    if (!self.isPopOverPresent) {
        self.isPopOverPresent = YES;
        [ReusedMethods addMultiplePopupViewWithVC:self.delegate dataArray:[totalListDict  objectForKey:keyString] dataKey:@"software" idName:@"software_id" textField:textView andSelectedItems:selecteditemsArray withTag:kPracticeManagement];
    }
}

- (void)clickedProfileAdditionalSkills:(UITextView*) textView{
    NSMutableDictionary  *  totalListDict  =  [[ReusedMethods sharedObject] dropDownListDict];
    NSMutableArray *subCategoryDictArr = [[NSMutableArray alloc] init];
    NSMutableArray *softProficiencyArrayList = [[NSMutableArray alloc] initWithArray:[totalListDict  objectForKey:@"software_proficiency"]];
    
    for (NSDictionary *dict in [totalListDict  objectForKey:@"software_proficiency"]) {
        if ([[dict valueForKey:@"parent_id"] isKindOfClass:[NSNumber class]]){
            [subCategoryDictArr addObject:dict];
            [softProficiencyArrayList removeObject:dict];
        }
    }
    
    _isSubCategoryTF = NO;
    [textView setUserInteractionEnabled:NO];
    NSMutableArray * selecteditemsArray = [self getSelectedItemsArrayWithSelectedKeyArray:softProficiencyArrayList serverKey:SKILLS filterWithKeyString:@"software_type_name" IdString:@"software_type_id"];
    
    if (!self.isPopOverPresent) {
        self.isPopOverPresent = YES;
        [ReusedMethods addMultiplePopupViewWithVC:self.delegate dataArray:softProficiencyArrayList dataKey:@"software_type_name" idName:@"software_type_id" textField:textView andSelectedItems:selecteditemsArray withTag:kAdditionalSkills];
    }
}

- (void)clickedProfileSpecializedAssisting:(UITextView*) textView{
    NSMutableDictionary  *  totalListDict  =  [[ReusedMethods sharedObject] dropDownListDict];
    NSMutableArray *subCategoryDictArr = [[NSMutableArray alloc] init];
    NSMutableArray *softProficiencyArrayList = [[NSMutableArray alloc] initWithArray:[totalListDict  objectForKey:@"software_proficiency"]];
    
    for (NSDictionary *dict in [totalListDict  objectForKey:@"software_proficiency"]) {
        if ([[dict valueForKey:@"parent_id"] isKindOfClass:[NSNumber class]]){
            [subCategoryDictArr addObject:dict];
            [softProficiencyArrayList removeObject:dict];
        }
    }
    
    _isSubCategoryTF = YES;
    
    [textView setUserInteractionEnabled:NO];
    NSMutableArray * selecteditemsArray = [self getSelectedItemsArrayWithSelectedKeyArray:subCategoryDictArr serverKey:SKILLS filterWithKeyString:@"software_type_name" IdString:@"software_type_id"];
    
    if (!self.isPopOverPresent) {
        self.isPopOverPresent = YES;
        [ReusedMethods addMultiplePopupViewWithVC:self.delegate dataArray:subCategoryDictArr dataKey:@"software_type_name" idName:@"software_type_id" textField:textView andSelectedItems:selecteditemsArray withTag:kAdditionalSkills];
    }
}







#pragma mark - TEXTFIELD  DELEGATE  METHODS
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    return   [textField resignFirstResponder];
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    [toolsView setHidden:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([textField tag]  == PROFILE_LANGUAGES_TEXTFIELD_TAG || [textField tag] == PROFILE_OTHER_PRACTICE_DESCRIPTION_TEXTFLD_TAG){
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
        textField.text = text;
        UITextPosition *newCursorPosition = [textField positionFromPosition:textField.beginningOfDocument offset:cursorOffset];
        UITextRange *newSelectedRange = [textField textRangeFromPosition:newCursorPosition toPosition:newCursorPosition];
        [textField setSelectedTextRange:newSelectedRange];
        
//        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if([textField tag]  ==  PROFILE_LANGUAGES_TEXTFIELD_TAG){
        [[[ReusedMethods sharedObject] userProfileInfo] setObject:[SMValidation removeUnwantedSpaceForString:text] forKey:BILINGUAL_LANGUAGES];
        }
        if([textField tag]  ==  PROFILE_OTHER_PRACTICE_DESCRIPTION_TEXTFLD_TAG){
        [[[ReusedMethods sharedObject] userProfileInfo] setObject:[SMValidation removeUnwantedSpaceForString:text] forKey:OTHER_PRACTICE_DESCRIPTION_SOFTWARE];
        }
    }
    [ReusedMethods setCapitalizationForFirstLetterOfField:textField];
    return NO;
//    return YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if([textField tag] ==  PROFILE_JOB_TYPE_TXTFLD_TAG){
        [self clickedProfileJobType:textField];
        return NO;
    }
    else if([textField tag] ==  PROFILE_WORK_AVAILALABILITY_TXTFLD_TAG){
        [self clickedProfileWorkAvailability:textField];
        return NO;
    }else if ([textField tag] == PROFILE_WORK_AVAILABILITY_AFTER_DATE_TEXTFLD_TAG){
        [self clickedProfileWorkAvailiabilityAfterDateAvailability:textField];
        return YES;
    }
    else{
        return YES;
    }
}

- (NSString *) getKeyForDropDownListOfTextFieldTag:(NSInteger) tag{
    
    if (tag  ==  PROFILE_JOB_TYPE_TXTFLD_TAG){
        return @"jobtype";
    }
    else if (tag  ==  PROFILE_WORK_AVAILALABILITY_TXTFLD_TAG){
        return @"work_availability";
    }
    else if (tag  ==  PROFILE_LOOKING_FOR_OPPORTUNITIES_TXTVIEW_TAG){
        return @"location_range";
    }
    else if (tag  ==  PROFILE_PERFORMANCE_MANAGEMENT_TXTVIEW_TAG){
        return @"praticeManagementSoftware";
    }
    else if (tag  ==  PROFILE_ADDITIONAL_SKILLS_TXTVIEW_TAG){
        return @"software_proficiency";
    }
    else if (tag  ==  PROFILE_SPECIALIZED_ASSISTANT_TRAINING_TXTVIEW_TAG){
        return @"Specialized assistant training";
    }
    return @"";
}

#pragma mark - TEXT VIEW  DELEGATE  METHODS

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
     if([textView tag] ==  PROFILE_LOOKING_FOR_OPPORTUNITIES_TXTVIEW_TAG){
         [self clickedProfileOpportunityDistance:textView];
        return NO;
    }
    else if([textView tag] ==  PROFILE_PERFORMANCE_MANAGEMENT_TXTVIEW_TAG){
        [self clickedProfilePerformanceManagement:textView];
        return NO;
    }
    else if([textView tag] ==  PROFILE_ADDITIONAL_SKILLS_TXTVIEW_TAG){
        [self clickedProfileAdditionalSkills:textView];
        return NO;
    }
    else if([textView tag] ==  PROFILE_SPECIALIZED_ASSISTANT_TRAINING_TXTVIEW_TAG){
        [self clickedProfileSpecializedAssisting:textView];
        return NO;
    }
    else{
        return YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
//    NSUInteger maxNumberOfLines = 2;
//    NSUInteger numLines = textView.contentSize.height/textView.font.lineHeight;
//    if (numLines > maxNumberOfLines)
//    {
//        textView.text = [textView.text substringToIndex:textView.text.length - 1];
//    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    static const NSUInteger MAX_NUMBER_OF_LINES_ALLOWED = 4;
   // return YES;
    NSMutableString *t = [NSMutableString stringWithString:
                          textView.text];
    [t replaceCharactersInRange: range withString: text];
    
    NSUInteger numberOfLines = 0;
    for (NSUInteger i = 0; i < t.length; i++) {
        if ([[NSCharacterSet newlineCharacterSet]
             characterIsMember: [t characterAtIndex: i]]) {
            numberOfLines++;
        }
    }
    
    return (numberOfLines < MAX_NUMBER_OF_LINES_ALLOWED);
}
- (void) changeWorkDayPreferencesButtonStateOfButton:(UIButton * ) button
{
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
    
    NSMutableDictionary *shiftDict = [_profileShiftsArray objectAtIndex:shift];
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
    
    [[[ReusedMethods sharedObject] userProfileInfo] setObject:_profileShiftsArray forKey:SHIFTS];
//    NSLog(@"Shift : %ld, Day: %@", shift, strDay);
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

# pragma mark  - DATE PICKER METHODS

- (void) setupDatePicker{
    datePicker = [[UIDatePicker alloc] init];
    [datePicker setDate:[NSDate date]];
    [datePicker setMinimumDate:[NSDate date]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.backgroundColor  =  [UIColor appWhiteColor];
    
    float toobarHeight  =  50 ;
    float screenWidth  = [[UIScreen mainScreen] bounds].size.width;
    float screenHeight  = [[UIScreen mainScreen] bounds].size.height;
    float yPos  =  screenHeight - CGRectGetHeight(datePicker.frame) - toobarHeight;
    toolsView  =  [[UIView alloc] initWithFrame:CGRectMake(0, yPos, screenWidth, toobarHeight)];
    toolsView.backgroundColor  =  [UIColor appLightPinkColor];
    
    float doneButtonXpos  =  screenWidth -  100 - 10;
    UIButton  *  doneButton  =  [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setFrame:CGRectMake(doneButtonXpos, 5, 100, toobarHeight - 10)];
    [doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [doneButton setTitle:@"DONE" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor appWhiteColor] forState:UIControlStateNormal];
    [toolsView addSubview:doneButton];
    //  window  object to display the popup view
    UIWindow *  window  =  [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:toolsView];
    [toolsView setHidden:YES];
}

- (void) doneButtonAction:(id) sender
{
    
    [toolsView setHidden:YES];
    
    NSDate * datePickerDate  = datePicker.date;
    NSDateFormatter * dateFormatter  =  [[NSDateFormatter alloc]init];
    // get date
    [dateFormatter setDateFormat:@"dd"];
    NSString * dateString  =  [dateFormatter stringFromDate:datePickerDate];
    // get month
    [dateFormatter setDateFormat:@"MM"];
    NSString * monthString  =  [dateFormatter stringFromDate:datePickerDate];
    // get year
    [dateFormatter setDateFormat:@"yyyy"];
    NSString * YearString  =  [dateFormatter stringFromDate:datePickerDate];
    
    [self.delegate  selectedExpiryDate:datePickerDate withDateString:dateString monthString:monthString andYearString:YearString];
    
}


@end
