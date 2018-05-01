//
//  SMSearchVC.h
//  SwissMonkey
//
//  Created by Baalu on 3/11/16.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSearchModel.h"

@class SMJobResultsVC;

@interface SMSearchVC : UIViewController <SlideNavigationControllerDelegate>

- (IBAction)findNowButtonAction:(id)sender;
- (IBAction)advancedSearchButtonAction:(id)sender;
- (IBAction)positionPopUpButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *selectPositionContainerView;
@property (weak, nonatomic) IBOutlet UITextField *positionTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *locationTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *rangeTxtFld;
@property (weak, nonatomic) IBOutlet UIButton *popUpButton;
@property (weak, nonatomic) IBOutlet UIButton *rangeDecrementButton;
@property (weak, nonatomic) IBOutlet UIButton *rangeIncrementButton;
@property (weak, nonatomic) IBOutlet UIButton *findNowButton;

@property (nonatomic, retain) SMSearchModel *smSearchModel;
@property (weak, nonatomic)  UIButton *menuButton;
@property (weak , nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) UIActivityIndicatorView *progress;
@property (strong, nonatomic) SMJobResultsVC *smJobResultsVC;

// advanced search
@property (weak, nonatomic) IBOutlet customScrollView *advSearchScrollView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *positionContainerView;
@property (weak, nonatomic) IBOutlet UIView *experienceContainerView;
@property (weak, nonatomic) IBOutlet UIView *jobTypeContainerView;
@property (weak, nonatomic) IBOutlet UIView *compensationContainerView;

@property (weak, nonatomic) IBOutlet UILabel *compensationRangeLabel;
@property (weak, nonatomic) IBOutlet UIView *compensationRangeProgressView;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *rangeFromTxtFld;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *rangeToTxtFld;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *experienceTxtFld;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *jobTypeTxtFld;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *compensationTimingsTextFld;



//week day preferences
@property (weak, nonatomic) IBOutlet UIView *workDayPreferencesView;
@property (weak, nonatomic) IBOutlet UILabel *workDayPreferencesLabel;

@property (weak, nonatomic) IBOutlet UILabel *mornLabel;
@property (weak, nonatomic) IBOutlet UILabel *afternoonLabel;
@property (weak, nonatomic) IBOutlet UILabel *eveningLabel;

@property (weak, nonatomic) IBOutlet UIButton *daysButton;

// work  day preferences  constaints

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workDayPreferencesViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workDayPreferencesLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraignt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *compensationTimingsLabelHeightConstraint;

@property (strong, nonatomic) NSArray *jobs, *savedJobs;
- (void) navigate2ProfileVC;

-(void)updatedUIFindNowButton;

@end
