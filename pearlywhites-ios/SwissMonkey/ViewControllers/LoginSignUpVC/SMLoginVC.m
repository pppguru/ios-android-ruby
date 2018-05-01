//
//  SMLoginVC.m
//  SwissMonkey
//
//  Created by Kasturi on 23/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import "SMLoginVC.h"
#import "SMSignUpVC.h"
#import "CircleLoaderView.h"

@implementation SMLoginVC

@synthesize loginModel, userNameTxtFld, passwordTxtFld,logInButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [Flurry logEvent:[NSString stringWithFormat:@"Class : %@, Method  %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]];
    
    loginModel = [[SMLoginModel alloc] init];
    loginModel.delegate = self;
//    [SMSharedFilesClass removeAllFilesFromLocal];
    
//    [CircleLoaderView addToWindowWithCircleColor:[UIColor appPinkColor] arcColor:[UIColor appWhiteColor]];
    
    //Customize the login button
    [ReusedMethods applyPurpleButtonStyle:self.logInButton];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    userNameTxtFld.text  =  @"";
    passwordTxtFld.text  = @"";
    
//    passwordTxtFld.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
}

#pragma mark  -  MODEL DELEGATE  METHODS

- (void) showErrorMessage:(NSString *)error{
//    userNameTxtFld.text  =  @"";
//    passwordTxtFld.text  = @"";
    RBACustomAlert  * alert  =  [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void) successRespone:(NSString *)message{
//    if([ReusedMethods isAccountInActive])
        [self moveToHomeView];
    [ReusedMethods checkForUserTermsAndConditionsAccepted];
}

#pragma mark - BUTTON ACTIONS

- (IBAction)logInButtonAction:(id)sender{
    [userNameTxtFld  resignFirstResponder];
    [passwordTxtFld resignFirstResponder];
    NSString *username = [userNameTxtFld.text lowercaseString];
    [ReusedMethods setUsername:username];
//    userNameTxtFld.text = @"yneeli+apple@rapidbizapps.com";
//    passwordTxtFld.text = @"123";
    [loginModel sendRequestWith:username password:passwordTxtFld.text];
}

- (IBAction)signUpButtonAction:(id)sender {
    SMSignUpVC* sMSignUpVC = [self.storyboard instantiateViewControllerWithIdentifier:SM_SIGNUP_VC];
    [self.navigationController pushViewController:sMSignUpVC animated:YES];
}

- (IBAction)forgotPasswordButtonAction:(id)sender {
    RBACustomAlert  *  showForgotPasswordPopUp  =  [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"Please enter email address" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    [showForgotPasswordPopUp  setStyle:CustomAlertViewStyleInput];
    [showForgotPasswordPopUp show];
}

#pragma mark - RBACUSTOM ALERT DELEGATE  METHODS

- (void) alertView:(RBACustomAlert *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    if(buttonIndex  ==  [alertView  cancelButtonIndex])
    {
        //[alertView inputTextField].text = @"yneeli@rapidbizapps.com";
        [loginModel  sendForgotPasswordRequestWithEmail:[[alertView inputTextField].text lowercaseString]];
    }
//    else   if(buttonIndex  !=  [alertView  cancelButtonIndex])
//    {
//         if([alertView inputTextField].text.length)
//        [loginModel  sendForgotPasswordRequestWithEmail:[[alertView inputTextField].text lowercaseString]];
//        else
//        {
//              RBACustomAlert  *  showForgotPasswordPopUp  =  [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"Please enter the email in the email field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//              [showForgotPasswordPopUp show];
//        }
//    }
}

#pragma mark  - NAVIGATION METHODS

- (void) moveToHomeView{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isUserExist"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [ReusedMethods checkAppFlow];
}

#pragma mark - KEYBOARD METHODS



@end
