//
//  PracticeInfoHeaderView.m
//  SwissMonkey
//
//  Created by Kasturi on 2/1/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "PracticeInfoHeaderView.h"

@implementation PracticeInfoHeaderView

@synthesize aboutPracticeInfoTitleLabel,establishedTitleLabel,establishedValuelabel,
    managementSystemTitleLabel,managementSystemValueLabel,
    digitalXRaysTitleLabel,digitalXRaysValueLabel,
    doctorsNumberTitleLabel,doctorsNumberValueLabel,
    hygeneAppointmentTitleLabel,hygeneAppointmentValueLabel,
    benefitsTitleLabel,benefitsValueLabel,
    practiceDescriptionTitleLabel,practiceDescriptionValueLabel,
operatoriesCountTitleLabel,operatoriesCountValueLabel,
horizantalLineLabel,horizantalLine2,photosLabel;

- (id)  init{
    
    self  = [super init];
    
    if (self) {
       // [establishedValuelabel alignBottom];
       // [doctorsNumberValueLabel  alignBottom];
        
        [self setUpFramesOnView];

    }
    return self;
}



- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //[self setUpFramesOnView];
   // [self setBackgroundColor:[UIColor redColor]];

}



- (void)layoutSubviews
{
//    [super layoutSubviews];
//    
//    aboutPracticeInfoTitleLabel.preferredMaxLayoutWidth = aboutPracticeInfoTitleLabel.frame.size.width;
//    
//    establishedTitleLabel.preferredMaxLayoutWidth = establishedTitleLabel.frame.size.width;
//    establishedValuelabel.preferredMaxLayoutWidth = establishedValuelabel.frame.size.width;
//    
//    managementSystemTitleLabel.preferredMaxLayoutWidth = managementSystemTitleLabel.frame.size.width;
//    managementSystemValueLabel.preferredMaxLayoutWidth = managementSystemValueLabel.frame.size.width;
//    
//    digitalXRaysTitleLabel.preferredMaxLayoutWidth = digitalXRaysTitleLabel.frame.size.width;
//    digitalXRaysValueLabel.preferredMaxLayoutWidth = digitalXRaysValueLabel.frame.size.width;
//    
//    doctorsNumberTitleLabel.preferredMaxLayoutWidth = doctorsNumberTitleLabel.frame.size.width;
//    doctorsNumberValueLabel.preferredMaxLayoutWidth = doctorsNumberValueLabel.frame.size.width;
//    
//    hygeneAppointmentTitleLabel.preferredMaxLayoutWidth = hygeneAppointmentTitleLabel.frame.size.width;
//    hygeneAppointmentValueLabel.preferredMaxLayoutWidth = hygeneAppointmentValueLabel.frame.size.width;
//    
//    benefitsTitleLabel .preferredMaxLayoutWidth  =  benefitsTitleLabel.frame.size.width;
//    benefitsValueLabel.preferredMaxLayoutWidth  =  benefitsValueLabel.frame.size.width;
//
//    practiceDescriptionTitleLabel.preferredMaxLayoutWidth = practiceDescriptionTitleLabel.frame.size.width;
//    practiceDescriptionValueLabel.preferredMaxLayoutWidth = practiceDescriptionValueLabel.frame.size.width;
//    
//    operatoriesCountTitleLabel.preferredMaxLayoutWidth  =  operatoriesCountTitleLabel.frame.size.width;
//    operatoriesCountValueLabel.preferredMaxLayoutWidth =
//    operatoriesCountValueLabel.frame.size.width;
//    
//    photosLabel.preferredMaxLayoutWidth  =  photosLabel.frame.size.width;
//    
//    horizantalLineLabel.preferredMaxLayoutWidth  =  horizantalLineLabel.frame.size.width;
//    horizantalLine2.preferredMaxLayoutWidth  = horizantalLine2.frame.size.width;
    
}

- (void) setupHeaderDataWithJobDetails:(NSDictionary *) jobDetailsDict{
    
    BOOL isAnonymousUser = NO;
    NSString *anonymous = [jobDetailsDict valueForKey:@"company_name"];
    if ([anonymous isEqualToString:ANONYMOUS]) {
        isAnonymousUser = YES;
    }
    
    //horizantalLineLabel.hidden = isAnonymousUser;
    horizantalLine2.hidden = isAnonymousUser;
    practiceDescriptionTitleLabel.hidden = isAnonymousUser;
    practiceDescriptionValueLabel.hidden = isAnonymousUser;
    photosLabel.hidden = isAnonymousUser;
    
    [aboutPracticeInfoTitleLabel setText:@"About the Practice"];
    
    [establishedTitleLabel setText:@"Practice Established"];
    [managementSystemTitleLabel setText:@"Practice Management System"];
    [digitalXRaysTitleLabel setText:@"Digital X Rays"];
    [doctorsNumberTitleLabel setText:@"Total Number of Doctors"];
    [hygeneAppointmentTitleLabel setText:@"Length of Prophy Appointment"];
    [operatoriesCountTitleLabel setText:@"Total Number of Operatories"];
    [benefitsTitleLabel setText:@"Benefits"];
    
    [practiceDescriptionTitleLabel setText:@"Practice Description"];
    [photosLabel setText:@"Photos"];
    
    aboutPracticeInfoTitleLabel.font = [UIFont appLatoBlackFont18];
    [aboutPracticeInfoTitleLabel setTextColor:[UIColor appCustomPurpleColor]];
    establishedTitleLabel.font = [UIFont appLatoBlackFont14];
    managementSystemTitleLabel.font = [UIFont appLatoBlackFont14];
    digitalXRaysTitleLabel.font = [UIFont appLatoBlackFont14];
    doctorsNumberTitleLabel.font = [UIFont appLatoBlackFont14];
    hygeneAppointmentTitleLabel.font = [UIFont appLatoBlackFont14];
    operatoriesCountTitleLabel.font = [UIFont appLatoBlackFont14];
    benefitsTitleLabel.font = [UIFont appLatoBlackFont14];
    practiceDescriptionTitleLabel.font  = [UIFont appLatoBlackFont18];
    [practiceDescriptionTitleLabel setTextColor:[UIColor appCustomPurpleColor]];
    
    NSString * companyEstablishedOn  =  [ReusedMethods changeDisplayFormatOfDateString:[jobDetailsDict objectForKey:@"company_established"] withEmptyString:EMPTY_STRING];
//    NSString * managementValue  =  [jobDetailsDict objectForKey:@"practice_management_system"];
    NSString * managementValue  =  [jobDetailsDict objectForKey:@"company_practice_management_system"];

    NSString * digitalXRaysValue  = [jobDetailsDict objectForKey:@"digital_x_ray"];
    NSString * doctorsNumber =  [NSString stringWithFormat:@"%ld",(long)[[jobDetailsDict objectForKey:@"total_no_of_doctors"] integerValue]];
    NSString * lengthOfAppointment  =  [jobDetailsDict objectForKey:@"length_of_appointment"];
    NSString * totalNumberofOperatories = [NSString stringWithFormat:@"%ld",(long)[[jobDetailsDict objectForKey:@"total_no_of_operatories"] integerValue]];
    NSString * benefits =  [jobDetailsDict objectForKey:@"benefits"];
    benefits = [benefits stringByReplacingOccurrencesOfString:@", " withString:@","];
    benefits = [benefits stringByReplacingOccurrencesOfString:@"," withString:@", "];
    
    NSString * practiceDescription  = [jobDetailsDict objectForKey:@"about_your_company"];
    NSString * emptyString  =  @"-";
    
    if([companyEstablishedOn isKindOfClass:[NSString class]])
        [establishedValuelabel setText:companyEstablishedOn.length ? companyEstablishedOn : emptyString];
    else
        [establishedValuelabel setText:emptyString];
    
    if([managementValue isKindOfClass:[NSString class]]){
        managementValue = [managementValue stringByReplacingOccurrencesOfString:@", " withString:@","];
        managementValue = [managementValue stringByReplacingOccurrencesOfString:@"," withString:@", "];
        [managementSystemValueLabel setText:managementValue.length ? managementValue:emptyString];
    }
    else
        [managementSystemValueLabel setText:emptyString];
    
    if([digitalXRaysValue isKindOfClass:[NSString class]])
        [digitalXRaysValueLabel setText:digitalXRaysValue.length ? digitalXRaysValue:emptyString];
    else
        [digitalXRaysValueLabel setText:emptyString];
    
    if([doctorsNumber isKindOfClass:[NSString class]])
        [doctorsNumberValueLabel setText:doctorsNumber.length ? doctorsNumber:emptyString];
    else
        [doctorsNumberValueLabel setText:emptyString];
    
    if([lengthOfAppointment isKindOfClass:[NSString class]])
        [hygeneAppointmentValueLabel setText:lengthOfAppointment.length ? lengthOfAppointment: emptyString];
    else
        [hygeneAppointmentValueLabel setText:emptyString];
    
    if([totalNumberofOperatories isKindOfClass:[NSString class]])
        [operatoriesCountValueLabel setText:totalNumberofOperatories.length ? totalNumberofOperatories:emptyString];
    else
        [operatoriesCountValueLabel setText:emptyString];
    
    if([benefits isKindOfClass:[NSString class]])
        [benefitsValueLabel setText:benefits.length ? benefits:emptyString];
    else
        [benefitsValueLabel setText:emptyString];
    
    if([practiceDescription isKindOfClass:[NSString class]])
        [practiceDescriptionValueLabel setText:practiceDescription.length ? practiceDescription:emptyString];
    else
        [practiceDescriptionValueLabel setText:emptyString];

    establishedValuelabel.font = [UIFont appLatoLightFont14];
    managementSystemValueLabel.font = [UIFont appLatoLightFont14];
    digitalXRaysValueLabel.font = [UIFont appLatoLightFont14];
    doctorsNumberValueLabel.font = [UIFont appLatoLightFont14];
    hygeneAppointmentValueLabel.font = [UIFont appLatoLightFont14];
    operatoriesCountValueLabel.font = [UIFont appLatoLightFont14];
    benefitsValueLabel.font = [UIFont appLatoLightFont14];
    practiceDescriptionValueLabel.font = [UIFont appLatoLightFont14];
    


//    [managementSystemValueLabel setText:@"AT crown we also refer patients to hostal clinics safasf asfasfasf asfas asfasfsfa asfa asfas"];
}

- (CGSize) getHeaderHeightWithJobDetails:(NSDictionary *) jobDetailsDict {
    [self setupHeaderDataWithJobDetails:jobDetailsDict];
    
    [self setUpFramesOnView];
    
    [aboutPracticeInfoTitleLabel resizeToFit];
    [establishedTitleLabel resizeToFit];
    [establishedValuelabel resizeToFit];
    
    [managementSystemTitleLabel resizeToFit];
    [managementSystemValueLabel resizeToFit];
    
    [digitalXRaysTitleLabel  resizeToFit];
    [digitalXRaysValueLabel  resizeToFit];
    
    [doctorsNumberTitleLabel  resizeToFit];
    [doctorsNumberValueLabel  resizeToFit];
    
    [hygeneAppointmentTitleLabel  resizeToFit];
    [hygeneAppointmentValueLabel  resizeToFit];
    
    [operatoriesCountTitleLabel resizeToFit];
    [operatoriesCountValueLabel resizeToFit];
    
    [benefitsTitleLabel  resizeToFit];
    [benefitsValueLabel  resizeToFit];
    
    [practiceDescriptionTitleLabel resizeToFit];
    [practiceDescriptionValueLabel  resizeToFit];
    
    float verticalGap  =   5;
    float verticalHeaderGap  =   10;
    
    CGRect aboutPracticeInfoTitleLabelFrame  =  aboutPracticeInfoTitleLabel.frame;
    aboutPracticeInfoTitleLabelFrame.origin.y +=  verticalHeaderGap;
    aboutPracticeInfoTitleLabel.frame  =  aboutPracticeInfoTitleLabelFrame;
    
    CGRect establishedTitleLabelFrame  =  establishedTitleLabel.frame;
    establishedTitleLabelFrame.origin.y =  CGRectGetMaxY(aboutPracticeInfoTitleLabel.frame) + verticalGap + verticalHeaderGap;
    establishedTitleLabel.frame  =  establishedTitleLabelFrame;
    
    CGRect establishedValueLabelFrame  =  establishedValuelabel.frame;
    establishedValueLabelFrame.origin.y =  CGRectGetMaxY(establishedTitleLabel.frame) + verticalGap;
    establishedValuelabel.frame  =  establishedValueLabelFrame;
    
    
    
    float  maximumValue  = MAX(CGRectGetMaxY(establishedTitleLabel.frame), CGRectGetMaxY(establishedValuelabel.frame)) ;
    
    CGRect managementSystemTitleLabelFrame  =  managementSystemTitleLabel.frame;
    managementSystemTitleLabelFrame.origin.y =  maximumValue + verticalGap + verticalHeaderGap;
    managementSystemTitleLabel.frame  =  managementSystemTitleLabelFrame;
    
    CGRect managementSystemValueLabelFrame  =  managementSystemValueLabel.frame;
    managementSystemValueLabelFrame.origin.y =  CGRectGetMaxY(managementSystemTitleLabel.frame) + verticalGap;
    managementSystemValueLabel.frame  =  managementSystemValueLabelFrame;
    
    
      maximumValue  = MAX(CGRectGetMaxY(managementSystemTitleLabel.frame), CGRectGetMaxY(managementSystemValueLabel.frame)) ;
    
    CGRect digitalXRayTitleLabelFrame  =  digitalXRaysTitleLabel.frame;
    digitalXRayTitleLabelFrame.origin.y =  maximumValue + verticalGap + verticalHeaderGap;
    digitalXRaysTitleLabel.frame  =  digitalXRayTitleLabelFrame;
    
    CGRect digitalXRayTitleValueFrame  =  digitalXRaysValueLabel.frame;
    digitalXRayTitleValueFrame.origin.y =  CGRectGetMaxY(digitalXRaysTitleLabel.frame) + verticalGap;
    digitalXRaysValueLabel.frame  =  digitalXRayTitleValueFrame;
    
    maximumValue  = MAX(CGRectGetMaxY(digitalXRaysTitleLabel.frame), CGRectGetMaxY(digitalXRaysValueLabel.frame)) ;
    
    CGRect doctorsNumberTitleLabelFrame  =  doctorsNumberTitleLabel.frame;
    doctorsNumberTitleLabelFrame.origin.y =  maximumValue + verticalGap + verticalHeaderGap;//CGRectGetMaxY(digitalXRaysValueLabel.frame) + verticalGap;
    doctorsNumberTitleLabel.frame  =  doctorsNumberTitleLabelFrame;
    
    CGRect doctorsNumberValueLabelFrame  =  doctorsNumberValueLabel.frame;
    doctorsNumberValueLabelFrame.origin.y =  CGRectGetMaxY(doctorsNumberTitleLabel.frame) + verticalGap;//CGRectGetMaxY(digitalXRaysValueLabel.frame) + verticalGap;
    doctorsNumberValueLabel.frame  =  doctorsNumberValueLabelFrame;
    
    
     maximumValue  = MAX(CGRectGetMaxY(doctorsNumberTitleLabel.frame), CGRectGetMaxY(doctorsNumberValueLabel.frame)) ;
    
    
    CGRect hygeneAppointmentTitleLabelFrame  =  hygeneAppointmentTitleLabel.frame;
    hygeneAppointmentTitleLabelFrame.origin.y =  maximumValue +verticalGap + verticalHeaderGap;//CGRectGetMaxY(doctorsNumberValueLabel.frame) + verticalGap;
    hygeneAppointmentTitleLabel.frame  =  hygeneAppointmentTitleLabelFrame;
    
    CGRect hygeneAppointmentValueLabelFrame  =  hygeneAppointmentValueLabel.frame;
    hygeneAppointmentValueLabelFrame.origin.y =  CGRectGetMaxY(hygeneAppointmentTitleLabel.frame) + verticalGap;//CGRectGetMaxY(doctorsNumberValueLabel.frame) + verticalGap;
    hygeneAppointmentValueLabel.frame  =  hygeneAppointmentValueLabelFrame;
    
    
    
     maximumValue  = MAX(CGRectGetMaxY(hygeneAppointmentTitleLabel.frame), CGRectGetMaxY(hygeneAppointmentValueLabel.frame)) ;
    
    CGRect benefitsTitleLabelFrame  =  benefitsTitleLabel.frame;
    benefitsTitleLabelFrame.origin.y =  maximumValue +  verticalGap + verticalHeaderGap;//CGRectGetMaxY(hygeneAppointmentValueLabel.frame) + verticalGap;
    benefitsTitleLabel.frame  =  benefitsTitleLabelFrame;
    
    CGRect benefitsValueLabelFrame  =  benefitsValueLabel.frame;
    benefitsValueLabelFrame.origin.y =  CGRectGetMaxY(benefitsTitleLabel.frame) +  verticalGap;//CGRectGetMaxY(hygeneAppointmentValueLabel.frame) + verticalGap;
    benefitsValueLabel.frame  =  benefitsValueLabelFrame;
    
    
     maximumValue  = MAX(CGRectGetMaxY(benefitsTitleLabel.frame), CGRectGetMaxY(benefitsValueLabel.frame)) ;
    
    
    CGRect operatoriesCountTitleLabelFrame  =  operatoriesCountTitleLabel.frame;
    operatoriesCountTitleLabelFrame.origin.y =  maximumValue + verticalGap + verticalHeaderGap;//CGRectGetMaxY(benefitsValueLabel.frame) + verticalGap;
    operatoriesCountTitleLabel.frame  =  operatoriesCountTitleLabelFrame;
    
    CGRect operatoriesCountValueLabelFrame  =  operatoriesCountValueLabel.frame;
    operatoriesCountValueLabelFrame.origin.y =  CGRectGetMaxY(operatoriesCountTitleLabel.frame) + verticalGap;//CGRectGetMaxY(benefitsValueLabel.frame) + verticalGap;
    operatoriesCountValueLabel.frame  =  operatoriesCountValueLabelFrame;
    
    
    maximumValue  = MAX(CGRectGetMaxY(operatoriesCountTitleLabel.frame), CGRectGetMaxY(operatoriesCountValueLabel.frame)) ;

    
    
    CGRect horizantalLine1LabelFrame  =  horizantalLineLabel.frame;
    horizantalLine1LabelFrame.origin.y =  maximumValue + verticalGap + verticalHeaderGap;//CGRectGetMaxY(operatoriesCountValueLabel.frame) + verticalGap;
    horizantalLineLabel.frame  =  horizantalLine1LabelFrame;

    
    CGRect practiceDescriptionTitleLabelFrame  =  practiceDescriptionTitleLabel.frame;
    practiceDescriptionTitleLabelFrame.origin.y =  CGRectGetMaxY(horizantalLineLabel.frame) + verticalGap + verticalHeaderGap;
    practiceDescriptionTitleLabel.frame  =  practiceDescriptionTitleLabelFrame;
    
    CGRect practiceDescriptionValueLabelFrame  =  practiceDescriptionValueLabel.frame;
    practiceDescriptionValueLabelFrame.origin.y =  CGRectGetMaxY(practiceDescriptionTitleLabel.frame) + verticalGap + verticalHeaderGap;
    practiceDescriptionValueLabel.frame  =  practiceDescriptionValueLabelFrame;

    CGRect horizantalLine2Frame  =  horizantalLine2.frame;
    horizantalLine2Frame.origin.y = CGRectGetMaxY(practiceDescriptionValueLabel.frame) + verticalGap + verticalHeaderGap;
    horizantalLine2.frame  =  horizantalLine2Frame;
    
    CGRect photosLabelFrame  =  photosLabel.frame;
    photosLabelFrame.origin.y =  CGRectGetMaxY(horizantalLine2.frame) + verticalGap + verticalHeaderGap;
    photosLabel.frame  =  photosLabelFrame;
    
   // CGFloat height = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    //CGFloat  headerHeight  =   MAX(height,  CGRectGetMaxY(photosLabel.frame));
    
    return CGSizeMake(self.frame.size.width, photosLabel.frame.origin.y + 30);
}


+(id)collectionReusableViewForCollectionView:(UICollectionView*)collectionView
                                     fromNib:(UINib*)nib
                                forIndexPath:(NSIndexPath*)indexPath
                                    withKind:(NSString*)kind{
    
    NSString *cellIdentifier = [self cellIdentifier];
//    [collectionView registerClass:[self class] forSupplementaryViewOfKind:kind withReuseIdentifier:cellIdentifier];
//    [collectionView registerNib:nib forSupplementaryViewOfKind:kind withReuseIdentifier:cellIdentifier];
    PracticeInfoHeaderView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:cellIdentifier forIndexPath:indexPath];
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
    _cellIdentifier  = @"PracticeInfoHeaderView";
    
    return _cellIdentifier;
}

+(UINib*)nib{
    UINib * nib = [UINib nibWithNibName:@"PracticeDescriptionCustomView" bundle:nil];
    return nib;
}

- (void)  setUpFramesOnView{
    
    float xPos  =  0;
    float yPos  =  0;
    float horizontalGap = 15;
    float screenWidth  = [[UIScreen mainScreen] bounds].size.width; //CGRectGetWidth(self.frame);
    float contentLabelsWidth = screenWidth - (2 * xPos) - (2 * horizontalGap);
    float verticalGap =  5;
    float  normalHeight  =  20;
    
    
    
    [aboutPracticeInfoTitleLabel setFrame:CGRectMake(xPos, yPos +  verticalGap, contentLabelsWidth, normalHeight)];
    [aboutPracticeInfoTitleLabel setBackgroundColor:[UIColor whiteColor]];
    
    yPos  = CGRectGetMaxY(aboutPracticeInfoTitleLabel.frame) +  verticalGap;
    
    [establishedTitleLabel setFrame:CGRectMake(xPos, yPos , contentLabelsWidth, normalHeight)];
    yPos  = CGRectGetMaxY(establishedTitleLabel.frame) +  verticalGap;
    [establishedValuelabel setFrame:CGRectMake(xPos, yPos , contentLabelsWidth, normalHeight)];
    
    yPos  =  CGRectGetMaxY(establishedValuelabel.frame) +  verticalGap;
    [managementSystemTitleLabel  setFrame:CGRectMake(xPos, yPos , contentLabelsWidth, normalHeight)];
    yPos  = CGRectGetMaxY(managementSystemTitleLabel.frame) +  verticalGap;
    [managementSystemValueLabel setFrame:CGRectMake(xPos, yPos , contentLabelsWidth, normalHeight)];
    
    yPos  =  CGRectGetMaxY(managementSystemValueLabel.frame) +  verticalGap;
    [digitalXRaysTitleLabel  setFrame:CGRectMake(xPos, yPos , contentLabelsWidth, normalHeight)];
    yPos  = CGRectGetMaxY(digitalXRaysTitleLabel.frame) +  verticalGap;
    [digitalXRaysValueLabel setFrame:CGRectMake(xPos, yPos , contentLabelsWidth, normalHeight)];
    
    yPos  =  CGRectGetMaxY(digitalXRaysValueLabel.frame) +  verticalGap;
    [doctorsNumberTitleLabel  setFrame:CGRectMake(xPos, yPos , contentLabelsWidth, normalHeight)];
    yPos  = CGRectGetMaxY(doctorsNumberTitleLabel.frame) +  verticalGap;
    [doctorsNumberValueLabel setFrame:CGRectMake(xPos, yPos , contentLabelsWidth, normalHeight)];
    
    yPos  =  CGRectGetMaxY(doctorsNumberValueLabel.frame) +  verticalGap;
    [hygeneAppointmentTitleLabel  setFrame:CGRectMake(xPos, yPos , contentLabelsWidth, normalHeight)];
    yPos  = CGRectGetMaxY(hygeneAppointmentTitleLabel.frame) +  verticalGap;
    [hygeneAppointmentValueLabel setFrame:CGRectMake(xPos, yPos , contentLabelsWidth, normalHeight)];
    
    
    yPos  =  CGRectGetMaxY(hygeneAppointmentValueLabel.frame) +  verticalGap;
    [benefitsTitleLabel  setFrame:CGRectMake(xPos, yPos , contentLabelsWidth, normalHeight)];
    yPos  = CGRectGetMaxY(benefitsTitleLabel.frame) +  verticalGap;
    [benefitsValueLabel setFrame:CGRectMake(xPos, yPos , contentLabelsWidth, normalHeight)];
    
    yPos  =  CGRectGetMaxY(benefitsValueLabel.frame) +  verticalGap;
    [operatoriesCountTitleLabel  setFrame:CGRectMake(xPos, yPos , contentLabelsWidth, normalHeight)];
    yPos  = CGRectGetMaxY(operatoriesCountTitleLabel.frame) +  verticalGap;
    [operatoriesCountValueLabel setFrame:CGRectMake(xPos, yPos , contentLabelsWidth, normalHeight)];
    
    yPos  =  CGRectGetMaxY(operatoriesCountValueLabel.frame) +  verticalGap;
    [horizantalLineLabel  setFrame:CGRectMake(xPos, yPos , contentLabelsWidth, 1)];
    
    yPos  =  CGRectGetMaxY(horizantalLineLabel.frame) +  verticalGap;
    [practiceDescriptionTitleLabel  setFrame:CGRectMake(xPos, yPos , contentLabelsWidth, normalHeight)];
    yPos  = CGRectGetMaxY(practiceDescriptionTitleLabel.frame) +  verticalGap;
    [practiceDescriptionValueLabel setFrame:CGRectMake(xPos, yPos , contentLabelsWidth, normalHeight)];
    
    yPos  =  CGRectGetMaxY(practiceDescriptionValueLabel.frame) +  verticalGap;
    [horizantalLine2  setFrame:CGRectMake(xPos, yPos , contentLabelsWidth, 1)];
    
    yPos  =  CGRectGetMaxY(horizantalLine2.frame) +  verticalGap;
    [photosLabel  setFrame:CGRectMake(xPos, yPos , contentLabelsWidth, normalHeight)];
    
 }

@end
