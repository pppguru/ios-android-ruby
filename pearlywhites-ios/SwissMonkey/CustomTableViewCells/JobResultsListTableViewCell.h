//
//  JobResultsListTableViewCell.h
//  SwissMonkey
//
//  Created by Kasturi on 1/19/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "CustomTableViewCell.h"

@interface JobResultsListTableViewCell : CustomTableViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *jobPositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *compensationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addressImgView;
@property (weak, nonatomic) IBOutlet UIImageView *jobImgView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *viewButton;
@property (weak, nonatomic) IBOutlet UIButton *fullTimeButton;

- (id)  initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frameWidth:(float)width;
- (void) setUpCellData:(NSDictionary *)job;


@end
