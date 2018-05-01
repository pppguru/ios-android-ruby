//
//  SMSettingsModel.m
//  SwissMonkey
//
//  Created by Kasturi on 24/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import "SMSettingsModel.h"

@implementation SMSettingsModel


// deactivate

- (void)makeApiCallFoDeactivate {
    NSString *method = METHOD_ACTIVATE;
    if(_active)
        method = METHOD_DEACTIVATE;
    
    APIObject * reqObject = [[APIObject alloc] initWithMethodName:method ModuleName:MODULE_USER MethodType:METHOD_TYPE_POST Parameters:nil SuccessCallBack:@selector(deactivateApiSuccess:) AndFailureCallBack:@selector(deactivateApiFailed:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
    [service makeWebServiceCall];
}

- (void) deactivateApiSuccess:(WebServiceCalls *) service{
    
    NSDictionary * data = [service responseData];
    NSString *alertMessage = [data objectForKey:@"success"];
    id del = nil;
    
    if([alertMessage containsString:@"deactivated"]){
        alertMessage = @"You have deactivated your account and will be logged out from the application.";
        del = self;
    }
    
    RBACustomAlert  * alert  =  [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:alertMessage delegate:del cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    _active = !_active;
    
    [_delegate updateStatus];
    
}

- (void) alertView:(RBACustomAlert *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [ReusedMethods logout];
}

- (void) deactivateApiFailed:(WebServiceCalls *)serverError{
    
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
// reset password.

- (void)makeApiCallForResetpassword:(NSString *) oldPassword newPassword:(NSString *) newPassword {
    
    NSMutableDictionary * dict  =  [[NSMutableDictionary alloc] init];
    [dict setObject:oldPassword forKey:@"oldpassword"];
    [dict setObject:newPassword forKey:@"newpassword"];
    
    
    APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_RESET ModuleName:MODULE_USER MethodType:METHOD_TYPE_POST Parameters:dict SuccessCallBack:@selector(resetPasswordApiSuccess:) AndFailureCallBack:@selector(resetpasswordApiFailed:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
    [service makeWebServiceCall];
}

- (void) resetPasswordApiSuccess:(WebServiceCalls *) service{
    
    NSDictionary * dropDownData = [service responseData];
    RBACustomAlert  * alert  =  [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:[dropDownData objectForKey:@"success"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void) resetpasswordApiFailed:(WebServiceCalls *)serverError{
    
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

// get profile data

-(void) callProfileDataAPICall
{
    APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_INFO ModuleName:MODULE_PROFILE MethodType:METHOD_TYPE_POST Parameters:nil SuccessCallBack:@selector(successAPICall:) AndFailureCallBack:@selector(failedAPICall:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
    [service makeWebServiceCall];
}



#pragma mark - Login Success Call Back Method

-(void) successAPICall:(WebServiceCalls *)service
{
    //    NSLog(@"authtoken : %@", [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_AUTHTKEN]);
    [_delegate successResponseCall:service.responseData];
}

-(void) failedAPICall:(NSError *)error
{
    @try {
        if([error isKindOfClass:[NSError class]])
            [_delegate showErrorMessages:[error.userInfo objectForKey:@"NSLocalizedDescriptionKey"]];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}






@end
