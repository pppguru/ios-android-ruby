//
//  AboutPracticeInfoCell.h
//  SwissMonkey
//
//  Created by Kasturi on 1/28/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "CustomTableViewCell.h"

@interface AboutPracticeInfoCell : CustomTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *aboutPracticeInfoCell;
@property (weak, nonatomic) IBOutlet UILabel *establishedTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *establishedValuelabel;
@property (weak, nonatomic) IBOutlet UILabel *managementSystemTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *managementSystemValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *digitalXRaysTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *digitalXRaysValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *doctorsNumberTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *doctorsNumberValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *hygeneAppontmentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *hygeneAppontmentValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *benefitsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *benefitsValueLabel;

@end
