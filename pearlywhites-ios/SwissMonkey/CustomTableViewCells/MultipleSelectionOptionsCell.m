//
//  MultipleSelectionOptionsCell.m
//  SwissMonkey
//
//  Created by Prasad on 2/16/16.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import "MultipleSelectionOptionsCell.h"

@implementation MultipleSelectionOptionsCell
@synthesize optionLabel,checkBoxButton;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frameWidth:(float)width andHeight:(float)height{
    self  =  [super initWithStyle:style reuseIdentifier:reuseIdentifier frameWidth:width];
    if(self){
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        
        checkBoxButton  =  [UIButton buttonWithType:UIButtonTypeCustom];
        [checkBoxButton setFrame:CGRectMake(10, 0, 30, height)];
        [checkBoxButton setImage:[UIImage imageNamed:@"unsel"] forState:UIControlStateNormal];
        [checkBoxButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [self.contentView addSubview:checkBoxButton];
        
        float xPos  =  CGRectGetMaxX(checkBoxButton.frame) + 5;
        
        optionLabel  =  [[UILabel  alloc]initWithFrame: CGRectMake(xPos, 0, width - xPos - 10, 50)];
        [optionLabel setBackgroundColor:[UIColor clearColor]];
        [optionLabel setTextColor:[UIColor appGrayColor]];
        [optionLabel setTextAlignment:NSTextAlignmentLeft];
        [optionLabel setNumberOfLines:0];
        [optionLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [optionLabel  setFont:[UIFont appNormalTextFont]];
        [self.contentView addSubview:optionLabel];
    }
    return self;
}



@end
