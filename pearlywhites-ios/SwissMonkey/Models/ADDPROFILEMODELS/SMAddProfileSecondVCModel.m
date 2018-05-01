//
//  SMAddProfileSecondVCModel.m
//  SwissMonkey
//
//  Created by Prasad on 2/22/16.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import "SMAddProfileSecondVCModel.h"

@implementation SMAddProfileSecondVCModel{
    UIDatePicker * datePicker;
    UIView *  toolsView;
}

- (id) init{
   self = [super init];
    if (self) {
        
        
    }
    return self;
}


#pragma mark - TEXTFIELD  DELEGATE  METHODS

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    if([textField tag]  !=  PROFILE_LICENCE_NUMBER_TEXTFIELD_TAG){
        return NO;
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    [toolsView setHidden:YES];
    [textField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if([textField  tag]  ==  PROFILE_DATE_TXTFLD_TAG){
        [toolsView setHidden:NO];
    }
}


- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    
    NSMutableDictionary  *  totalListDict  =  [[ReusedMethods sharedObject] dropDownListDict];
    NSString *  keyString  =  [self getKeyForDropDownListOfTextFieldTag:[textField  tag]];
    
    if([textField tag]  ==  PROFILE_POSITION_TEXTFIELD_TAG){
        [self.delegate setUpPopUPViewForPositions];
        return NO;
    }
    else if ([textField tag]  == PROFILE_EXPERIENCE_TEXTFIELD_TAG){
        [ReusedMethods setupPopUpViewForTextField:textField withDisplayArray:[totalListDict  objectForKey:keyString] withDel:_delegate displayKey:@"experience_range" returnKey:@"experience_range_id" withTag:kExperience];
        return NO;
    }else if ([textField tag]  ==  PROFILE_BOARD_CERTIFIED_TEXTFIELD_TAG){
        [ReusedMethods setupPopUpViewForTextField:textField withDisplayArray:[ReusedMethods  getAvailabityOptionsDictionary] withDel:_delegate displayKey:@"boolean_name" returnKey:@"boolean_id" withTag:kAvialabilityOptions];
        return NO;
    }
    else if ([textField tag]  ==  PROFILE_DATE_TXTFLD_TAG){
        [textField resignFirstResponder];
        [textField setInputView:datePicker];
        [toolsView setHidden:NO];
        return YES;
    }
        
    else{
        return YES;
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    textField.text = text;
    NSString *key = nil;
    if([textField  tag]== PROFILE_LICENCE_NUMBER_TEXTFIELD_TAG)
        key = LICENSE_NUMBER;
    else if([textField tag] == PROFILE_DATE_TXTFLD_TAG)
        key = LICENSE_EXPIRES;
    
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
    
    //    NSLog(@"%@ : %@", key, text);n
    [[[ReusedMethods sharedObject] userProfileInfo] setObject:text forKey:key];
    return NO;
}

- (NSString *) getKeyForDropDownListOfTextFieldTag:(NSInteger) tag{
    
    if (tag  ==  PROFILE_POSITION_TEXTFIELD_TAG) {
        return  @"positions";
    }else if (tag == PROFILE_EXPERIENCE_TEXTFIELD_TAG){
        return  @"experience";
        
    }else if (tag  == PROFILE_STATES_LIST_BUTTON_TAG){
        return @"state_list";
    }
    return @"";
}

#pragma mark - Setup the Position Picker
- (void) setUpPopUPViewWithSender:(UITextField *) textField
                 selectedPosItems:(NSArray*)selectedPosItems
                          withdel:(id) delegate {
    
    NSMutableDictionary  *  totalListDict  =  [[ReusedMethods sharedObject] dropDownListDict];
    NSString *  keyString  =  [self getKeyForDropDownListOfTextFieldTag:[textField  tag]];
    
    [ReusedMethods setupPopUpViewForTextField:textField
                             withDisplayArray:[totalListDict objectForKey:keyString]
                                      withDel:delegate
                                   displayKey:@"position_name"
                                    returnKey:@"position_id"
                                      withTag:kPosition
                                isMultiSelect:YES
                             selectedPosItems:selectedPosItems];

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
    UIButton  *doneButton  =  [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setFrame:CGRectMake(doneButtonXpos, 5, 100, toobarHeight - 10)];
    [doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [doneButton setTitle:@"DONE" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor appWhiteColor] forState:UIControlStateNormal];
    [toolsView addSubview:doneButton];
    
    UIButton  *clearButton  =  [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setFrame:CGRectMake(5, 5, 100, toobarHeight - 10)];
    [clearButton addTarget:self action:@selector(clearButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [clearButton setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [clearButton setTitle:@"Clear" forState:UIControlStateNormal];
    [clearButton setTitleColor:[UIColor appWhiteColor] forState:UIControlStateNormal];
    [toolsView addSubview:clearButton];
    
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

- (void) clearButtonAction:(id) sender
{
    [toolsView setHidden:YES];
    [self.delegate  selectedExpiryDate:nil withDateString:@"" monthString:@"" andYearString:@""];
}


@end
