//
//  UserProfileDescriptionCell.h
//  SwissMonkey
//
//  Created by Kasturi on 1/22/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "CustomTableViewCell.h"

@interface UserProfileDescriptionCell : CustomTableViewCell

@property  (nonatomic, retain)  UILabel *  titleLabel, *subTitleLable;
- (void) setUpCellData:(NSDictionary *) responseDict onindexpath:(NSIndexPath *)indexpath;
- (CGFloat)getCellHeight:(NSDictionary *)responseDict onIndexPath:(NSIndexPath *) indexPath;
- (void)adjustCellFrames;



@end
