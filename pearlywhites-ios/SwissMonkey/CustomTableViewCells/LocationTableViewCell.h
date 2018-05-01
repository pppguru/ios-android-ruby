//
//  LocationTableViewCell.h
//  SwissMonkey
//
//  Created by Prasad on 2/17/16.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import "CustomTableViewCell.h"

@interface LocationTableViewCell : CustomTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *postedByLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *compensationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *loctionImgView;
@property (weak, nonatomic) IBOutlet UIImageView *jobTypeImgView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *viewButton;
@property (weak, nonatomic) IBOutlet UIButton *fullTimeButton;
@property (weak, nonatomic)  IBOutlet UIButton * mapDirectionButton;

- (id)  initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frameWidth:(float)width;
- (void) setUpCellData:(NSDictionary *)job;


@end
