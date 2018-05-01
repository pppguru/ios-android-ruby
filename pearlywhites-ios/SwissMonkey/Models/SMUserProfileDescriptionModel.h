//
//  SMUserProfileDescriptionModel.h
//  SwissMonkey
//
//  Created by Kasturi on 1/22/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserProfileFilesListCell.h"
#import "UserProfileDescriptionCell.h"

@protocol SMUserprofileDescriptionModelDelegate <NSObject>

- (void) successResponseCall:(WebServiceCalls *) service;
- (void) showErrorMessages:(NSString *) error;

@end

@interface SMUserProfileDescriptionModel : NSObject{
    UILabel *header_TitleLabel, *header_subTitleLable,*seperaterLabel, * sectionTitle;
    UIView * expandableView , *expandableViewLinear;
    UIImageView * expandableImageView,* expandableImageViewLIner;
    UIButton * leftButton,*rightButton,*topButton,* bottomButton;
    int photoIndex, photoIndexLiner;
    NSString * sectionTitleString;
}

@property  (nonatomic , retain)  id <SMUserprofileDescriptionModelDelegate> delegate;
@property (nonatomic,  retain)  NSArray * profileImagesArray;
@property (nonatomic,  retain)  NSArray * profileVideosArray;
@property (nonatomic,  retain)  NSArray * profileResumesArray;
@property (nonatomic,  retain)  NSArray * profileRecomendationsArray;


-(void)setHilightedColorForButton:(UIButton *)button;
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section ;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic) UIImage *thumb;

#pragma  mark  - PROFILE DATA  METHIODS
-(void) callProfileDataAPICall;

-(void)createExpandableView;
-(void)createExpandableViewLinear;




@end
