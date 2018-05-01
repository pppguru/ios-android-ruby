//
//  SMValidation.h
//  SwissMonkey
//
//  Created by Kasturi on 23/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMValidation : NSObject

+ (BOOL) validateEmail: (NSString *) email;
+ (BOOL) validateZipCode: (NSString*) zipCode;
+ (BOOL) emptyNumberValidation:(NSNumber *) fieldNumber;
+ (BOOL) emptyTextValidation:(NSString *) fieldText;
+ (BOOL) validatePassword:(NSString *) password withReEnteredPassword:(NSString *) conformPassword;
+ (BOOL) minimumCharsValidation:(NSString *) fieldText;
+ (BOOL) validatePhoneNumberlWithString:(NSString*)checkString;
+ (BOOL) isValidZipCode:(NSString*)pincode;
+ (NSString *) removeUnwantedSpaceForString:(NSString *) requiredString;
+ (BOOL) isNumericString:(NSString *)inputString;
+ (BOOL) isCharectersString:(NSString *) inputString;
+ (BOOL) stringContainsOnlyCharacters:(NSString *) inputString;

+ (BOOL) isWorkAvailabilityDateIDSelected:(id)workAvailabilityID;
+ (BOOL) isNumbersExistedInString:(NSString *) inputString;
+ (BOOL) isNewmailId:(NSString *) newMailId differWithOldMailId:(NSString *) oldMailId;
+ (BOOL) validateNewMailId:(NSString *) newMailId;
+ (BOOL) isValidYouTubeUrl:(NSString *)youtubeVideoURL;
+ (NSString *)formatePhoneNumberTxtFieldString:(NSString *)textString;
+ (BOOL) isPhoneNumberIsInUSFormat:(NSString *) phString;
+ (NSString *) changeDisplayFormateOfPhonenumber:(NSString *) phnumberString;
+ (BOOL) isSubCategorySkillsSelectedAndValidated:(NSArray *) selectedSkillsArray;





@end
