//
//  NotificationsTableCell.m
//  SwissMonkey
//
//  Created by Kasturi on 1/27/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "NotificationsTableCell.h"

@implementation NotificationsTableCell
@synthesize notificationLabel,timeLabel,viewJobButton;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frameWidth:(float)width{
    
    self  =  [super initWithStyle:style reuseIdentifier:reuseIdentifier frameWidth:width];
    
    if(self){
        
        notificationLabel  =  [[UILabel  alloc]initWithFrame: CGRectMake(16, 10, width - (2 * 16) , 50)];
        [notificationLabel setBackgroundColor:[UIColor clearColor]];
        [notificationLabel setTextColor:[UIColor whiteColor]];
        [notificationLabel setTextAlignment:NSTextAlignmentLeft];
        [notificationLabel  setFont:[UIFont appNormalTextFont]];
        [self.contentView addSubview:notificationLabel];
        
        
        viewJobButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [viewJobButton setFrame:CGRectMake(16, CGRectGetMaxY(notificationLabel.frame), 100, 30)];
        [viewJobButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [viewJobButton setTitle:@"View Job" forState:UIControlStateNormal];
        [[viewJobButton  titleLabel] setFont:[UIFont appNormalTextFont]];
        [[viewJobButton titleLabel] setTextColor:[UIColor whiteColor]];
        [viewJobButton setBackgroundColor:[UIColor clearColor]];
        NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:@"View Job"];
        [commentString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [commentString length])];
        [viewJobButton setAttributedTitle:commentString forState:UIControlStateNormal];
        [self.contentView addSubview:viewJobButton];
        
        
        timeLabel  =  [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(viewJobButton.frame), width - (2 * 16), 21)];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setTextColor:[UIColor colorWithRed:166/255.0 green:207/255.0 blue:214/255.0 alpha:1.0]];
        [timeLabel setTextAlignment:NSTextAlignmentLeft];
        [timeLabel  setFont:[UIFont appLatoLightFont10]];
        [self.contentView addSubview:timeLabel];
    }
    return self;
}
- (void) setUpNotificationData:(NSDictionary *) notificationDict{
    notificationLabel.text  = [notificationDict objectForKey:@"notification_description"];
    timeLabel.text  =  [NSString stringWithFormat:@"%@ ago", [ReusedMethods agoDate:[notificationDict objectForKey:@"updated_at"]]]; //@"3 min ago";
    //notificationLabel.text  =  @"under development";
}
- (void) adjustCellFramesWithInfo:(NSDictionary *) notificationDict{
    
    [notificationLabel resizeToFit];
    [timeLabel resizeToFit];
    
    //    if( (int)notificationLabel.frame.size.height <= 50 )
    //        notificationLabel.center = CGPointMake(notificationLabel.center.x,  50/2);
    CGRect viewJobFrame = viewJobButton.frame;
    viewJobFrame.origin.y = CGRectGetMaxY(notificationLabel.frame)+ 5;
//    if(![[notificationDict allKeys] containsObject:@"company_id"]){
//        viewJobFrame.size.height  =  0;
//        viewJobButton.hidden  =  YES;
//        viewJobButton.userInteractionEnabled  =  NO;
//    }else{
//        viewJobFrame.size.height  =  30;
//        viewJobButton.hidden  =  NO;
//        viewJobButton.userInteractionEnabled  =  YES;
//    }
    
//    if([[notificationDict objectForKey:@"viewed"]integerValue] == 1){
//        viewJobFrame.size.height  =  0;
//        viewJobButton.hidden  =  YES;
//        viewJobButton.userInteractionEnabled  =  NO;
//    }else{
        viewJobFrame.size.height  =  30;
        viewJobButton.hidden  =  NO;
        viewJobButton.userInteractionEnabled  =  YES;
   // }

    
    viewJobButton.frame  =  viewJobFrame;
    
    CGRect timeLabelFrame = timeLabel.frame;
    timeLabelFrame.origin.y = CGRectGetMaxY(viewJobButton.frame) + 5;
    timeLabel.frame  =  timeLabelFrame;
    
}
- (float) getCellHeightWithDict:(NSDictionary *) notificationDict{
    
    [self  setUpNotificationData:notificationDict];
    [self adjustCellFramesWithInfo:notificationDict];
    
    return  MAX( CGRectGetMaxY(timeLabel.frame) + 10, 50);
}


@end
