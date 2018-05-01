//
//  SMUserProfileDescriptionVC.h
//  SwissMonkey
//
//  Created by Kasturi on 1/22/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "SMHomeVC.h"
#import "SMUserProfileDescriptionModel.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface SMUserProfileDescriptionVC : SMHomeVC<SMUserprofileDescriptionModelDelegate,MFMailComposeViewControllerDelegate>{
    
    IBOutlet UIImageView *profilePicImageView;
    IBOutlet UILabel *profileNameLabel, *designationLabel, *addressLabel;
    IBOutlet UIButton *emailButton, *phoneNumButton;
    
    IBOutlet UIView *basicProfileContainerView, *buttonsContainerView;
    IBOutlet UIButton *aboutMeButton, *workButton;
    IBOutlet UITableView  *workTableView;
    __weak IBOutlet UIView *aboutMeContainerView;
    IBOutlet UICollectionView *aboutMeCollectionView;
    
    
    NSMutableArray *photosArray;

}

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *userContactViewHeightConstraint;





@end
