//
//  SMSignUpVC.m
//  SwissMonkey
//
//  Created by Kasturi on 23/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import "SMSignUpVC.h"

@implementation SMSignUpVC{
    BOOL termsAndConditionsAccepted;
    UIView *termsAndConditionsView;
    
    NSMutableArray *arraySelectedPositions;
}

@synthesize smSignUpModel,userNameTxtFld,paswordTxtFld,emailIdTxtFld,zipCodeTxtFld, reEnterPasswordTxtFld,searchPositionTxtFld,registerButton,termsAndConditionsButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title  = @"Sign UP VC";
    
    //Initialize the variables
    arraySelectedPositions = [NSMutableArray array];
    
    //Setup the sign up model
    smSignUpModel  =  [[SMSignUpModel alloc]  init];
    [smSignUpModel setDelegate:self];
    if(![[[ReusedMethods sharedObject].dropDownListDict allKeys] count])
        [smSignUpModel callDropDownListMethods];
//    [ReusedMethods setUpPopUpViewOnViewController:self];
    
    NSMutableAttributedString *tAndCTitleFirstString = [[NSMutableAttributedString alloc] initWithString:@"I agree to the "];
    [tAndCTitleFirstString addAttribute:NSForegroundColorAttributeName value:[UIColor appBrightTextColor] range:NSMakeRange(0, [tAndCTitleFirstString length])];
    
    NSMutableAttributedString *termsAndConditionTitle = [[NSMutableAttributedString alloc] initWithString:@"Terms of Services & Privacy Policy."];
    
    [termsAndConditionTitle addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [termsAndConditionTitle length])];
    [termsAndConditionTitle addAttribute:NSForegroundColorAttributeName value:[UIColor appPinkColor] range:NSMakeRange(0, [termsAndConditionTitle length])];
    
    [tAndCTitleFirstString appendAttributedString:termsAndConditionTitle];
    
    [_termsAndConditionsTitleButton setAttributedTitle:tAndCTitleFirstString forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _conViewHeightContraint.constant = 630;
    [self.scrollContentView setNeedsDisplay];
}

- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self updateUI];
}

- (void) updateUI{
    
    [registerButton.layer setBorderWidth:1.0f];
    [registerButton.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [registerButton.layer setCornerRadius:5.0f];
    [registerButton.layer setMasksToBounds:YES];
    
    self.paswordTxtFld.delegate = self;
}

#pragma mark - TEXTFIELD  DELEGATE  METHODS

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
   return [smSignUpModel textFieldShouldBeginEditing:textField];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    
  return   [smSignUpModel textFieldShouldReturn:textField];
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   return  [smSignUpModel textField:textField shouldChangeCharactersInRange:range replacementString:string];
}


#pragma mark - MODEL CLASS  DELEGATE  METHODS

- (void) successResponseCall:(NSString *)response{
    if([response isEqualToString:@"User successfully created, please verify your email"]){
        UIViewController* smRegisteredVC = [self.storyboard instantiateViewControllerWithIdentifier:SM_REGISTERED_VC];
        [self.navigationController pushViewController:smRegisteredVC animated:YES];
    }
    else{
        [[[RBACustomAlert  alloc] initWithTitle:APP_TITLE message:response delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
//    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (void) showErrorMessages:(NSString *)error{
    [[[RBACustomAlert  alloc] initWithTitle:APP_TITLE message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

#pragma mark - BUTTON ACTIONS

- (IBAction)BackButtonAction:(id)sender {
    [self.navigationController  popViewControllerAnimated:YES];
}

- (IBAction)registerButtonAction:(id)sender {
    [smSignUpModel  sendSignUpRequestWithUserName:userNameTxtFld.text
                                         password:paswordTxtFld.text
                              reEnterPasswordText:reEnterPasswordTxtFld.text
                                            email:[SMValidation removeUnwantedSpaceForString:[emailIdTxtFld.text  lowercaseString]]
                                          zipCode:zipCodeTxtFld.text
                                    positionArray:arraySelectedPositions
                                    acceptedTandC:termsAndConditionsAccepted];
}

#pragma mark - SEARCH POPUP  METHODS & DELEGATE METHODS

- (void) setUpPopUPViewWithSender:(id) sender{
    //Display the position selection popup
    [smSignUpModel  setUpPopUPViewWithSender:searchPositionTxtFld
                            selectedPosItems:arraySelectedPositions
                                     withdel:self];
}

- (void) selectedMultipleValueData:(NSMutableArray *)selectedData withkeyId:(NSString *)keyId andKey:(NSString*)key andDataType:(PopupType) dataType {
    // Store the selected data
    arraySelectedPositions = selectedData;
}

- (void)popTipViewWasDismissedByUser:(RBAPopup *)popTipView{
    
}

#pragma mark - USER INTERACTIONS

- (IBAction)verifyButtonAction:(id)sender {
    UIButton * button  =  termsAndConditionsButton;
    [button setSelected:![button isSelected]];
    
    [self updateVerifyButtonBasedSelectionStatus:[sender isSelected]];
}

- (IBAction)termsAndConditionsTitleButtonAction:(id)sender {
//    +  (UIView *) ShowPopUpWithTitleTitle:(NSString *) title descriptionContent:(NSString *)  description
    [self.view endEditing:YES];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"Terms of Conditions_Privacy Policy_Swiss Monkey"
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    RBACustomAlert *alert = [[RBACustomAlert alloc] initWithTitle:@"Terms of Services & Privacy Policy." message:content delegate:self cancelButtonTitle:@"AGREE" otherButtonTitles:nil,nil];
    [alert setTag:TERMS_AND_CONDITIONS_ALERT_TAG];
    [alert show];

}

- (void) updateVerifyButtonBasedSelectionStatus:(BOOL) senderStatus{
    
    if([termsAndConditionsButton isSelected]){
        [termsAndConditionsButton setImage:[UIImage imageNamed:@"Verify_selected"] forState:UIControlStateNormal];
    }
    else{
        [termsAndConditionsButton setImage:[UIImage imageNamed:@"Verify"] forState:UIControlStateNormal];
    }
    termsAndConditionsAccepted = senderStatus;
//    [[[ReusedMethods sharedObject] userProfileInfo] setObject:[NSNumber numberWithBool:[termsAndConditionsButton isSelected]] forKey:LICENSE_VERIFICATION];
    
}

- (void) alertView:(RBACustomAlert *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == TERMS_AND_CONDITIONS_ALERT_TAG){
        [termsAndConditionsButton setSelected:YES];
        [self updateVerifyButtonBasedSelectionStatus:YES];
    }
}

@end
