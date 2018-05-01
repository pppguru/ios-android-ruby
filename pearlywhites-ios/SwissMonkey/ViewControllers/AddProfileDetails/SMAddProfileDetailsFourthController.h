//
//  SMAddProfileDetailsFourthController.h
//  MBXPageController
//
//  Created by Kasturi on 2/3/16.
//  Copyright (c) 2016 Moblox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAddProfileFourthVCModel.h"
#import "ELCImagePickerController.h"

@interface SMAddProfileDetailsFourthController : UIViewController<smAddProfileFourthVCModelDelegate,UITextFieldDelegate,UITextViewDelegate,RBAPopupDelegate, UIImagePickerControllerDelegate, ELCImagePickerControllerDelegate, UINavigationControllerDelegate,CustomAlertDelegate>
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *compensationPreferencesTextField;
@property (weak, nonatomic) IBOutlet UIView *compensationPreferenceBGView;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *expectedSalaryTextField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *toSalaryTextField;
@property (strong, nonatomic) IBOutlet PlaceHolderTextView *otherInfoTextView;
@property (strong, nonatomic) IBOutlet UIView *otherDescriptionView;
@property (strong, nonatomic) IBOutlet UIButton *uploadResumeButton;
@property (strong, nonatomic) IBOutlet UIButton *uploadLetterOfRecommendationButton;
- (IBAction)uploadResumeButtonAction:(id)sender;
- (IBAction)uploadLetterofRecomendationsButtonAction:(id)sender;
@property (nonatomic, readwrite) MediaType mediaType;

@property (strong, nonatomic) IBOutlet TYMProgressBarView *progressView;
@property (strong, nonatomic) IBOutlet UILabel *photosTitleLabel;
@property (strong, nonatomic) IBOutlet UIView *photosDisplayBGView;
@property (strong, nonatomic) IBOutlet UILabel *videosTitleLabel;
@property (strong, nonatomic) IBOutlet UIView *videosDisplayView;
@property (strong, nonatomic) IBOutlet UILabel *resumeTitleLabel;
@property (strong, nonatomic) IBOutlet UIView *resumeDisplayView;
@property (strong, nonatomic) IBOutlet UILabel *recommendationsTitleLabel;
@property (strong, nonatomic) IBOutlet UIView *recommendationsDisplayView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *termsAndServicesContainerView;
@property (weak, nonatomic) IBOutlet UITextView *textViewTermsAndServices;
@property (weak, nonatomic) IBOutlet UIView *agreeCheckboxContainerView;
@property (weak, nonatomic) IBOutlet UIButton *btnAgree;

// height constarignts  for photos and videos  display
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *photosTitleLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *photosDisplayViewheightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *videosTitleLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *videosDisplayViewheightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *resumeTitleLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *resumeDisplayViewheightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *recommendationTitleLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *recommendationDisplayViewheightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;

@end
