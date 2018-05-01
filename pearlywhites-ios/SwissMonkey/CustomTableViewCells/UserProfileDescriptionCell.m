//
//  UserProfileDescriptionCell.m
//  SwissMonkey
//
//  Created by Kasturi on 1/22/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "UserProfileDescriptionCell.h"

@implementation UserProfileDescriptionCell{
    UILabel *seperaterLabel ;
}
@synthesize titleLabel, subTitleLable;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frameWidth:(float)width{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier frameWidth:width];
    if (self)
    {
        float  xPos  = 3;
        float  yPos  =  10;
        
        float  lblWidth  = width  -  (2 * xPos) ;
        float  lblHeight  =  50;
        
        
        
        //videos  title  displayed on textLabel
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, lblWidth, lblHeight)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setNumberOfLines:0];
        [titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setTextColor:[UIColor appCustomPurpleColor]];
        [titleLabel setFont:[UIFont appLatoBlackFont20]];
        [self.contentView  addSubview:titleLabel];
        
        
        yPos = CGRectGetMaxY(titleLabel.frame);
        
        //videos  title  displayed on textLabel
        subTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, lblWidth,lblHeight)];
        [subTitleLable setBackgroundColor:[UIColor clearColor]];
        [subTitleLable setNumberOfLines:0];
        [subTitleLable setLineBreakMode:NSLineBreakByWordWrapping];
        [subTitleLable setTextAlignment:NSTextAlignmentCenter];
        [subTitleLable setTextColor:[UIColor darkGrayColor]];
        [subTitleLable setFont:[UIFont appLatoLightFont15]];
        [self.contentView  addSubview:subTitleLable];
        
        yPos  =  CGRectGetMaxY(subTitleLable.frame);
        
        
        seperaterLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, lblWidth, 1 )];
        seperaterLabel.backgroundColor = [UIColor appLightGrayColor];
        [self.contentView addSubview:seperaterLabel];

        
    }
    
    
    return  self;
}

- (void) setUpCellData:(NSDictionary *) responseDict onindexpath:(NSIndexPath *)indexpath{
    
    if (indexpath.row  ==  0) {
        
        // work related info
        NSString * experienceString  =  [NSString stringWithFormat:@"%@",[ReusedMethods replaceEmptyString:[ReusedMethods getcorrespondingStringWithId:[responseDict   objectForKey:EXPERIENCE] andKey:EXPERIENCE] emptyString:EMPTY_STRING]];
        
        
        //    NSString  *  boardCertifiedString  = [ReusedMethods replaceEmptyString:[[responseDict objectForKey:BOARD_CERTIFIED] boolValue] == 1 ? @"YES" : @"NO" emptyString:EMPTY_STRING];
        
        
        NSString * boardCertifiedString = [NSString stringWithFormat:@"%@",[ReusedMethods replaceEmptyString:[ReusedMethods getcorrespondingStringFromLocalOptionsDictioriesWithId:[responseDict objectForKey:BOARD_CERTIFIED] andKey:BOARD_CERTIFIED] emptyString:EMPTY_STRING]].uppercaseString;
        
        NSString *  licenceNumberString  =  [ReusedMethods replaceEmptyString:[responseDict objectForKey:LICENSE_NUMBER] emptyString:EMPTY_STRING].uppercaseString;
        
        NSString *  licenceExpiryDate  =  [ReusedMethods changeDisplayFormatOfDateString:[responseDict  objectForKey:LICENSE_EXPIRES]inTheFormate:SERVER_SAVING_DATE_FORMATE WithEmptyString:EMPTY_STRING];
        licenceExpiryDate = [ReusedMethods getValidString:licenceExpiryDate];
        // asaign values  to  contents
        titleLabel.text  = @"Experience";
        NSDictionary *profileInfo = [ReusedMethods userProfile];
        
        NSString *practiceManagement = ![ReusedMethods isObjectClassNameString:[profileInfo objectForKey:PRACTICE_MANAGEMENT]] ? [ReusedMethods getCombainedStringFromServerResponseArrayHavingServerkey:PRACTICE_MANAGEMENT]:[profileInfo objectForKey:PRACTICE_MANAGEMENT];
        practiceManagement = [ReusedMethods getValidString:practiceManagement];
        NSLog(@"%@", practiceManagement);
        
        NSString * otherPracticeManagementSoftware  =  [ReusedMethods replaceEmptyString:[responseDict objectForKey:OTHER_PRACTICE_DESCRIPTION_SOFTWARE] emptyString:EMPTY_STRING];
        
        NSString * licenceApplicableStates = [ReusedMethods getCombainedStringFromServerResponseArrayHavingServerkey:LICENSE_VERIFICATION_STATES];
        licenceApplicableStates  =  [ReusedMethods replaceEmptyString:licenceApplicableStates emptyString:EMPTY_STRING];
        
        NSString *labelText = [NSString stringWithFormat:@"Experience: \n%@\nBoard Certified: \n%@ \nLicense Number: \n%@ \nExpiration Date: \n%@\nStates: \n%@\nPractice Software Experience: \n%@\nOther Practice Software Experience: \n%@",[ReusedMethods getValidString:experienceString], boardCertifiedString,licenceNumberString,licenceExpiryDate,[licenceApplicableStates uppercaseString], practiceManagement,otherPracticeManagementSoftware];
                
        subTitleLable.attributedText = [ReusedMethods getAttributeString:labelText withAlignment:NSTextAlignmentCenter];
    }else{
        
       // NSString *  workAvailabilityDate  =  [ReusedMethods changeDisplayFormatOfDateString:[responseDict  objectForKey:WORK_AVAILABILITY_AFTER_DATE] withEmptyString:SPACE];
        
         NSString *  workAvailabilityDate  =  [ReusedMethods changeDisplayFormatOfDateString:[responseDict  objectForKey:WORK_AVAILABILITY_AFTER_DATE] inTheFormate:SERVER_DATE_FORMATE WithEmptyString:SPACE];
        
        NSString * workAvailabilityString  = [ReusedMethods replaceEmptyString:[ReusedMethods getcorrespondingStringWithId:[responseDict objectForKey:WORK_AVAILABILITY] andKey:WORK_AVAILABILITY]emptyString:EMPTY_STRING];
        NSString * opportunitiesRangeString  =  [ReusedMethods replaceEmptyString:[ReusedMethods getcorrespondingStringWithId:[responseDict objectForKey:LOCATION_RANGE] andKey:LOCATION_RANGE] emptyString:EMPTY_STRING];
       // NSString * virtualInterviewAvailability  =  [ReusedMethods replaceEmptyString:[[responseDict  objectForKey:VIRTUAL_INTERVIEW] boolValue] == 1 ? @"YES" : @"NO" emptyString:EMPTY_STRING];
        
//        NSString * virtualInterviewAvailability = [NSString stringWithFormat:@"%@",[ReusedMethods replaceEmptyString:[ReusedMethods getcorrespondingStringFromLocalOptionsDictioriesWithId:[responseDict objectForKey:VIRTUAL_INTERVIEW] andKey:VIRTUAL_INTERVIEW] emptyString:EMPTY_STRING]];
        
        NSString * additionalSkills = [ReusedMethods getCombainedStringFromServerResponseArrayHavingServerkey:SKILLS];
        additionalSkills  =  [ReusedMethods replaceEmptyString:additionalSkills emptyString:EMPTY_STRING];
        
        //Separating the sub categories strings...
        NSArray *stringsArr = [additionalSkills componentsSeparatedByString:@","];
        NSMutableString *subCatStrings = [[NSMutableString alloc] init];
        NSMutableString *skillsStrings = [[NSMutableString alloc] init];
        for (NSString *str in stringsArr) {
            if ([str containsString:@"Sub-"]) {
                [subCatStrings appendString:[NSString stringWithFormat:@" %@,",[str stringByReplacingOccurrencesOfString:@"Sub-" withString:@""]]];
            }
        }
        
        NSString *trimmedSubString = @"";
        
        if (subCatStrings.length > 0) {
            
            subCatStrings = (NSMutableString *)[subCatStrings substringToIndex:[subCatStrings length]-1];
            
            trimmedSubString = [subCatStrings stringByTrimmingCharactersInSet:
                                          [NSCharacterSet whitespaceCharacterSet]];
            
            trimmedSubString = [ReusedMethods replaceEmptyString:trimmedSubString emptyString:SPACE];
        }
        
        for (NSString *str in stringsArr) {
            if (![str containsString:@"Sub-"]) {
                if ([str containsString:@"Par-"]) {
                    [skillsStrings appendString:[NSString stringWithFormat:@" %@ (%@),",[str stringByReplacingOccurrencesOfString:@"Par-" withString:@""],trimmedSubString]];
                }else{
                    [skillsStrings appendString:[NSString stringWithFormat:@" %@,",str]];
                }
            }
        }
        
        skillsStrings = (NSMutableString *)[skillsStrings substringToIndex:[skillsStrings length]-1];
        
        additionalSkills = [skillsStrings stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceCharacterSet]];
        
        //Removing the morethan one spaces on string..
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"  +" options:NSRegularExpressionCaseInsensitive error:&error];
        
        additionalSkills = [regex stringByReplacingMatchesInString:additionalSkills options:0 range:NSMakeRange(0, [additionalSkills length]) withTemplate:@" "];
        
        NSString * languages  =  [ReusedMethods replaceEmptyString:[responseDict objectForKey:BILINGUAL_LANGUAGES] emptyString:EMPTY_STRING];
        
        NSDictionary *userprofile = [ReusedMethods userProfile];
        
        NSString *compensation = [userprofile objectForKey:@"compensationID"];
        NSArray *compRanges = [[ReusedMethods sharedObject].dropDownListDict objectForKey:@"comprange"];
        
        NSString *predicateString = [NSString stringWithFormat:@"compensation_id = %@", compensation];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
        NSArray *array = [compRanges filteredArrayUsingPredicate:predicate];
        NSString *compensationString = @"-";
        if(array.count){
            NSDictionary *dictCompan = [array firstObject];
            compensationString = [dictCompan objectForKey:@"compensation_name"];
            compensationString = [ReusedMethods getValidString:compensationString];
        }
        
        NSString *fromSal = [userprofile objectForKey:@"from_salary_range"];
        fromSal = [ReusedMethods getValidString:fromSal];
        
        NSString *toSal = [userprofile objectForKey:@"to_salary_range"];
        toSal = [ReusedMethods getValidString:toSal];
        
        NSString *comments = [userprofile objectForKey:@"comments"];
        comments = [ReusedMethods getValidString:comments];
        
//comprange
        // asaign values  to  contents
        titleLabel.text  = @"Requirements";
        NSString *labelText = [NSString stringWithFormat:@"Work Availability: \n%@ %@\nLooking for opportunities within: \n%@\nAdditional Skills: \n%@\nLanguages: \n%@\nCompensation: \n%@\nExpected Salary Range: \n$%@ - $%@\nOthers: \n%@",workAvailabilityString,workAvailabilityDate,opportunitiesRangeString,additionalSkills,languages, compensationString, fromSal, toSal, comments];
        
        
        subTitleLable.attributedText = [ReusedMethods getAttributeString:labelText withAlignment:NSTextAlignmentCenter];
    }
    
}


-(void)adjustCellFrames
{
    //Set the Frames size according to the Text
    [titleLabel resizeToFit];
    [subTitleLable resizeToFit];
    
    CGRect subTitleLabelFrame = subTitleLable.frame;
    subTitleLabelFrame.origin.y  =   CGRectGetMaxY(titleLabel.frame) + 30;
    subTitleLable.frame = subTitleLabelFrame;
    
    CGRect seperatorLabelFrame = seperaterLabel.frame;
    seperatorLabelFrame.origin.y  =   CGRectGetMaxY(subTitleLable.frame) + 30;
    seperaterLabel.frame = seperatorLabelFrame;
}

-(CGFloat)getCellHeight:(NSDictionary *)responseDict onIndexPath:(NSIndexPath *) indexPath {
    
    [self  setUpCellData:responseDict onindexpath:indexPath];
    [self adjustCellFrames];
    return CGRectGetMaxY(self.subTitleLable.frame) + 30;
}



@end
