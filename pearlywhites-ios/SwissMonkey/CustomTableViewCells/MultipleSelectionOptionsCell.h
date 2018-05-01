//
//  MultipleSelectionOptionsCell.h
//  SwissMonkey
//
//  Created by Prasad on 2/16/16.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import "CustomTableViewCell.h"

@interface MultipleSelectionOptionsCell : CustomTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frameWidth:(float)width andHeight:(float)height;

@property  (nonatomic, retain)  UILabel *  optionLabel;
@property  (nonatomic,  retain)  UIButton * checkBoxButton;


@end
