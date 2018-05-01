//
//  JobSearchOptionsCell.h
//  SwissMonkey
//
//  Created by Kasturi on 29/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import "CustomTableViewCell.h"

@interface JobSearchOptionsCell : CustomTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frameWidth:(float)width andHeight:(float)height;

@property  (nonatomic, retain)  UILabel *  optionLabel;

@end
