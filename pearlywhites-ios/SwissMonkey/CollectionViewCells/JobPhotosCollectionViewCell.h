//
//  JobPhotosCollectionViewCell.h
//  SwissMonkey
//
//  Created by Kasturi on 2/1/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobPhotosCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;

- (void) setImageAtIndex:(NSIndexPath *)currentIndexPath FromImagesArray:(NSMutableArray *) imagesArray;


@end
