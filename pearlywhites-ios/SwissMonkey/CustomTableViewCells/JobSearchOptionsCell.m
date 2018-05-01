//
//  JobSearchOptionsCell.m
//  SwissMonkey
//
//  Created by Kasturi on 29/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import "JobSearchOptionsCell.h"

@implementation JobSearchOptionsCell
@synthesize optionLabel;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frameWidth:(float)width andHeight:(float)height{
    self  =  [super initWithStyle:style reuseIdentifier:reuseIdentifier frameWidth:width];
    if(self){
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        
        optionLabel  =  [[UILabel  alloc]initWithFrame: CGRectMake(10, 0, width - 10, 50)];
        [optionLabel setBackgroundColor:[UIColor clearColor]];
        [optionLabel setTextColor:[UIColor appGrayColor]];
        [optionLabel setTextAlignment:NSTextAlignmentLeft];
        [optionLabel  setFont:[UIFont appNormalTextFont]];
        [self.contentView addSubview:optionLabel];
    }
    return self;
}

@end
