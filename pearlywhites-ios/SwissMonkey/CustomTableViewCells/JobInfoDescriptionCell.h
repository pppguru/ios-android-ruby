//
//  JobInfoDescriptionCell.h
//  SwissMonkey
//
//  Created by Kasturi on 1/28/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "CustomTableViewCell.h"

typedef enum{
    kJobDescription = 0,
    kRequirements,
    kTimings,
    kCompensation
}CellType;

@interface JobInfoDescriptionCell : CustomTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *jobInfoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobInfoTitleDescriptionCell;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *applyButtonHeightConstraint;

- (void)setupCellDataforIndex:(NSIndexPath *)  indexPath andJobDetails:(NSDictionary *)jobDetails;
- (void)layoutSubviews;

@end
