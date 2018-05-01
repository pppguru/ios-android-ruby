//
//  PracticeInfoHeaderView.h
//  SwissMonkey
//
//  Created by Kasturi on 2/1/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PracticeInfoHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;


@property (weak, nonatomic) IBOutlet UILabel *aboutPracticeInfoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *establishedTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *establishedValuelabel;

@property (weak, nonatomic) IBOutlet UILabel *managementSystemTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *managementSystemValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *digitalXRaysTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *digitalXRaysValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *doctorsNumberTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *doctorsNumberValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *hygeneAppointmentTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *hygeneAppointmentValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *benefitsTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *benefitsValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *practiceDescriptionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *practiceDescriptionValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *horizantalLineLabel;

@property (weak, nonatomic) IBOutlet UILabel *horizantalLine2;
@property (weak, nonatomic) IBOutlet UILabel *photosLabel;

@property (weak, nonatomic) IBOutlet UILabel * operatoriesCountTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel * operatoriesCountValueLabel;


- (void) setupHeaderDataWithJobDetails:(NSDictionary *) jobDetailsDict;
- (CGSize) getHeaderHeightWithJobDetails:(NSDictionary *) jobDetailsDict;



+(NSString*)cellIdentifier;
+(id)collectionReusableViewForCollectionView:(UICollectionView*)collectionView fromNib:(UINib*)nib forIndexPath:(NSIndexPath*)indexPath withKind:(NSString*)kind;
+(id)collectionReusableViewForCollectionView:(UICollectionView*)collectionView forIndexPath:(NSIndexPath*)indexPath withKind:(NSString*)kind;
+(UINib*)nib;


@end

