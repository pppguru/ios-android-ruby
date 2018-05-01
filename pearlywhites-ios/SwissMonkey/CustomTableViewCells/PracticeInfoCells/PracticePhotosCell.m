//
//  PracticePhotosCell.m
//  SwissMonkey
//
//  Created by Kasturi on 1/28/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "PracticePhotosCell.h"

@implementation PracticePhotosCell
@synthesize photosTitleLabel;

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    photosTitleLabel.preferredMaxLayoutWidth  =  CGRectGetWidth(photosTitleLabel.frame);
}


@end
