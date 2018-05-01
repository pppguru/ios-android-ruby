//
//  SMSignUpModel.h
//  SwissMonkey
//
//  Created by Kasturi on 24/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol smSignUPModelDelegate <NSObject>

- (void) showErrorMessages:(NSString *) error;
- (void) successResponseCall:(NSString *) response;
- (void) setUpPopUPViewWithSender:(id) sender;

@end

@interface SMSignUpModel : NSObject

@property  (nonatomic, retain)  id<smSignUPModelDelegate> delegate;


- (void) sendSignUpRequestWithUserName:(NSString *) userName
                              password:(NSString *) password
                   reEnterPasswordText:(NSString *) reEnterPasswordText
                                 email:(NSString *) emailId
                               zipCode:(NSString *) zipCode
                         positionArray:(NSArray *)  positionArray
                         acceptedTandC:(BOOL)       accepted;

- (void) setUpPopUPViewWithSender:(UITextField *) sender
                 selectedPosItems:(NSArray*)selectedPosItems
                          withdel:(id) delegate;

- (NSMutableArray *) getTotalSearchObjects;
- (void) callDropDownListMethods;

//#pragma mark  ----  TABLE VIEW DELEGATE METHODS --------
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
//-(NSString *) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - TEXTFIELD  DELEGATE  METHODS

- (BOOL) textFieldShouldReturn:(UITextField *)textField;
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField;
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
//- (BOOL)textFieldShouldClear:(UITextField *)textField;




@end
