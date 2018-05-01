//
//  SMLoginModel.m
//  SwissMonkey
//
//  Created by Kasturi on 23/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import "SMLoginModel.h"
#import "SMSignUpVC.h"

@implementation SMLoginModel

#pragma mark  - FIELD VALIDATIONS

- (void) sendRequestWith:(NSString *)username password:(NSString *)password{
    if ( (username.length == 0 ) || (password.length == 0)) {
     //   [_delegate showErrorMessage:@"Username or password should not be empty"];
         [_delegate showErrorMessage:MANDATORY_FIELDS_ALERT];
        
    }
    else if (![SMValidation validateEmail:[SMValidation removeUnwantedSpaceForString:username]]){
        [_delegate showErrorMessage:@"Please enter valid email"];
    }
    else{
       //  send  data  to server
//        [_delegate successRespone:@"Login successfully done"];
        [self makeLoginAPICall:[SMValidation removeUnwantedSpaceForString:username] PassWord:password];
    }
}

-(void)makeLoginAPICall:(NSString *)userName PassWord:(NSString *)password
{
    APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_LOGIN ModuleName:MODULE_USER MethodType:METHOD_TYPE_POST Parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:userName,@"username",password,@"password", nil] SuccessCallBack:@selector(loginAPISuccess:) AndFailureCallBack:@selector(loginAPIFailed:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
    [service makeWebServiceCall];
}

#pragma mark - Login Success Call Back Method

-(void)loginAPISuccess:(WebServiceCalls *)service
{
    NSDictionary * authenticationData = [service responseData];
    [ReusedMethods setAuthToken:[authenticationData objectForKey:USER_DEFAULTS_AUTHTKEN]];
    [ReusedMethods setUserStatus:[authenticationData objectForKey:USER_DEFAULTS_USERSTATUS]];
    [ReusedMethods makeApiCallForDeviceToken];
    
    if ([[authenticationData valueForKey:@"privacy_policy_status"] intValue] == 1) {
        [[ReusedMethods sharedObject] setTermsAndConditionsAccepted:YES];
    }
    
//    NSDictionary *dict = [[NSDictionary alloc] init];
//    [ReusedMethods setUserProfile:dict];
    
//    [[NSUserDefaults standardUserDefaults] setObject:[authenticationData objectForKey:USER_DEFAULTS_AUTHTKEN] forKey:USER_DEFAULTS_AUTHTKEN];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    NSLog(@"authtoken : %@", [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_AUTHTKEN]);
    
    if(![ReusedMethods isAccountInActive]){
       // [[[RBACustomAlert alloc] initWithTitle:@"Your account has been deactivated." message:@"Do you want to Activate your account?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil] show];
    }
    else{
        APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_INFO ModuleName:MODULE_PROFILE MethodType:METHOD_TYPE_POST Parameters:nil SuccessCallBack:@selector(userProfileAPISuccess:) AndFailureCallBack:@selector(userProfileAPIFailed:)];
        
        WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
        [service makeWebServiceCall];
        
    }
}

- (void) userProfileAPISuccess:(WebServiceCalls *) server{
    NSDictionary *userProfile = server.responseData;
    [ReusedMethods setUserProfile:userProfile];
    [[ReusedMethods sharedObject] setUserProfileInfo:[NSMutableDictionary dictionaryWithDictionary:userProfile]];
    [_delegate successRespone:@"Login successfully done"];
}


- (void) userProfileAPIFailed:(NSDictionary *) dictionary{
    
}


- (void) alertView:(RBACustomAlert *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == alertView.cancelButtonIndex){
        [self makeApiCallFoActivate];
//        [_delegate successRespone:@"Login successfully done"];
    }
}

- (void)makeApiCallFoActivate {
    NSString *method = METHOD_ACTIVATE;
    
    APIObject * reqObject = [[APIObject alloc] initWithMethodName:method ModuleName:MODULE_USER MethodType:METHOD_TYPE_POST Parameters:nil SuccessCallBack:@selector(activateApiSuccess:) AndFailureCallBack:@selector(activateApiFailed:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
    [service makeWebServiceCall];
}

- (void) activateApiSuccess:(WebServiceCalls *) service{
    
    NSDictionary * data = [service responseData];
    [ReusedMethods setUserStatus:@"Activated"];
    [_delegate successRespone:@"Login successfully done"];
    RBACustomAlert  * alert  =  [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:[data objectForKey:@"success"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void) activateApiFailed:(WebServiceCalls *)serverError{
    
    NSString * errmsg;
    if(serverError.responseError){
        errmsg =[[serverError responseError].userInfo objectForKey:@"NSLocalizedDescriptionKey"];
    }else{
        if ([[[serverError responseData] objectForKey:@"error"] length]) {
            errmsg = [[serverError responseData] objectForKey:@"error"];
            
        }
    }
    
    RBACustomAlert  * alert  =  [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:errmsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}

//-(void)loginAPIFailed:(NSError *)error
//{
//    
-(void)loginAPIFailed:(WebServiceCalls *)serverError
{
    //[_delegate showErrorMessage:[error.userInfo objectForKey:@"NSLocalizedDescriptionKey"]];
    
    if(serverError.responseError){
        [_delegate showErrorMessage:[[serverError responseError].userInfo objectForKey:@"NSLocalizedDescriptionKey"]];
    }else{
        if ([[[serverError responseData] objectForKey:@"error"] length]) {
            [_delegate  showErrorMessage:[[serverError responseData] objectForKey:@"error"]];

        }else{
            [_delegate  showErrorMessage:@"Invalid credentials"];
        }
        
       // [_delegate  showErrorMessage:[[serverError responseData] objectForKey:@"error"]];

    }
}

#pragma mark - Login Success Call Back Method

-(void)forgotPasswordAPISuccess:(WebServiceCalls *)service
{
    NSDictionary * resData = [service responseData];
    NSLog(@"resData : %@", resData);
    [_delegate showErrorMessage:[resData objectForKey:@"success"]];
}

-(void)forgotPasswordAPIFailed:(WebServiceCalls *)serverError
{
    if(serverError.responseError){
        [_delegate showErrorMessage:[[serverError responseError].userInfo objectForKey:@"NSLocalizedDescriptionKey"]];
    }else{
        
        [_delegate  showErrorMessage:[[serverError responseData] objectForKey:@"error"]];
    }

 //   [_delegate showErrorMessage:[error.userInfo objectForKey:@"NSLocalizedDescriptionKey"]];
}

- (void) sendForgotPasswordRequestWithEmail:(NSString *) email{
    
    email = [SMValidation removeUnwantedSpaceForString:email];
    
    if(![SMValidation emptyTextValidation:email]){
        [_delegate showErrorMessage:@"Email should not be empty"];
    }
    else if (![SMValidation validateEmail:email]){
        [_delegate showErrorMessage:@"Enter valid email"];
    }else{
        //  sent  email  to server to change  password
        APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_FORGOT ModuleName:MODULE_USER MethodType:METHOD_TYPE_POST Parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:email, @"username", nil] SuccessCallBack:@selector(forgotPasswordAPISuccess:) AndFailureCallBack:@selector(forgotPasswordAPIFailed:)];
        
        WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
        [service makeWebServiceCall];
//        [_delegate showErrorMessage:@"Sent password to your email"];
    }
}

#pragma mark - TEXTFIELD DELEGTE METHODS

//- (BOOL) textFieldShouldReturn:(UITextField *)textField{
//
//    [textField resignFirstResponder];
//    return YES;
//}
//


@end
