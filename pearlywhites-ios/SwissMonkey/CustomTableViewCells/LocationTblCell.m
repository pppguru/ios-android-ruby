//
//  LocationTblCell.m
//  SwissMonkey
//
//  Created by Kareem on 2016-07-12.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import "LocationTblCell.h"

@implementation LocationTblCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frameWidth:(float)width{
    
    self  =  [super initWithStyle:style reuseIdentifier:reuseIdentifier frameWidth:width];
    
    if(self){
        
        float startPoint = 10;
        float x = startPoint;
        float y = 8;
        float gap = 5;
        float partWidth = [self getPositionWidth:width gap:(x+y+(2*gap) + startPoint)];
        
        self.positionLabel  =  [[UILabel  alloc]initWithFrame: CGRectMake(x, y, 4*partWidth, 40)];
        [self.positionLabel setBackgroundColor:[UIColor clearColor]];
        [self.positionLabel setTextColor:[UIColor appBrightTextColor]];
        [self.positionLabel setTextAlignment:NSTextAlignmentLeft];
        [self.positionLabel  setFont:[UIFont appLatoLightFont14]];
        self.positionLabel.numberOfLines = 0;
        self.positionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:self.positionLabel];
        
        x =  CGRectGetMaxX(self.positionLabel.frame) + gap;
        
        self.postedByLabel  =  [[UILabel  alloc]initWithFrame: CGRectMake(width - (3*partWidth) -10, y, 3*partWidth, 40)];
        [self.postedByLabel setBackgroundColor:[UIColor clearColor]];
        [self.postedByLabel setTextColor:[UIColor appLightTextColor]];
        [self.postedByLabel setTextAlignment:NSTextAlignmentRight];
        [self.postedByLabel  setFont:[UIFont appLatoLightFont12]];
        [self.contentView addSubview:self.postedByLabel];
        
        x = startPoint;
        y = CGRectGetMaxY(self.positionLabel.frame);
        
        self.addressContainerView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width- x - 85, 33)];
        self.addressContainerView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.addressContainerView];
        
        self.loctionImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 6, 16, 22)];
        self.loctionImgView.image = [UIImage imageNamed:@"mapdescription"];
        self.loctionImgView.contentMode = UIViewContentModeScaleToFill;
        [self.addressContainerView addSubview:self.loctionImgView];
        
        self.addressLabel  =  [[UILabel  alloc]initWithFrame: CGRectMake(26, 0, self.addressContainerView.frame.size.width- 65, self.addressContainerView.frame.size.height)];
        [self.addressLabel setBackgroundColor:[UIColor clearColor]];
        [self.addressLabel setTextColor:[UIColor appLightTextColor]];
        [self.addressLabel setTextAlignment:NSTextAlignmentLeft];
        [self.addressLabel  setFont:[UIFont appLatoLightFont12]];
        self.addressLabel.numberOfLines = 0;
        self.addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.addressContainerView addSubview:self.addressLabel];
        
        self.mapDirectionButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.addressContainerView.frame) - 40,0 , 30, 33)];
        [self.mapDirectionButton setImage:[UIImage imageNamed:@"mapdirection"] forState:UIControlStateNormal];
        [self.addressContainerView addSubview:self.mapDirectionButton];
        
        self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.saveButton setFrame:CGRectMake(width - 75, y + 10, 65, 32)];
        [self.saveButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [self.saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
        [[self.saveButton  titleLabel] setFont:[UIFont appLatoLightFont12]];
        [self.saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         [self.saveButton setBackgroundColor:[UIColor clearColor]];
      [self.saveButton setBackgroundImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.saveButton];
        
        x = startPoint;
        y = CGRectGetMaxY(self.addressContainerView.frame);
        
        self.otherView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width- x - 85, 84)];
        [self.contentView addSubview:self.otherView];
        
        self.jobTypeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 16, 18, 22)];
        self.jobTypeImgView.image = [UIImage imageNamed:@"lock"];
        self.jobTypeImgView.contentMode = UIViewContentModeScaleToFill;
        [self.otherView addSubview:self.jobTypeImgView];
        
        self.jobTypeLabel  =  [[UILabel  alloc]initWithFrame: CGRectMake(26, 0, 64, 22)];
        [self.jobTypeLabel setBackgroundColor:[UIColor clearColor]];
        [self.jobTypeLabel setTextColor:[UIColor appLightTextColor]];
        [self.jobTypeLabel setTextAlignment:NSTextAlignmentLeft];
        [self.jobTypeLabel  setFont:[UIFont appLatoLightFont12]];
        [self.otherView addSubview:self.jobTypeLabel];
        
        self.fullTimeButton = [[LabelButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.jobTypeLabel.frame)-5, 3, CGRectGetWidth(self.otherView.frame) - CGRectGetMaxX(self.jobTypeLabel.frame), 22)];
        [self.fullTimeButton addTxtLabel];
        [self.fullTimeButton setTitleColor:[UIColor appPinkColor] forState:UIControlStateNormal];
        self.fullTimeButton.titleLabel.font = [UIFont appLatoLightFont12];
        self.fullTimeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.fullTimeButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.fullTimeButton.titleLabel.numberOfLines = 0;
        [self.otherView addSubview:self.fullTimeButton];
        
        
        self.compensationLabel  =  [[UILabel  alloc]initWithFrame: CGRectMake(CGRectGetMinX(self.jobTypeLabel.frame), CGRectGetMaxY(self.jobTypeLabel.frame), self.otherView.frame.size.width- CGRectGetMinX(self.jobTypeLabel.frame), self.otherView.frame.size.height- CGRectGetMaxY(self.jobTypeLabel.frame))];
        [self.compensationLabel setBackgroundColor:[UIColor clearColor]];
        [self.compensationLabel setTextColor:[UIColor appLightTextColor]];
        [self.compensationLabel setTextAlignment:NSTextAlignmentLeft];
        [self.compensationLabel  setFont:[UIFont appLatoLightFont12]];
        self.compensationLabel.numberOfLines = 0;
        self.compensationLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.otherView addSubview:self.compensationLabel];
        
        self.viewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.viewButton setFrame:CGRectMake(width - 75, CGRectGetMaxY(self.saveButton.frame) + 20, 65, 32)];
        [self.viewButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [self.viewButton setTitle:@"VIEW" forState:UIControlStateNormal];
        [[self.viewButton  titleLabel] setFont:[UIFont appLatoLightFont12]];
        [[self.viewButton titleLabel] setTextColor:[UIColor appWhiteColor]];
       // [self.viewButton setBackgroundColor:[UIColor appGreenColor]];
        [self.viewButton setBackgroundImage:[UIImage imageNamed:@"view"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.viewButton];
        
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        [ReusedMethods applyShadowToView:self.containerView];
        
       
    }
    return self;
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
   // self.positionLabel.text  = @"kkkkk jfbkjfakjs jsfkjas ajbfajsmv a,mbasm ams,v mv mv mnv nmafa kkkkk jfbkjfakjs jsfkjas ajbfajsmv a,mbasm ams,v mv mv mnv nmafa kkkkk jfbkjfakjs jsfkjas ajbfajsmv a,mbasm ams,v mv mv mnv nmafa kkkkk jfbkjfakjs jsfkjas ajbfajsmv a,mbasm ams,v mv mv mnv nmafakkkkk jfbkjfakjs jsfkjas ajbfajsmv a,mbasm ams,v mv mv mnv nmafa kkkkk jfbkjfakjs jsfkjas ajbfajsmv a,mbasm ams,v mv mv mnv nmafakkkkk jfbkjfakjs jsfkjas ajbfajsmv a,mbasm ams,v mv mv mnv nmafa kkkkk jfbkjfakjs jsfkjas ajbfajsmv a,mbasm ams,v mv mv mnv nmafakkkkk jfbkjfakjs jsfkjas ajbfajsmv a,mbasm ams,v mv mv mnv nmafa kkkkk jfbkjfakjs jsfkjas ajbfajsmv a,mbasm ams,v mv mv mnv nmafakkkkk jfbkjfakjs jsfkjas ajbfajsmv a,mbasm ams,v mv mv mnv nmafa kkkkk jfbkjfakjs jsfkjas ajbfajsmv a,mbasm ams,v mv mv mnv nmafa";
    self.postedByLabel.text  = [NSString stringWithFormat:@"Posted %@ ago", [ReusedMethods agoDate:[job objectForKey:@"updated_at"]]];//[dictJD objectForKey:@"experience_range"];//[NSString stringWithFormat:@"posted 5 days ago"];
    [self.addressLabel setText:[NSString stringWithFormat:@"%@%@\n%@ %@, %@", address1, address2, city, state, zipcode]];
    self.jobTypeLabel.text  =  [NSString stringWithFormat:@"Job Type:"];
    
    NSString *jobType = [job objectForKey:@"job_type"];
   // jobType = @"Long time ytpe text expecting. Long time ytpe text expecting. Long time ytpe text expecting. Long time ytpe text expecting.";
    //    [self.fullTimeButton setUserInteractionEnabled:![jobType.uppercaseString isEqualToString:@"Full-time".uppercaseString]];
    
    // [self.fullTimeButton setTitle:jobType forState:UIControlStateNormal];
    NSDictionary *attrDict = @{NSFontAttributeName : self.jobTypeLabel.font,NSForegroundColorAttributeName : [UIColor
                                                                                                              appGrayColor],NSUnderlineStyleAttributeName :[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:jobType];
    
    //    [commentString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [commentString length])];
    [commentString addAttributes:attrDict range:NSMakeRange(0, [commentString length])];
    
    
   // [self.fullTimeButton setAttributedTitle:commentString forState:UIControlStateNormal];
    [self.fullTimeButton.txtLbl setAttributedText:commentString];
    //    self.fullTimeButton.titleLabel.text  =  @"part time";
    NSString *  dollerString =  [SMValidation isNumbersExistedInString:[job objectForKey:@"compensation_amount"]]? @"": @"$";
   // self.compensationLabel.text  =  [NSString stringWithFormat:@"Compensation: %@ - %@%@", [job objectForKey:@"compensations"],dollerString,[job objectForKey:@"compensation_amount"]];
    
    
    NSString *status = [job objectForKey:@"status"];
    //NSString *  dollerString =  [SMValidation isNumbersExistedInString:[job objectForKey:@"compensation_amount"]]? @"": @"$";
    
    if([status isKindOfClass:[NSString class]] && status.length){
        self.compensationLabel.text  =  [NSString stringWithFormat:@"Compensation: %@ - %@%@\nApplication Status : %@", [job objectForKey:@"compensations"],dollerString, [job objectForKey:@"compensation_amount"], status];
    }
    else
        self.compensationLabel.text  =  [NSString stringWithFormat:@"Compensation: %@ - %@%@", [job objectForKey:@"compensations"],dollerString,[job objectForKey:@"compensation_amount"]];

    
    [self adjustCellFramesWithInfo:job];
    
}

- (void) adjustCellFramesWithInfo:(NSDictionary *) notificationDict
{
 
    
    [self.postedByLabel sizeToFit];
    
    // adjusting x positon
    CGRect postLabelFrame = self.postedByLabel.frame;
    postLabelFrame.origin.x = CGRectGetMaxX(self.saveButton.frame) - CGRectGetWidth(postLabelFrame);
    self.postedByLabel.frame = postLabelFrame;
    
    CGRect btnFrame = self.saveButton.frame;
    btnFrame.origin.y = CGRectGetMaxY(self.postedByLabel.frame) + 10;
    self.saveButton.frame = btnFrame;
    
    btnFrame = self.viewButton.frame;
    btnFrame.origin.y = CGRectGetMaxY(self.saveButton.frame) + 20;
    self.viewButton.frame = btnFrame;
    
    [self.positionLabel resizeToFit];
   
    [self.addressLabel resizeToFit];
    
    CGRect frame = self.addressContainerView.frame;
    frame.origin.y   = CGRectGetMaxY(self.positionLabel.frame);
    frame.size.height = self.addressLabel.frame.size.height;
    self.addressContainerView.frame = frame;
    
    
    [self.fullTimeButton resizeButtonFrame];
    
    
    [self.compensationLabel resizeToFit];
    
    float maxY = MAX (CGRectGetMaxY(self.jobTypeLabel.frame), CGRectGetMaxY(self.fullTimeButton.frame));
    frame = self.otherView.frame;
    frame.origin.y   = CGRectGetMaxY(self.addressContainerView.frame);
    
    CGRect compFrame = self.compensationLabel.frame;
    compFrame.origin.y = maxY;
    self.compensationLabel.frame = compFrame;
    
    frame.size.height = CGRectGetMaxY(self.compensationLabel.frame);
    self.otherView.frame = frame;
    
    self.jobTypeImgView.center = CGPointMake(self.jobTypeImgView.center.x, CGRectGetMinY(self.compensationLabel.frame));
 
}
-(float)getPositionWidth:(float)viewWidth gap:(float)gap
{
    float width = (viewWidth - gap)/7.0f;
    return width;
}

- (float) getCellHeightWithDict:(NSDictionary *) notificationDict

{
    [self  setUpCellData:notificationDict];
    [self adjustCellFramesWithInfo:notificationDict];
    
    return  MAX( CGRectGetMaxY(self.otherView.frame) + 5, CGRectGetMaxY(self.viewButton.frame) +10);
}
@end
