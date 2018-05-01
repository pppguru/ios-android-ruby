//
//  SMLoginVC.h
//  SwissMonkey
//
//  Created by Kasturi on 23/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMLoginModel.h"

@interface SMLoginVC : UIViewController<SMLoginModelDelegate,CustomAlertDelegate,UITextFieldDelegate>

@property (strong, nonatomic) SMLoginModel *loginModel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;
@property (weak, nonatomic) IBOutlet UIView *logInBGView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtFld;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *loginScrollView;

@property (weak, nonatomic) IBOutlet UIView *logInContentView;



- (IBAction)logInButtonAction:(id)sender;
- (IBAction)signUpButtonAction:(id)sender;
- (IBAction)forgotPasswordButtonAction:(id)sender;

@end
