//
//  VideoDisplayHeaderView.m
//  SwissMonkey
//
//  Created by Kasturi Dosapati on 25/05/16.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import "VideoDisplayHeaderView.h"

@implementation VideoDisplayHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(id)collectionReusableViewForCollectionView:(UICollectionView*)collectionView
                                     fromNib:(UINib*)nib
                                forIndexPath:(NSIndexPath*)indexPath
                                    withKind:(NSString*)kind{
    
    NSString *cellIdentifier = [self cellIdentifier];
    [collectionView registerClass:[self class] forSupplementaryViewOfKind:kind withReuseIdentifier:cellIdentifier];
    [collectionView registerNib:nib forSupplementaryViewOfKind:kind withReuseIdentifier:cellIdentifier];
    VideoDisplayHeaderView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    return reusableView;
}

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    [super applyLayoutAttributes:layoutAttributes];
    
}

+(id)collectionReusableViewForCollectionView:(UICollectionView*)collectionView
                                forIndexPath:(NSIndexPath*)indexPath withKind:(NSString*)kind{
    return [[self class] collectionReusableViewForCollectionView:collectionView
                                                         fromNib:[self nib]
                                                    forIndexPath:indexPath
                                                        withKind:kind];
}

+ (NSString *)nibName {
    return [self cellIdentifier];
}

+ (NSString *)cellIdentifier {
    static NSString* _cellIdentifier = nil;
    _cellIdentifier  = @"VideoDisplayHeaderView";
    
    return _cellIdentifier;
}

+(UINib*)nib{
    UINib * nib = [UINib nibWithNibName:@"VideoDisplayHeaderView" bundle:nil];
    return nib;
}


@end
