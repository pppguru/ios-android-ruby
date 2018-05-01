//
//  PracticePhotosCell.h
//  SwissMonkey
//
//  Created by Kasturi on 1/28/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "CustomTableViewCell.h"

@interface PracticePhotosCell : CustomTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *photosTitleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *photosCollectionView;

@end
