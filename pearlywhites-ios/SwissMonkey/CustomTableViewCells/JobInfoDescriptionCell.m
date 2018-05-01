//
//  JobInfoDescriptionCell.m
//  SwissMonkey
//
//  Created by Kasturi on 1/28/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "JobInfoDescriptionCell.h"

@implementation JobInfoDescriptionCell
@synthesize jobInfoTitleLabel,jobInfoTitleDescriptionCell,applyButtonHeightConstraint;

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    jobInfoTitleLabel.preferredMaxLayoutWidth  =  CGRectGetWidth(jobInfoTitleLabel.frame);
    jobInfoTitleDescriptionCell.preferredMaxLayoutWidth  =  CGRectGetWidth(jobInfoTitleDescriptionCell.frame);
}

- (void)setupCellDataforIndex:(NSIndexPath *)  indexPath andJobDetails:(NSDictionary *)jobDetails{
    
    jobInfoTitleDescriptionCell.numberOfLines = 0;
    jobInfoTitleDescriptionCell.lineBreakMode = NSLineBreakByWordWrapping;
    NSString *skills = [jobDetails objectForKey:@"skills"];
    NSString * managementValue  =  [jobDetails objectForKey:@"practice_management_system"];
    NSString *  dollerString = [SMValidation isNumbersExistedInString:[jobDetails objectForKey:@"compensation_amount"]]? @"": @"$";
//    managementValue = @"safasf asf fad ads gag dsg sgdsg dsgsa gsdg dsg sdg sdgdsgdsg sdg sdgdsgds asfasfa";
//    NSLog(@"skills : %@", [skills class]);
//    jobInfoTitleDescriptionCell.backgroundColor = [UIColor grayColor];
//    NSLog(@"row : %ld", indexPath.row);
    switch (indexPath.row) {
        case kJobDescription:
        {
            [jobInfoTitleLabel setText:@"Job Description"];
            NSString *strDesc = [jobDetails objectForKey:@"job_description"];
            if(!strDesc.length)
                strDesc = @"-";
            [jobInfoTitleDescriptionCell setText:strDesc];
        }
            break;
        case kRequirements:{
            [jobInfoTitleLabel setText:@"Requirements"];
            skills = [skills stringByReplacingOccurrencesOfString:@", " withString:@","];
            skills = [skills stringByReplacingOccurrencesOfString:@"," withString:@", "];
            
            if([managementValue isKindOfClass:[NSString class]]){
                managementValue = [managementValue stringByReplacingOccurrencesOfString:@", " withString:@","];
                managementValue = [managementValue stringByReplacingOccurrencesOfString:@"," withString:@", "];
            }
            else
                managementValue = EMPTY_STRING;
           // [jobInfoTitleDescriptionCell setText:[NSString stringWithFormat:@"Experience: %@\nSoftware Proficiency : %@\nAddition Skills : -", [jobDetails objectForKey:@"year_of_experience"], [jobDetails objectForKey:@"software_proficiency"]]];
            [jobInfoTitleDescriptionCell setText:[NSString stringWithFormat:@"Experience:\n%@\n\nAdditional Skills:\n%@\n\nLanguages:\n%@\n\nPractice Management System:\n%@", [ReusedMethods getValidString:[jobDetails objectForKey:@"year_of_experience"]],[ReusedMethods replaceEmptyString:skills emptyString:EMPTY_STRING],[ReusedMethods  replaceEmptyString:[jobDetails objectForKey:JOB_PROFILE_LANGUAGES] emptyString:EMPTY_STRING], managementValue]];
        }
            
            break;
        case kCompensation:
        {
            [jobInfoTitleLabel setText:@"Compensation"];
            NSString *strCompensation = [NSString stringWithFormat:@"%@ %@%@", [jobDetails objectForKey:@"compensations"],dollerString,[jobDetails objectForKey:@"compensation_amount"]];
            strCompensation = [strCompensation stringByReplacingOccurrencesOfString:@".0" withString:@""];
            [jobInfoTitleDescriptionCell setText:strCompensation];
            [jobInfoTitleDescriptionCell setTextColor:[UIColor appCustomDarkGreenColor]];
            [jobInfoTitleDescriptionCell setFont:[UIFont appLatoLightFont18]];
            
//            [jobInfoTitleDescriptionCell setText:[NSString stringWithFormat:@"Compensation Type:\n%@\n\nAmount:\n%@%@", [jobDetails objectForKey:@"compensations"],dollerString,[jobDetails objectForKey:@"compensation_amount"]]];
        }
            
            break;
        case kTimings:
        {
            [jobInfoTitleLabel setText:@"Timing Preferences"];
            NSString *jobType = [jobDetails objectForKey:@"job_type"];
            NSString *strData = [NSString stringWithFormat:@"Job Type: %@", jobType];
            if(![jobType.uppercaseString isEqualToString:@"Full-time".uppercaseString]){
                NSArray *shifts = [jobDetails objectForKey:@"shifts"];
                NSArray *allShifts = [[ReusedMethods sharedObject].dropDownListDict objectForKey:@"shifts"];
                               
                for (NSDictionary *dictShift in shifts) {
                    
                    NSString *predicateString = [NSString stringWithFormat:@"shift_id = %@", [dictShift objectForKey:@"shiftID"]];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
                    NSArray *array = [allShifts filteredArrayUsingPredicate:predicate];
                    NSDictionary *dictSh = [array firstObject];
                    strData = [strData stringByAppendingFormat:@"\n\n%@: ", [[dictSh objectForKey:@"shift_timings"] uppercaseString]];
                    NSArray *days = [dictShift objectForKey:@"days"];
                    for (NSString *day in days) {
                        strData = [strData stringByAppendingString: [NSString stringWithFormat:@"%@ ," ,day]];
                    }
                    if ([strData length] > 0) {
                        strData = [strData substringToIndex:[strData length] - 1];
                    } else {
                        //no characters to delete... attempting to do so will result in a crash
                    }

//                    NSLog(@"shiftID  %@", [dictShift objectForKey:@"shiftID"]);
                }
            }
            
            [jobInfoTitleDescriptionCell setText:strData];
        }
            break;
        default:
            break;
            
    }
    
//    if(indexPath.row  ==  3){
//        applyButtonHeightConstraint.constant  =  40 ;
//        [applyNowButton setHidden:NO];
//        
//    }
//    else{
//        applyButtonHeightConstraint.constant  =  0;
//        [applyNowButton setHidden:YES];
//    }
    applyButtonHeightConstraint.constant  =  0;
}

@end
