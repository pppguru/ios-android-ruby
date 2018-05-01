//
//  SMSettingsModel.h
//  SwissMonkey
//
//  Created by Kasturi on 24/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMSettingsModelDelegate <NSObject>

- (void) successResponseCall:(WebServiceCalls *) service;
- (void) showErrorMessages:(NSString *) error;
- (void) updateStatus;

@end

@interface SMSettingsModel : NSObject

@property  (nonatomic , retain)  id <SMSettingsModelDelegate> delegate;
@property  (nonatomic , readwrite)  BOOL active;

- (void)makeApiCallFoDeactivate;
- (void)makeApiCallForResetpassword:(NSString *) oldPassword newPassword:(NSString *) newPassword;
-(void) callProfileDataAPICall;


@end
