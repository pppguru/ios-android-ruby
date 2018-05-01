//
//  SideBarItemsCell.m
//  SwissMonkey
//
//  Created by Kasturi on 29/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import "SideBarItemsCell.h"

@implementation SideBarItemsCell
@synthesize titleLabel;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frameWidth:(float)width{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier frameWidth:width];
    
    if(self){
        
        [titleLabel setBackgroundColor:[UIColor grayColor]];
        
        
    }
    return self;
}

@end
