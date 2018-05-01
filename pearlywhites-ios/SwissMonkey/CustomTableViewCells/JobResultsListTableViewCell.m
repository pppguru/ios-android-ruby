//
//  JobResultsListTableViewCell.m
//  SwissMonkey
//
//  Created by Kasturi on 1/19/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "JobResultsListTableViewCell.h"

@implementation JobResultsListTableViewCell

/*This property affects the size of the label when layout constraints are applied to it. During layout, if the text extends beyond the width specified by this property, the additional text is flowed to one or more new lines, thereby increasing the height of the label.
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    
    [ReusedMethods applyShadowToView:self.containerView];
    
//    self.jobPositionLabel.preferredMaxLayoutWidth  =  CGRectGetWidth(self.jobPositionLabel.frame);
//    self.postDurationLabel.preferredMaxLayoutWidth  =  CGRectGetWidth(self.postDurationLabel.frame);
//    self.addressLabel.preferredMaxLayoutWidth  =  CGRectGetWidth(self.addressLabel.frame);
//    self.compensationLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.compensationLabel.frame);
//    [self.compensationLabel sizeToFit];
    
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (id)  initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frameWidth:(float)width{
    return  self;
}

- (void) setUpCellData:(NSDictionary *)job{

    NSString *address1 = [ReusedMethods replaceNullString:[job objectForKey:@"address1"] withSpace:NO];
    NSString *address2 = [ReusedMethods replaceNullString:[job objectForKey:@"address2"] withSpace:NO];
    NSString *city = [ReusedMethods replaceNullString:[job objectForKey:@"city"] withSpace:NO];
    NSString *state = [[ReusedMethods replaceNullString:[job objectForKey:STATE]  withSpace:YES] uppercaseString];
    NSString *zipcode = [ReusedMethods replaceNullString:[job objectForKey:@"zipcode"] withSpace:NO];
    
    address1 = [ReusedMethods replaceNullString:[NSString stringWithFormat:@"%@,", address1] withSpace:YES];

    city = [ReusedMethods replaceNullString:[NSString stringWithFormat:@"%@,", city] withSpace:YES];

    
    self.jobPositionLabel.text  =  [job objectForKey:@"position"];
    
    self.companyNameLabel.text = [job objectForKey:@"company_name"];
    
    self.postDurationLabel.text  = [NSString stringWithFormat:@"Posted %@ ago", [ReusedMethods agoDate:[job objectForKey:@"updated_at"]]];
    [self.addressLabel setText:[NSString stringWithFormat:@"%@%@\n%@ %@, %@", address1, address2, city, state, zipcode]];
    
    NSString *jobType = [job objectForKey:@"job_type"];
    
    [self.fullTimeButton setTitle:jobType.uppercaseString forState:UIControlStateNormal];

    NSString *  dollerString =  [SMValidation isNumbersExistedInString:[job objectForKey:@"compensation_amount"]]? @"": @"$";
    NSString *compensationString = [NSString stringWithFormat:@"%@- %@%@", [job objectForKey:@"compensations"],dollerString,[job objectForKey:@"compensation_amount"]];
    compensationString = [compensationString stringByReplacingOccurrencesOfString:@".0" withString:@""];
    self.compensationLabel.text = compensationString;
    
    
    //If saved job
    if ([[job objectForKey:SAVED_STATUS] boolValue]) {
        [self.saveButton setSelected:YES];
    }
    else {
        [self.saveButton setSelected:NO];
    }

}

@end
