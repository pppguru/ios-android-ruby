//
//  LocationTblCell.h
//  SwissMonkey
//
//  Created by Kareem on 2016-07-12.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "LabelButton.h"
@interface LocationTblCell : CustomTableViewCell

@property (strong, nonatomic)  UIView *containerView;

@property (strong, nonatomic)  UILabel *positionLabel;
@property (strong, nonatomic)  UILabel *postedByLabel;
@property (strong, nonatomic)  UILabel *addressLabel;
@property (strong, nonatomic)  UILabel *jobTypeLabel;
@property (strong, nonatomic)  UILabel *compensationLabel;
@property (strong, nonatomic)  UIImageView *loctionImgView;
@property (strong, nonatomic)  UIImageView *jobTypeImgView;
@property (strong, nonatomic)  UIButton *saveButton;
@property (strong, nonatomic)  UIButton *viewButton;
@property (strong, nonatomic)  LabelButton *fullTimeButton;
@property (strong, nonatomic)  UIButton * mapDirectionButton;

@property (strong, nonatomic)  UIView * addressContainerView, * otherView;


- (id)  initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frameWidth:(float)width;
- (void) setUpCellData:(NSDictionary *)job;
- (float) getCellHeightWithDict:(NSDictionary *) notificationDict;
@end
