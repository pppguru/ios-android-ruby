//
//  UserProfileFilesListCell.m
//  SwissMonkey
//
//  Created by Kasturi on 1/22/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "UserProfileFilesListCell.h"

@implementation UserProfileFilesListCell
@synthesize fileTitleLabel, fileIcon, transparentButton;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frameWidth:(float)width{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier frameWidth:width];
    if (self)
    {
        float  xPos  = 0;
        float  yPos  =  0;
        
        float  iconWidth  = 50;
        
        float  lblWidth  = width  -  (3 * xPos)  -  iconWidth;
        float  lblHeight  =  50  ;
        
        // add button  for playing a video
        fileIcon  = [UIButton buttonWithType:UIButtonTypeCustom];
        [fileIcon setFrame:CGRectMake(xPos, yPos, iconWidth, iconWidth)];
        [fileIcon  setImage:[UIImage imageNamed:@"ViewResume"] forState:UIControlStateNormal];
        [fileIcon  setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [[fileIcon  imageView] setContentMode:UIViewContentModeLeft];
        [fileIcon setBackgroundColor: [UIColor clearColor]];
        [self.contentView addSubview:fileIcon];
        
        xPos  =  CGRectGetMaxX(fileIcon.frame)+10;
//        xPos = 20;
        
        //videos  title  displayed on textLabel
        fileTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, lblWidth, lblHeight)];
        [fileTitleLabel setBackgroundColor:[UIColor clearColor]];
        [fileTitleLabel setTextColor:[UIColor appLightGrayColor]];
        [fileTitleLabel setFont:[UIFont appNormalTextFont]];
        [fileTitleLabel setNumberOfLines:0];
        [fileTitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [fileTitleLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView  addSubview:fileTitleLabel];
        [fileTitleLabel setCenter:CGPointMake(fileTitleLabel.center.x, fileIcon.center.y)];
        
        transparentButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        [transparentButton setFrame:fileTitleLabel.frame];
        [transparentButton setBackgroundColor: [UIColor clearColor]];
        [self.contentView addSubview:transparentButton];
    }
    return  self;
}









@end
