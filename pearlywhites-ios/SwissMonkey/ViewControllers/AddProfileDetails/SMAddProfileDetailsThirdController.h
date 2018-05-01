//
//  SMAddProfileDetailsThirdController.h
//  MBXPageController
//
//  Created by Kasturi on 2/3/16.
//  Copyright (c) 2016 Moblox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAddProfileThirdVCModel.h"

@interface SMAddProfileDetailsThirdController : UIViewController<smAddProfileThirdVCModelDelegate,UITextFieldDelegate,UITextViewDelegate,RBAMultiplePopupDelegate>

@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *jobTypeTextField;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField *workAvailabilityTextField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *workavailabilityDateTextFld;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextView *opportunitiesTextView;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextView *performanceManagementSkillsTextView;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextView *additionalSkillsTextView;
@property (strong, nonatomic) IBOutlet JVFloatLabeledTextField * languagesTextFld;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *otherPracticeSoftwareDescriptionTxtFld;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextView *specializedAssistantTriningTxtView;

@property (weak, nonatomic) IBOutlet UIView *jobTypeTextFieldBG;
@property (weak, nonatomic) IBOutlet UIView *workAvailabilityTextFieldBG;
@property (weak, nonatomic) IBOutlet UIView *workavailabilityDateTextFldBG;
@property (weak, nonatomic) IBOutlet UIView *opportunitiesTextViewBG;
@property (weak, nonatomic) IBOutlet UIView *performanceViewBG;
@property (weak, nonatomic) IBOutlet UIView *skillsViewBG;
@property (weak, nonatomic) IBOutlet UIView *specializedDentalViewBG;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *languagesFieldHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workavailabilityDateTextFieldHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewContraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherPracticeSoftwareExperienceHeightConstraight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *specializedAssTrainingHeightConstraint;

@property (strong, nonatomic) IBOutlet TYMProgressBarView *progressView;
@property (strong, nonatomic) IBOutlet UILabel *mornLabel;
@property (strong, nonatomic) IBOutlet UILabel *afterNoonLbel;
@property (strong, nonatomic) IBOutlet UILabel *eveningLabel;
@property (strong, nonatomic) IBOutlet UIButton *workDayButton;
@property (strong, nonatomic) IBOutlet UIView *workPreferencesView;

@property (weak, nonatomic) IBOutlet UIView *contentView;
- (IBAction)workDayButtonAction:(id)sender;

@end
