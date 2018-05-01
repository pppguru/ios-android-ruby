//
//  SideBarItemsCell.h
//  SwissMonkey
//
//  Created by Kasturi on 29/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import "CustomTableViewCell.h"

@interface SideBarItemsCell : CustomTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frameWidth:(float)width;
@end
