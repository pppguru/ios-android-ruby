//
//  LocationTableViewCell.m
//  SwissMonkey
//
//  Created by Prasad on 2/17/16.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import "LocationTableViewCell.h"

@implementation LocationTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/*This property affects the size of the label when layout constraints are applied to it. During layout, if the text extends beyond the width specified by this property, the additional text is flowed to one or more new lines, thereby increasing the height of the label.
*/
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    self.positionLabel.preferredMaxLayoutWidth  =  CGRectGetWidth(self.positionLabel.frame);
    self.postedByLabel.preferredMaxLayoutWidth  =  CGRectGetWidth(self.postedByLabel.frame);
    self.addressLabel.preferredMaxLayoutWidth  =  CGRectGetWidth(self.addressLabel.frame);
    self.jobTypeLabel.preferredMaxLayoutWidth  =  CGRectGetWidth(self.jobTypeLabel.frame);
    self.compensationLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.compensationLabel.frame);
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
    city = [ReusedMethods replaceNullString:[NSString stringWithFormat:@"%@,",city] withSpace:YES];
    
    self.positionLabel.text  =  [job objectForKey:@"position"];//[dictPos objectForKey:@"position_name"];//[NSString stringWithFormat:@"Associate Dentist"];
    self.postedByLabel.text  = [NSString stringWithFormat:@"Posted %@ ago", [ReusedMethods agoDate:[job objectForKey:@"updated_at"]]];//[dictJD objectForKey:@"experience_range"];//[NSString stringWithFormat:@"posted 5 days ago"];
    [self.addressLabel setText:[NSString stringWithFormat:@"%@%@\n%@ %@, %@", address1, address2, city, state, zipcode]];
    self.jobTypeLabel.text  =  [NSString stringWithFormat:@"Job Type:"];
    
    NSString *jobType = [job objectForKey:@"job_type"];
    
//    [self.fullTimeButton setUserInteractionEnabled:![jobType.uppercaseString isEqualToString:@"Full-time".uppercaseString]];
    
   // [self.fullTimeButton setTitle:jobType forState:UIControlStateNormal];
    NSDictionary *attrDict = @{NSFontAttributeName : self.jobTypeLabel.font,NSForegroundColorAttributeName : [UIColor
                                                                                                              appGrayColor],NSUnderlineStyleAttributeName :[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:jobType];
    
    //    [commentString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [commentString length])];
    [commentString addAttributes:attrDict range:NSMakeRange(0, [commentString length])];
    
    
    [self.fullTimeButton setAttributedTitle:commentString forState:UIControlStateNormal];

    //    self.fullTimeButton.titleLabel.text  =  @"part time";
    NSString *  dollerString =  [SMValidation isNumbersExistedInString:[job objectForKey:@"compensation_amount"]]? @"": @"$";
    self.compensationLabel.text  =  [NSString stringWithFormat:@"Compensation: %@ - %@%@", [job objectForKey:@"compensations"],dollerString,[job objectForKey:@"compensation_amount"]];
    [self.compensationLabel sizeToFit];
}


@end
