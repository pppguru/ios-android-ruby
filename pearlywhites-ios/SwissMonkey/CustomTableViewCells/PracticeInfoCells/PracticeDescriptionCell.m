//
//  PracticeDescriptionCell.m
//  SwissMonkey
//
//  Created by Kasturi on 1/28/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "PracticeDescriptionCell.h"

@implementation PracticeDescriptionCell
@synthesize profileDescriptionTitleLabel,ProfileDescriptionLabel;

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    profileDescriptionTitleLabel.preferredMaxLayoutWidth  =  CGRectGetWidth(profileDescriptionTitleLabel.frame);
    ProfileDescriptionLabel.preferredMaxLayoutWidth  =  CGRectGetWidth(ProfileDescriptionLabel.frame);
}


@end
