//
//  SMAddProfileDetailsFirstController.h
//  MBXPageController
//
//  Created by Kasturi on 2/3/16.
//  Copyright (c) 2016 Moblox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerController.h"
#import "ASIFormDataRequest.h"


@interface SMAddProfileDetailsFirstController : UIViewController<UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, ELCImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    int totalUploadedFieldsCount, requiredFieldsCount;
}

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *nameTextField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *addressLine1TextField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *addressLine2TextField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *cityTextField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *stateTextField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *zipTextField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *emailTextField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *phoneNumberTextField;

@property (weak, nonatomic) IBOutlet UIView *aboutMeBGView;

@property (weak, nonatomic) IBOutlet UIButton *uploadPhotosButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadVideosButton;
@property (weak, nonatomic) IBOutlet UIButton *profilePicture;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutMeLabel;

@property (weak, nonatomic) IBOutlet TYMProgressBarView *progressBarView;

@property (nonatomic, readwrite) NSInteger imagesCount, videosCount, profilePictureCount;
@property (nonatomic, readwrite) MediaType mediaType;
@property (weak, nonatomic) IBOutlet PlaceHolderTextView *aboutMeTextView;
//@property (nonatomic, strong) NSMutableArray *arrayProfileImages;
@property (nonatomic, strong) WebServiceCalls *serverCall;

- (IBAction)uploadPhotosButton:(id)sender;
- (IBAction)uploadVideosButtonAction:(id)sender;
- (IBAction)uploadUserProfileImageButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;

@property (nonatomic, strong) NSMutableArray *compleatedFieldsArray;

@property (strong, nonatomic) IBOutlet UILabel *photosTitleLabel;
@property (strong, nonatomic) IBOutlet UIView *photosDisplayBGView;
@property (strong, nonatomic) IBOutlet UILabel *videosTitleLabel;
@property (strong, nonatomic) IBOutlet UIView *videosDisplayView;

// height constarignts  for photos and videos  display
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *photosTitleLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *photosDisplayViewheightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *videosTitleLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *videosDisplayViewheightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *changeEmailButton;

- (IBAction)changeEmailButtonAction:(id)sender;


@end
