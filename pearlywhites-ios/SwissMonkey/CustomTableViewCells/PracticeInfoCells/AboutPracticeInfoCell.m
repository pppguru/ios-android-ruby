//
//  AboutPracticeInfoCell.m
//  SwissMonkey
//
//  Created by Kasturi on 1/28/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "AboutPracticeInfoCell.h"

@implementation AboutPracticeInfoCell

@synthesize  aboutPracticeInfoCell,establishedTitleLabel,establishedValuelabel,managementSystemTitleLabel,managementSystemValueLabel,
    digitalXRaysTitleLabel,digitalXRaysValueLabel,
    doctorsNumberTitleLabel,doctorsNumberValueLabel,
    hygeneAppontmentTitleLabel,hygeneAppontmentValueLabel,
    benefitsTitleLabel,benefitsValueLabel;


- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    
    aboutPracticeInfoCell.preferredMaxLayoutWidth  =  CGRectGetWidth(aboutPracticeInfoCell.frame);
    establishedTitleLabel.preferredMaxLayoutWidth  =  CGRectGetWidth(establishedTitleLabel.frame);
    establishedValuelabel.preferredMaxLayoutWidth  =  CGRectGetWidth(establishedValuelabel.frame);
    managementSystemTitleLabel.preferredMaxLayoutWidth  =  CGRectGetWidth(managementSystemTitleLabel.frame);
    managementSystemValueLabel.preferredMaxLayoutWidth  =  CGRectGetWidth(managementSystemValueLabel.frame);
    digitalXRaysTitleLabel.preferredMaxLayoutWidth  =  CGRectGetWidth(digitalXRaysTitleLabel.frame);
    digitalXRaysValueLabel.preferredMaxLayoutWidth  =  CGRectGetWidth(digitalXRaysValueLabel.frame);
    doctorsNumberTitleLabel.preferredMaxLayoutWidth  =  CGRectGetWidth(doctorsNumberTitleLabel.frame);
    doctorsNumberValueLabel.preferredMaxLayoutWidth  =  CGRectGetWidth(doctorsNumberValueLabel.frame);
    hygeneAppontmentTitleLabel.preferredMaxLayoutWidth  =  CGRectGetWidth(hygeneAppontmentTitleLabel.frame);
    hygeneAppontmentValueLabel.preferredMaxLayoutWidth  =  CGRectGetWidth(hygeneAppontmentValueLabel.frame);
    benefitsTitleLabel.preferredMaxLayoutWidth  =  CGRectGetWidth(benefitsTitleLabel.frame);
    benefitsValueLabel.preferredMaxLayoutWidth  =  CGRectGetWidth(benefitsValueLabel.frame);
}


@end
