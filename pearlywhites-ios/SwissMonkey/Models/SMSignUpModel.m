//
//  SMSignUpModel.m
//  SwissMonkey
//
//  Created by Kasturi on 24/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import "SMSignUpModel.h"
#import "SMSignUpVC.h"
#import "JobSearchOptionsCell.h"


@implementation SMSignUpModel{
    RBAPopup *  searchPopup;
    UITableView *  popUpTableView;
    NSMutableArray *  totalSearchPositionsArray, * tableViewArray;
    
}

- (void) sendSignUpRequestWithUserName:(NSString *) userName
                              password:(NSString *) password
                   reEnterPasswordText:(NSString *) reEnterPasswordText
                                 email:(NSString *) emailId
                               zipCode:(NSString *) zipCode
                         positionArray:(NSArray *)  positionArray
                         acceptedTandC:(BOOL)       accepted{
    
    userName  =  [SMValidation removeUnwantedSpaceForString:userName];
    emailId  = [SMValidation removeUnwantedSpaceForString:emailId];
    zipCode = [SMValidation removeUnwantedSpaceForString:zipCode];
    
    if(![SMValidation emptyTextValidation:userName]){
        //  [self.delegate  showErrorMessages:@"UserName  should  not  be empty"];
        [self.delegate  showErrorMessages:MANDATORY_FIELDS_ALERT];
    }else if(![SMValidation emptyTextValidation:password]){
        // [self.delegate  showErrorMessages:@"Password  should  not  be empty"];
        [self.delegate  showErrorMessages:MANDATORY_FIELDS_ALERT];
    }else if(![SMValidation emptyTextValidation:emailId]){
        //  [self.delegate  showErrorMessages:@"Email should  not  be empty"];
        [self.delegate  showErrorMessages:MANDATORY_FIELDS_ALERT];
    }else if(![SMValidation emptyTextValidation:zipCode]){
        [self.delegate  showErrorMessages:MANDATORY_FIELDS_ALERT];
    }else if(![SMValidation validateEmail:emailId]){
        [self.delegate  showErrorMessages:@"Enter valid email address"];
    }else if(![SMValidation validateZipCode:zipCode]){
        [self.delegate  showErrorMessages:@"Enter valid zip code"];
    }
    else if(![SMValidation minimumCharsValidation:password]){
        [self.delegate  showErrorMessages:@"Password must be atleast 8 characters"];
    }
    else if (![SMValidation validatePassword:password withReEnteredPassword:reEnterPasswordText]){
        [self.delegate showErrorMessages:@"Password doesn't match"];
    }else if(positionArray && positionArray.count <= 0){
        [self.delegate  showErrorMessages:@"Please choose position"];
    }else if(!accepted){
        [self.delegate  showErrorMessages:@"Please accept the terms and conditions to proceed"];
    }else{
        //  send  details  to  server
        [self  makeSignUpAPICall:userName
                        PassWord:password
                           email:emailId
                         zipCode:zipCode
                     andPosition:positionArray];
    }
}

- (NSInteger) getPositionIDWithPositionString:(NSString *) positionString{
    
    NSPredicate *  predicate  =  [NSPredicate  predicateWithFormat:@"(position_name == %@)", positionString];
    
    NSArray  *  filteredArray  = [[self getTotalSearchObjects]  filteredArrayUsingPredicate:predicate];
    return   [[[filteredArray firstObject] objectForKey:@"position_id"] integerValue];
    
                                  
}

-(void)makeSignUpAPICall:(NSString *) userName
                PassWord:(NSString *) password
                   email:(NSString *) emailString
                 zipCode:(NSString *) zipCode
             andPosition:(NSArray  *) positionArray
{
    NSArray *positionIDs = [positionArray valueForKey:@"position_id"];
    APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_SIGNUP
                                                       ModuleName:MODULE_USER
                                                       MethodType:METHOD_TYPE_POST
                                                       Parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                                                                    userName,@"name",
                                                                                                    emailString,@"username",
                                                                                                    zipCode,@"zip_code",
                                                                                                    password,@"password",
                                                                                                    positionIDs,@"position",
                                                                                                    nil]
                                                  SuccessCallBack:@selector(signUpAPISuccess:)
                                               AndFailureCallBack:@selector(signUpAPIFailed:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
    [service makeWebServiceCall];
}

#pragma mark Login Success Call Back Method
-(void)signUpAPISuccess:(WebServiceCalls *)service
{
    [_delegate successResponseCall:[[service responseData] objectForKey:@"success"]];
}
-(void)signUpAPIFailed:(WebServiceCalls *)serverError
{
    if(serverError.responseError){
        [_delegate showErrorMessages:[[serverError responseError].userInfo objectForKey:@"NSLocalizedDescriptionKey"]];
    }else{
        
        [_delegate  showErrorMessages:[[serverError responseData] objectForKey:@"error"]];
    }
}



/*

#pragma mark  ----  TABLE VIEW DELEGATE METHODS --------

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ReusedMethods setSeperatorProperlyForCell:cell];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return tableViewArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *  cellIdendifier  =  [NSString  stringWithFormat:@"Cell %@",@"JobSearchOptionsCell"];
    
    JobSearchOptionsCell  *cell =  [tableView dequeueReusableCellWithIdentifier:cellIdendifier];
    if(!cell){
        
        cell  =  [[JobSearchOptionsCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdendifier frameWidth:tableView.frame.size.width];
    }
    cell.optionLabel.text  =  [tableViewArray objectAtIndex:indexPath.row];
    return cell;
}

-(NSString *) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@" cell text  ----    %@  --- ",[NSString stringWithFormat:@"%ld",(long)indexPath.row]);
    [searchPopup dismissAnimated:YES];
    return [tableViewArray objectAtIndex:indexPath.row];
}
 */

#pragma  mark  ------   TEXTFIELD  DELEGATE  METHODS  -------

//- (BOOL) textFieldShouldReturn:(UITextField *)textField{
//    
//    if([textField tag]  ==  SIGNUP_SEARCH_POSITION_TAG){
//        return NO;
//    }else{
//        [textField resignFirstResponder];
//    }
//    return YES;
//}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    
    if([textField tag]  ==  SIGNUP_SEARCH_POSITION_TAG){
        if(![[[ReusedMethods sharedObject].dropDownListDict allKeys] count])
            [self callDropDownListMethods];
        
        [self.delegate setUpPopUPViewWithSender:textField];
        return NO;
    }else{
        return YES;
    }
   
}
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([textField tag] == SIGNUP_PASSWORD_TAG){
        if ([string rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].location != NSNotFound) {
            return NO;
        }
    }
    return YES;
}

//- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    
//    if([textField tag]  ==  SIGNUP_POPUP_SEARCH_TEXTFIELD_TAG){
//        
//        NSString * searchString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//        NSMutableArray *t1Arr=[[NSMutableArray alloc] init];
//        //Search the main list for whose name matches searchText; add items that match to the filtered array.
//        
//        for (int i=0;i<[totalSearchPositionsArray count];i++) {
//            NSString *currentPositonObject =[totalSearchPositionsArray objectAtIndex:i];
//            NSMutableArray *positionsList = [[currentPositonObject componentsSeparatedByString:@" "] mutableCopy]  ;
//            [positionsList addObject:currentPositonObject];
//            NSComparisonResult result;
//            for ( NSString *positionName in positionsList) {
//                
//                result = [positionName compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
//                if (result == NSOrderedSame) {
//                    [t1Arr addObject:currentPositonObject];
//                    break;
//                }
//            }
//        }
//        
//        [tableViewArray setArray:t1Arr];
//        [popUpTableView reloadData];
//    }
//    return YES;
//}
//
//- (BOOL)textFieldShouldClear:(UITextField *)textField
//{
//    tableViewArray  =  [[NSMutableArray alloc] initWithArray:totalSearchPositionsArray];
//    [popUpTableView reloadData];
//    return YES;
//}


- (NSMutableArray *) getTotalSearchObjects{
    
    return  [[ReusedMethods  sharedObject].dropDownListDict objectForKey:@"positions"]; //[[NSMutableArray alloc] initWithArray:@[@"0",@"0009090909093356735463765476357645675445567547568678",@"10",@"202",@"3",@"4"]];
}

- (void) setUpPopUPViewWithSender:(UITextField *) sender
                 selectedPosItems:(NSArray*)selectedPosItems
                          withdel:(id) delegate {
    
//    [ReusedMethods  setupPopUpViewForTextField:sender withDisplayArray:[self getTotalSearchObjects] withDel:delegate andKey:@"positions"];
    
    [ReusedMethods setupPopUpViewForTextField:sender withDisplayArray:[self getTotalSearchObjects] withDel:delegate displayKey:@"position_name" returnKey:@"position_id" withTag:kPosition isMultiSelect:YES selectedPosItems:selectedPosItems];
    //[self.visiblePopTipViews   addObject:onbjet];
   // self.currentPopTipViewTarget  =  sender;
}

# pragma mark - GET DROP DOWNLIST DATA


- (void) callDropDownListMethods{
    
    [self  makeApiCallForDropDownListForSignUpPositionField];
}

- (void)makeApiCallForDropDownListForSignUpPositionField{
    
    APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_DROPDOWNDATA ModuleName:MODULE_DROPDOWN MethodType:METHOD_TYPE_GET Parameters:nil SuccessCallBack:@selector(dropDownListApiSuccess:) AndFailureCallBack:@selector(dropDownListApiFailed:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
    [service makeWebServiceCall];
}

- (void) dropDownListApiSuccess:(WebServiceCalls *) service{
    
    NSDictionary * dropDownData = [service responseData];
    [[ReusedMethods sharedObject].dropDownListDict addEntriesFromDictionary:dropDownData];
    
    //Apply the new filtering
    [ReusedMethods applyTextFilteringForCompensationPreferences];
}

- (void) dropDownListApiFailed:(NSError *)error{
    
    RBACustomAlert  * alert  =  [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:[error.userInfo objectForKey:@"NSLocalizedDescriptionKey"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}


@end
