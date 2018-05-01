//
//  NotificationsTableCell.h
//  SwissMonkey
//
//  Created by Kasturi on 1/27/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "CustomTableViewCell.h"

@interface NotificationsTableCell : CustomTableViewCell

@property  (nonatomic, retain)  UILabel *  notificationLabel;
@property (nonatomic , retain) UILabel * timeLabel;
@property (nonatomic, retain) UIButton *  viewJobButton;

- (void) setUpNotificationData:(NSDictionary *) notificationDict;
- (void) adjustCellFramesWithInfo:(NSDictionary *) notificationDict;
- (float) getCellHeightWithDict:(NSDictionary *) notificationDict;


@end
