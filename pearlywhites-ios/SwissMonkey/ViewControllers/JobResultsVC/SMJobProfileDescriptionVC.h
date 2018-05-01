//
//  SMJobProfileDescriptionVC.h
//  SwissMonkey
//
//  Created by Kasturi on 1/28/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "SMJobProfileDescriptionModel.h"


#define JOBBUTTON_TAG  607
#define PRACTICEINFO_TAG 608

@interface SMJobProfileDescriptionVC : UIViewController<smJobProfileDescriptionDelegate,CustomAlertDelegate,MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *comapanyLogo;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainContactLabel;
@property (weak, nonatomic) IBOutlet UIButton *siteLinkButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *jobButton;
@property (weak, nonatomic) IBOutlet UIButton *practiceInfoButton;
@property (weak, nonatomic) IBOutlet UITableView *jobInfoTableView;
@property (weak, nonatomic) IBOutlet UIButton *jobProfileApplyNowButton;
@property (weak, nonatomic) IBOutlet UITableView *profileInfoTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *practiceInfoCollectionView;


@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) NSDictionary *jobDetails;

- (IBAction) siteLinkButtonAction: (id)sender;
- (IBAction) phoneCallButtonAction: (id)sender;
- (IBAction) emailButtonAction: (id)sender;
- (IBAction) applyNowButtonAction: (id)sender;
//- (IBAction)practiceInfoButtonAction:(id)sender;
//- (IBAction)jobButtonAction:(id)sender;

@end
