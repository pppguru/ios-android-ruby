//
//  SMAddProfileThirdVCModel.h
//  SwissMonkey
//
//  Created by Prasad on 2/22/16.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol smAddProfileThirdVCModelDelegate <NSObject>

- (void) selectedExpiryDate:(NSDate *) expiryDate withDateString:(NSString *) dateString monthString:(NSString *) month andYearString:(NSString *) yearString;
@end
@interface SMAddProfileThirdVCModel : NSObject
@property  (nonatomic, retain)  id<smAddProfileThirdVCModelDelegate> delegate;
@property  (nonatomic, strong)  UIView *  toolsView;
@property (nonatomic, readwrite) BOOL isPopOverPresent;
@property (nonatomic, readwrite) BOOL isSubCategoryTF;

#pragma mark - Dropdown list actions
- (void)clickedProfileJobType:(UITextField*)textField;
- (void)clickedProfileWorkAvailability:(UITextField*)textField;
- (void)clickedProfileWorkAvailiabilityAfterDateAvailability:(UITextField*)textField;

- (void)clickedProfileOpportunityDistance:(UITextView*) textView;
- (void)clickedProfilePerformanceManagement:(UITextView*) textView;
- (void)clickedProfileAdditionalSkills:(UITextView*) textView;
- (void)clickedProfileSpecializedAssisting:(UITextView*) textView;

#pragma mark - TEXTFIELD DELEGTE METHODS

- (BOOL) textFieldShouldReturn:(UITextField *)textField;
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField;
- (void) textFieldDidEndEditing:(UITextField *)textField;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
- (void)textViewDidChange:(UITextView *)textView;
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

- (NSString *) getKeyForDropDownListOfTextFieldTag:(NSInteger) tag;

- (void) setupDatePicker;
- (void) changeWorkDayPreferencesButtonStateOfButton:(UIButton * ) button;
@property (nonatomic, strong) NSMutableArray *profileShiftsArray;

@end
