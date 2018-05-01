//
//  SMSignUpVC.h
//  SwissMonkey
//
//  Created by Kasturi on 23/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSignUpModel.h"

@interface SMSignUpVC : UIViewController<smSignUPModelDelegate,UITextFieldDelegate,RBAPopupDelegate>

@property  (nonatomic, retain)  SMSignUpModel *  smSignUpModel;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UIButton *termsAndConditionsButton;
@property (weak, nonatomic) IBOutlet UIButton *termsAndConditionsTitleButton;


@property (weak, nonatomic) IBOutlet UITextField *userNameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *emailIdTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *paswordTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *reEnterPasswordTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *searchPositionTxtFld;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conViewHeightContraint;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

- (IBAction)BackButtonAction:(id)sender ;
- (IBAction)verifyButtonAction:(id)sender;
- (IBAction)termsAndConditionsTitleButtonAction:(id)sender;
@end
