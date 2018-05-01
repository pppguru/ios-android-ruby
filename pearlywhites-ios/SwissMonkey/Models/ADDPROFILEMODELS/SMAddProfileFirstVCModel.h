//
//  SMAddProfileFirstVCModel.h
//  SwissMonkey
//
//  Created by Prasad on 2/22/16.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol smAddProfileFirstVCModelDelegate <NSObject>
@end
@interface SMAddProfileFirstVCModel : NSObject
@property  (nonatomic, retain)  id<smAddProfileFirstVCModelDelegate> delegate;

#pragma mark - TEXTFIELD DELEGTE METHODS

- (BOOL) textFieldShouldReturn:(UITextField *)textField;
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField;
- (void) textFieldDidEndEditing:(UITextField *)textField;



@end
