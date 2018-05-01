//
//  SMAddProfileDetailsSecondController.m
//  MBXPageController
//
//  Created by Kasturi on 2/3/16.
//  Copyright (c) 2016 Moblox. All rights reserved.
//

#import "SMAddProfileDetailsSecondController.h"
#import "SMAddProfileSecondVCModel.h"
#import "CircleLoaderView.h"

@interface SMAddProfileDetailsSecondController (){
    SMAddProfileSecondVCModel * smAddProfileSecondVCModel;
    
    NSMutableArray *selectedPositions;
}

@end

@implementation SMAddProfileDetailsSecondController
@synthesize seekingPositionTextField, experienceTextField, boardCertifiedTextField, licenceNumberTextField, dateTextField,monthTextField, yearTextField, verifyButton, statesListButton;

@synthesize seekingPositionButtonBGView, experienceButtonBGView, boardCertificatedButtonBGView, statesListButtonBGView;

- (void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    self.contentViewHeightConstraint.constant  =  740.;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectedPositions = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(profileUpdateNotificationForCurrentVC)
                                                 name:@"profileUpdateNotificationForCurrentVC" object:nil];
;
    
    smAddProfileSecondVCModel = [[SMAddProfileSecondVCModel alloc] init];
    smAddProfileSecondVCModel.delegate = self;
    [self provideDelegates];
    [smAddProfileSecondVCModel setupDatePicker];
    [self updateUI:[ReusedMethods sharedObject].userProfileInfo];
    self.progressView.progress  =  [ReusedMethods profileProgresValue] ;
    
    //Remove the underlines
    self.seekingPositionTextField.botomBorder.hidden = YES;
    self.experienceTextField.botomBorder.hidden = YES;
    self.boardCertifiedTextField.botomBorder.hidden = YES;
    self.selectStatesTextField.botomBorder.hidden = YES;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addLoader];
    [self performSelector:@selector(removeLoader) withObject:nil afterDelay:0.5];
}

- (void) addLoader{
    [CircleLoaderView addToWindow];
}

- (void) removeLoader{
    [CircleLoaderView removeFromWindow];
}

- (void) provideDelegates{
    seekingPositionTextField.delegate  = self;
    experienceTextField.delegate  = self;
    boardCertifiedTextField.delegate  = self;
    licenceNumberTextField.delegate  = self;
    dateTextField.delegate  = self;
    monthTextField.delegate  = self;
    yearTextField.delegate  = self;
}

- (void) updateUI:(NSDictionary *)userInfoDict{
    
    NSString *seekingPositionString, *experienceString, *boardCertifiedstring;
    
    //Get positions combined string
    NSArray *positionIDsArray = [userInfoDict objectForKey:POSITION_IDS];
    NSMutableDictionary *totalListDict = [[ReusedMethods sharedObject] dropDownListDict];
    NSArray *positionObjArray = [totalListDict objectForKey:@"positions"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(self.position_id IN %@)", positionIDsArray];
    selectedPositions = [NSMutableArray arrayWithArray:[positionObjArray filteredArrayUsingPredicate:predicate]];
    NSMutableArray *positionNamesArray = [selectedPositions valueForKey:@"position_name"];
    seekingPositionString = [positionNamesArray componentsJoinedByString: @", "];
    
    
    //Get experience string
    experienceString  = ![ReusedMethods isObjectClassNameString:[userInfoDict objectForKey:EXPERIENCE]] ? [ReusedMethods getcorrespondingStringWithId:[userInfoDict objectForKey:EXPERIENCE]  andKey:EXPERIENCE]:[userInfoDict objectForKey:EXPERIENCE] ;
    
    //boardCertifiedstring  =   [[userInfoDict objectForKey:BOARD_CERTIFIED] boolValue] == 1 ? @"YES" : @"NO";
    
    boardCertifiedstring = [NSString stringWithFormat:@"%@",[ReusedMethods replaceEmptyString:[ReusedMethods getcorrespondingStringFromLocalOptionsDictioriesWithId:[userInfoDict objectForKey:BOARD_CERTIFIED] andKey:BOARD_CERTIFIED] emptyString:SPACE]];
    
    [seekingPositionTextField setText:[ReusedMethods replaceEmptyString:seekingPositionString emptyString:SPACE]];
    [experienceTextField setText:[ReusedMethods replaceEmptyString:experienceString emptyString:SPACE]];
    [boardCertifiedTextField setText:[ReusedMethods replaceEmptyString:boardCertifiedstring emptyString:SPACE]];
    [licenceNumberTextField setText: [ReusedMethods replaceEmptyString:[userInfoDict objectForKey:LICENSE_NUMBER] emptyString:SPACE]];
    
    [ReusedMethods applyShadowToView:seekingPositionButtonBGView];
    [ReusedMethods applyShadowToView:experienceButtonBGView];
    [ReusedMethods applyShadowToView:boardCertificatedButtonBGView];
    [ReusedMethods applyShadowToView:statesListButtonBGView];
    
    NSString * dateString  =  [userInfoDict objectForKey:LICENSE_EXPIRES];
    NSDateFormatter * formater  =  [[NSDateFormatter alloc] init];
    [formater setDateFormat:SERVER_SAVING_DATE_FORMATE];
    NSDate * serverDate  =  [formater dateFromString:dateString];
    [formater setDateFormat:@"dd"];
    NSString * dateTxtFldString  =  [formater stringFromDate:serverDate];
    [formater setDateFormat:@"MM"];
    NSString * monthTxtFldString  =  [formater stringFromDate:serverDate];
    [formater setDateFormat:@"yyyy"];
    NSString * yearTxtFldString  =  [formater stringFromDate:serverDate];
    
    // Change color of Placeholder text of dd/mm/yyyy textfields
    UIColor *color = [UIColor blackColor];
    dateTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:dateTextField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    monthTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:monthTextField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    yearTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:yearTextField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    
        
    [dateTextField setText:monthTxtFldString];
    [monthTextField setText:dateTxtFldString];
    [yearTextField setText:yearTxtFldString];
    [verifyButton setSelected:[[userInfoDict objectForKey:LICENSE_VERIFICATION] boolValue]];
    [self updateVerifyButtonBasedSelectionStatus:[[userInfoDict objectForKey:LICENSE_VERIFICATION] boolValue]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - User Interactions for selectors

- (IBAction)seekingPositionButtonAction:(id)sender {
    [self setUpPopUPViewForPositions];
}

- (IBAction)boardCertifiedButtonAction:(id)sender {
    [ReusedMethods setupPopUpViewForTextField:self.boardCertifiedTextField
                             withDisplayArray:[ReusedMethods getAvailabityOptionsDictionary]
                                      withDel:self
                                   displayKey:@"boolean_name"
                                    returnKey:@"boolean_id"
                                      withTag:kAvialabilityOptions];
    
}

- (IBAction)experienceButtonAction:(id)sender {
    
    NSMutableDictionary *totalListDict = [[ReusedMethods sharedObject] dropDownListDict];
    NSString *keyString = [smAddProfileSecondVCModel getKeyForDropDownListOfTextFieldTag:PROFILE_EXPERIENCE_TEXTFIELD_TAG];
    
    [ReusedMethods setupPopUpViewForTextField:self.experienceTextField
                             withDisplayArray:[totalListDict objectForKey:keyString]
                                      withDel:self
                                   displayKey:@"experience_range"
                                    returnKey:@"experience_range_id"
                                      withTag:kExperience];
}

- (IBAction)statesListButtonAction:(id)sender {
    
    NSMutableDictionary  *  totalListDict  =  [[ReusedMethods sharedObject] dropDownListDict];
    NSString *  keyString  =  [smAddProfileSecondVCModel getKeyForDropDownListOfTextFieldTag:PROFILE_STATES_LIST_BUTTON_TAG];
    NSMutableArray * selecteditemsArray = [ReusedMethods getSelectedItemsArrayWithSelectedKeyArray:[totalListDict  objectForKey:keyString] serverKey:LICENSE_VERIFICATION_STATES filterWithKeyString:@"state_name" IdString:@"state_id"];
    
    [ReusedMethods addMultiplePopupViewWithVC:self
                                    dataArray:[totalListDict objectForKey:keyString]
                                      dataKey:@"state_name"
                                       idName:@"state_id"
                                    textField:self.selectStatesTextField
                             andSelectedItems:selecteditemsArray
                                      withTag:kStates];
    
}

- (IBAction)verifyButtonAction:(id)sender {
    UIButton * button  =  verifyButton;
    [button setSelected:![button isSelected]];
    
    [self updateVerifyButtonBasedSelectionStatus:[sender isSelected]];
 }



- (void) updateVerifyButtonBasedSelectionStatus:(BOOL) senderStatus{
    
    if([verifyButton isSelected]){
        [verifyButton setImage:[UIImage imageNamed:@"checkbox_icon_clicked"] forState:UIControlStateNormal];
    }
    else{
        [verifyButton setImage:[UIImage imageNamed:@"checkbox_icon"] forState:UIControlStateNormal];
    }
    [[[ReusedMethods sharedObject] userProfileInfo] setObject:[NSNumber numberWithBool:[verifyButton isSelected]] forKey:LICENSE_VERIFICATION];

}





#pragma mark - TEXTFIELD  DELEGATE  METHODS
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    return [smAddProfileSecondVCModel textFieldShouldBeginEditing:textField];
}
- (void) textFieldDidEndEditing:(UITextField *)textField{
    [smAddProfileSecondVCModel textFieldDidEndEditing:textField];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    return [smAddProfileSecondVCModel textFieldShouldReturn:textField];
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return [smAddProfileSecondVCModel textField:textField shouldChangeCharactersInRange:range replacementString:string];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [smAddProfileSecondVCModel textFieldDidBeginEditing:textField];
}

#pragma  mark -  RBA POPUP DELEGATE METHODS

- (void) selectedValue:(id)value withKeyId:(NSString *)keyId titleName:(NSString *)titleName withKey:(NSString *)key selectedCell:(UITableViewCell *)selectedCell withType:(PopupType)typePopup{
    
    NSString *serverkey = nil;
    if(typePopup == kPosition)
        serverkey = POSITION;
    else if(typePopup == kExperience)
        serverkey = EXPERIENCE;
    else if(typePopup == kAvialabilityOptions)
        serverkey = BOARD_CERTIFIED;
    if (serverkey.length)
        [[[ReusedMethods sharedObject] userProfileInfo] setObject:value forKey:serverkey];
    
}

- (void)popTipViewWasDismissedByUser:(RBAPopup *)popTipView{
    
}

#pragma  mark - DATEPICKER DELEGATE METHODS 

- (void) selectedExpiryDate:(NSDate *)expiryDate withDateString:(NSString *)dateString monthString:(NSString *)month andYearString:(NSString *)yearString
{
//    JVFloatLabeledTextField * textfield =  (JVFloatLabeledTextField *)[self.contentView viewWithTag:PROFILE_DATE_TXTFLD_TAG];
    [self.view endEditing:YES];
    [monthTextField setText:dateString];
    [dateTextField setText:month];
    [yearTextField setText:yearString];
    
    NSDateFormatter * formater  =  [[NSDateFormatter alloc]  init];
    [formater setDateFormat:SERVER_SAVING_DATE_FORMATE];
    
    if(expiryDate)
        [[[ReusedMethods sharedObject] userProfileInfo] setObject:[formater stringFromDate:expiryDate] forKey:LICENSE_EXPIRES];
    else
        [[[ReusedMethods sharedObject] userProfileInfo] setObject:@"" forKey:LICENSE_EXPIRES];
}

#pragma mark - POSITION SELECT
- (void) setUpPopUPViewForPositions{
    //Display the position selection popup
    [smAddProfileSecondVCModel  setUpPopUPViewWithSender:seekingPositionTextField
                                        selectedPosItems:selectedPositions
                                                 withdel:self];
}


#pragma  mark -  RBA MULTIPLE POPUP DELEGATE METHODS

- (void) selectedMultipleValueData:(NSMutableArray *)selectedData withkeyId:(NSString *)keyId andKey:(NSString *)key andDataType:(PopupType)dataType{
    
    if (dataType == kPosition) {  //In case of Position selector
        selectedPositions = selectedData;
        
        NSArray *valueArray = [selectedPositions valueForKey:@"position_id"];
        [[[ReusedMethods sharedObject] userProfileInfo] setObject:valueArray forKey:POSITION_IDS];
        [[[ReusedMethods sharedObject] userProfileInfo] setObject:valueArray forKey:POSITION];
    }
    else if (dataType  == kStates) {  //In case of the state selector
        NSMutableArray * selectedIdsArray = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in selectedData) {
            [selectedIdsArray addObject:[dict objectForKey:keyId]];
        }

        NSString * selectedkey = LICENSE_VERIFICATION_STATES;
        [[[ReusedMethods sharedObject] userProfileInfo] setObject:selectedIdsArray forKey:selectedkey];
    }
}

- (void) profileUpdateNotificationForCurrentVC{
    
}


@end
