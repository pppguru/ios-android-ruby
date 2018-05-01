//
//  VideoDisplayHeaderView.h
//  SwissMonkey
//
//  Created by Kasturi Dosapati on 25/05/16.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoDisplayHeaderView : UICollectionReusableView


+(NSString*)cellIdentifier;
+(id)collectionReusableViewForCollectionView:(UICollectionView*)collectionView fromNib:(UINib*)nib forIndexPath:(NSIndexPath*)indexPath withKind:(NSString*)kind;
+(id)collectionReusableViewForCollectionView:(UICollectionView*)collectionView forIndexPath:(NSIndexPath*)indexPath withKind:(NSString*)kind;
+(UINib*)nib;

@end
