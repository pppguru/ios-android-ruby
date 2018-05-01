//
//  SMAddProfileDetailsSecondController.h
//  MBXPageController
//
//  Created by Kasturi on 2/3/16.
//  Copyright (c) 2016 Moblox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAddProfileSecondVCModel.h"

@interface SMAddProfileDetailsSecondController : UIViewController<smAddProfileSecondVCModelDelegate,UITextFieldDelegate,RBAPopupDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *seekingPositionTextField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *experienceTextField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *boardCertifiedTextField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *licenceNumberTextField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *selectStatesTextField;
@property (weak, nonatomic) IBOutlet UIButton *seekingPositionButton;
@property (weak, nonatomic) IBOutlet UIView *seekingPositionButtonBGView;
@property (weak, nonatomic) IBOutlet UIButton *experienceButton;
@property (weak, nonatomic) IBOutlet UIView *experienceButtonBGView;
@property (weak, nonatomic) IBOutlet UIButton *boardCertifiedButton;
@property (weak, nonatomic) IBOutlet UIView *boardCertificatedButtonBGView;
@property (weak, nonatomic) IBOutlet UILabel *licenceNoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *expiresLabel;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *monthTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearTextField;
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;
@property (weak, nonatomic) IBOutlet UILabel *verifyLabel;
@property (weak, nonatomic) IBOutlet UIButton *statesListButton;
@property (weak, nonatomic) IBOutlet UIView *statesListButtonBGView;
@property (weak, nonatomic) IBOutlet TYMProgressBarView *progressView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;

- (IBAction)seekingPositionButtonAction:(id)sender;
- (IBAction)boardCertifiedButtonAction:(id)sender;
- (IBAction)experienceButtonAction:(id)sender;
- (IBAction)verifyButtonAction:(id)sender;
- (IBAction)statesListButtonAction:(id)sender;





@end
