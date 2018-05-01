//
//  SMLoginModel.h
//  SwissMonkey
//
//  Created by Kasturi on 23/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMLoginModelDelegate<NSObject>

- (void) showErrorMessage:(NSString *)error;
- (void) successRespone:(NSString *) message;

@end

@interface SMLoginModel : NSObject

@property (nonatomic, assign) id<SMLoginModelDelegate> delegate;

- (void) sendRequestWith:(NSString *)username password:(NSString *)password;
- (void) sendForgotPasswordRequestWithEmail:(NSString *) email;

#pragma mark - TEXTFIELD DELEGTE METHODS

//- (BOOL) textFieldShouldReturn:(UITextField *)textField;


@end
