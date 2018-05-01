//
//  SMValidation.m
//  SwissMonkey
//
//  Created by Kasturi on 23/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import "SMValidation.h"

@implementation SMValidation


+ (BOOL) validateEmail: (NSString *) email
{
   // NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

+ (BOOL) validateZipCode: (NSString*) zipCode {
    NSString *zipCodeRegex = @"\\d{5}(-?(\\d{4}))?";
    NSPredicate *zipCodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", zipCodeRegex];
    
    return [zipCodeTest evaluateWithObject:zipCode];
}

+ (BOOL) emptyNumberValidation:(NSNumber *) fieldNumber {
    return fieldNumber != nil ? ([fieldNumber isKindOfClass:[NSNumber class]] ? YES : NO) : NO;
}

+ (BOOL) emptyTextValidation:(NSString *) fieldText{
    
    return fieldText.length  != 0 ? YES: NO;
}

+ (BOOL) validatePassword:(NSString *) password withReEnteredPassword:(NSString *) conformPassword{
    
    if([password length]>0 && [conformPassword length]>0){
        if([password isEqualToString:conformPassword]){
            return YES;
        }else{
            return FALSE;
        }
    }else{
        return FALSE;
    }
}

+ (BOOL) minimumCharsValidation:(NSString *) fieldText{
    
    return fieldText.length  >= 8 ? YES: NO;
}

+(BOOL)validatePhoneNumberlWithString:(NSString*)checkString
{
    NSString *phoneNumber = checkString;
    NSString *phoneRegex =@"[0-9]{10,15}";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL matches = [test evaluateWithObject:phoneNumber];
    return matches;
}

+ (NSString *)formatePhoneNumberTxtFieldString:(NSString *)textString{
    
    // converting  (xxx) xxx-xxxx to xxxxxxxxx
    return   [[textString componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
    
}

+ (BOOL) isPhoneNumberIsInUSFormat:(NSString *) phString{
    NSString * bracket  = @"(";
    return  [phString rangeOfString:bracket].location != NSNotFound;
}

+ (NSString *) changeDisplayFormateOfPhonenumber:(NSString *) phnumberString{
    
    if(phnumberString.length  == 0)
        return EMPTY_STRING;
    
    //  check whether the current string is in formate (###) ###-####
    if(![SMValidation isPhoneNumberIsInUSFormat:phnumberString]){
        //  if phone number  is not  in  US formate  make  this  to US  formate.
        NSMutableString *stringts = [NSMutableString stringWithString:phnumberString];
        [stringts insertString:@"(" atIndex:0];
        [stringts insertString:@")" atIndex:4];
        [stringts insertString:@" " atIndex:5];
        [stringts insertString:@"-" atIndex:9];
        return  stringts;
    }
    
    return phnumberString;
}


+(BOOL)isValidZipCode:(NSString*)pincode    {
    NSString *pinRegex = @"^[0-9]{5,9}$";
    NSPredicate *pinTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pinRegex];
    
    BOOL pinValidates = [pinTest evaluateWithObject:pincode];
    return pinValidates;
}

+ (NSString *) removeUnwantedSpaceForString:(NSString *) requiredString{
    NSString *rawString = requiredString;
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    trimmed  =  [trimmed stringByReplacingOccurrencesOfString:@" +" withString:@" "
                                                        options:NSRegularExpressionSearch
                                                          range:NSMakeRange(0, trimmed.length)];
    return  trimmed;

}

+ (BOOL) isNumericString:(NSString *)inputString{
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([inputString rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        // newString consists only of the digits 0 through 9
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL) isCharectersString:(NSString *) inputString{
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789 "] invertedSet];
    
    if ([inputString rangeOfCharacterFromSet:set].location != NSNotFound) {
        NSLog(@"This string contains illegal characters");
        return NO;
    }else{
        return YES;
    }
}

+ (BOOL) stringContainsOnlyCharacters:(NSString *) inputString{
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ"] invertedSet];
    
    if ([inputString rangeOfCharacterFromSet:set].location != NSNotFound) {
        NSLog(@"This string contains illegal characters");
        return NO;
    }else{
        return YES;
    }
}


+ (BOOL) isWorkAvailabilityDateIDSelected:(id)workAvailabilityID{
    NSArray *  softwareProficiencyObjectsArray =  [[[ReusedMethods  sharedObject] dropDownListDict] objectForKey:@"work_availability"];
    
    NSString *str = @"Available after";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(work_availabilty_name BEGINSWITH[c] %@)", str];
    id resultID = [[[softwareProficiencyObjectsArray filteredArrayUsingPredicate:pred] firstObject] objectForKey:@"work_id"];
    
    if(workAvailabilityID  ==  resultID){
        return YES;
    }
    else{
        return NO;
    }
}

// to check whether compensation amount contains "not specified" r not.
+ (BOOL) isNumbersExistedInString:(NSString *) inputString{
    NSRange match = [inputString rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet] options:0 range:NSMakeRange(0, inputString.length)];
    if (match.location != NSNotFound) {
        // someString has a letter in it
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL) isNewmailId:(NSString *) newMailId differWithOldMailId:(NSString *) oldMailId{
    
    if(newMailId != nil){
        if([oldMailId isEqualToString:newMailId]){
            return NO;
        }else{
            return YES;
        }
    }else{
        return YES;
    }
    
}

+ (BOOL) validateNewMailId:(NSString *) newMailId{
    if(newMailId != nil){
        if([SMValidation emptyTextValidation:newMailId]){
            if(![SMValidation validateEmail:[SMValidation removeUnwantedSpaceForString: newMailId]])
                return NO;
            else
                return YES;
        }
        else{
            return NO;
        }
    }else{
        return YES;
    }
    
}

+ (BOOL)isValidYouTubeUrl:(NSString *)youtubeVideoURL
{
    NSString *  youTubeURl =  @"https://www.youtube.com/watch?v=";
    NSString *  youtubeUrl2 =  @"http://www.youtube.com/watch?v=";
    
    if( [[youtubeVideoURL lowercaseString] hasPrefix:[youTubeURl lowercaseString]] || [[youtubeVideoURL lowercaseString] hasPrefix:[youtubeUrl2 lowercaseString]]){
        return YES;
    }else
        return NO;
}

+ (BOOL) isSubCategorySkillsSelectedAndValidated:(NSArray *) selectedSkillsArray{
    
    NSArray *  softwareProficiencyObjectsArray =  [[[ReusedMethods  sharedObject] dropDownListDict] objectForKey:@"software_proficiency"];
    
    NSMutableArray *subCategoryDictArr = [[NSMutableArray alloc] init];
    NSMutableArray *subCategoryIDsArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in softwareProficiencyObjectsArray) {
        if ([[dict valueForKey:@"parent_id"] isKindOfClass:[NSNumber class]]) {
            [subCategoryDictArr addObject:dict];
            [subCategoryIDsArr addObject:[dict valueForKey:@"software_type_id"]];
        }
    }
    
    if ([subCategoryIDsArr count] > 0){
        if ([[selectedSkillsArray firstObject] isKindOfClass:[NSNumber class]]) {
            if([selectedSkillsArray containsObject:[[subCategoryDictArr firstObject] valueForKey:@"parent_id"]]) {
                for (NSNumber *number in subCategoryIDsArr) {
                    if ([selectedSkillsArray containsObject:number]) {
                        return YES;
                    }
                }
            }else{
                return YES;
            }
        }else{
            if([selectedSkillsArray containsObject:[NSString stringWithFormat:@"%@",[[subCategoryDictArr firstObject] valueForKey:@"parent_id"]]]) {
                for (NSNumber *number in subCategoryIDsArr) {
                    if ([selectedSkillsArray containsObject:[NSString stringWithFormat:@"%@",number]]) {
                        return YES;
                    }
                }
            }else{
                return YES;
            }
        }
    }
    return NO;
}

@end
