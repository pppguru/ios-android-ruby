//
//  SMAddProfileSecondVCModel.h
//  SwissMonkey
//
//  Created by Prasad on 2/22/16.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol smAddProfileSecondVCModelDelegate <NSObject>

- (void) selectedExpiryDate:(NSDate *) expiryDate withDateString:(NSString *) dateString monthString:(NSString *) month andYearString:(NSString *) yearString;
- (void) setUpPopUPViewForPositions;

@end

@interface SMAddProfileSecondVCModel : NSObject
@property  (nonatomic, retain)  id<smAddProfileSecondVCModelDelegate> delegate;

#pragma mark - TEXTFIELD DELEGTE METHODS

- (BOOL) textFieldShouldReturn:(UITextField *)textField;
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField;
- (void) textFieldDidEndEditing:(UITextField *)textField;
- (void) textFieldDidBeginEditing:(UITextField *)textField;
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

- (void) setupDatePicker;
- (NSString *) getKeyForDropDownListOfTextFieldTag:(NSInteger) tag;

- (void) setUpPopUPViewWithSender:(UITextField *) textField
                 selectedPosItems:(NSArray*)selectedPosItems
                          withdel:(id) delegate;




@end
