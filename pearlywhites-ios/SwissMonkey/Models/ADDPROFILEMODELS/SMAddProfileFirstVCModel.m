//
//  SMAddProfileFirstVCModel.m
//  SwissMonkey
//
//  Created by Prasad on 2/22/16.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import "SMAddProfileFirstVCModel.h"

@implementation SMAddProfileFirstVCModel

#pragma mark - TEXTFIELD  DELEGATE  METHODS
//- (BOOL) textFieldShouldReturn:(UITextField *)textField{
//       return YES;
//}
- (void) textFieldDidEndEditing:(UITextField *)textField{
}
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
    if(textField.tag  ==   PROFILE_EMAIL_TEXTFIELD_TAG){
        [textField resignFirstResponder];
        return YES;
    }
    
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


@end
