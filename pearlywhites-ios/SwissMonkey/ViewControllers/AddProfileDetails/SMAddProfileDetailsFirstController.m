//
//  SMAddProfileDetailsFirstController.m
//  MBXPageController
//
//  Created by Kasturi on 2/3/16.
//  Copyright (c) 2016 Moblox. All rights reserved.
//

#import "SMAddProfileDetailsFirstController.h"
#import "SMProfileModel.h"
#import "ELCImagePickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ASIFormDataRequest.h"
#import "CircleLoaderView.h"
#import <AVFoundation/AVFoundation.h>
#import "SMUserPicturesVideosDisplayVC.h"
#import "SMScreenTitleButtonsVC.h"
#import "UIButton+BackgroundContentMode.h"

@interface SMAddProfileDetailsFirstController ()<SMProfileModelDelegate, CustomAlertDelegate>{
    SMProfileModel *profileModel;
    BOOL isActionSheetOpened;
    BOOL isCamera;
    NSMutableDictionary *textFieldsData;
}

@end

@implementation SMAddProfileDetailsFirstController

@synthesize nameTextField,addressLine1TextField,addressLine2TextField,cityTextField,stateTextField,zipTextField,emailTextField,phoneNumberTextField,aboutMeBGView,aboutMeLabel,aboutMeTextView,uploadPhotosButton,uploadVideosButton,infoLabel,progressBarView,contentViewHeightConstraint, compleatedFieldsArray,photosTitleLabelHeightConstraint,photosDisplayViewheightConstraint,videosTitleLabelHeightConstraint,videosDisplayViewheightConstraint,photosDisplayBGView,videosDisplayView;



- (void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self updatePhotosVideosConstraights];

    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    
    float width = CGRectGetWidth(_profilePicture.frame);
     float heght = CGRectGetHeight(_profilePicture.frame);
    
    float cornerRadius = CGRectGetWidth(_profilePicture.frame) /2 ;
    _profilePicture.layer.cornerRadius =  cornerRadius ;
    _profilePicture.layer.masksToBounds = YES;
}

- (void) updatePhotosVideosConstraights{
    float horizantalGap  =  20;
    float screenWidth  =  [UIScreen mainScreen].bounds.size.width;
    float viewWidth  = ((screenWidth - 40)- (2 * horizantalGap) )/3;
    
    //Getting the urls from profile info dictionary instead of ID.
    
    if ([[[ReusedMethods userProfile] valueForKey:@"image_url"] count] == 0) {
        photosTitleLabelHeightConstraint.constant = 0;
        photosDisplayViewheightConstraint.constant = 0;
    }else{
        photosTitleLabelHeightConstraint.constant = 21;
        photosDisplayViewheightConstraint.constant =  [[[ReusedMethods userProfile] valueForKey:@"image_url"] count] > 3 ? viewWidth * 2 : viewWidth;
    }
    
    if ([[[ReusedMethods userProfile] valueForKey:@"video_url"] count] == 0) {
        videosTitleLabelHeightConstraint.constant = 0;
        videosDisplayViewheightConstraint.constant = 0;
    }else{
        videosTitleLabelHeightConstraint.constant = 21;
        videosDisplayViewheightConstraint.constant = viewWidth;
    }
    
    
    [self.contentView  layoutSubviews];
    [self.contentView updateConstraints];
    contentViewHeightConstraint.constant  =  CGRectGetMaxY(infoLabel.frame) + CGRectGetHeight(progressBarView.frame) + 50 ;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isCamera = NO;
    
    textFieldsData = [[NSMutableDictionary alloc] init];
    
    // Do any additional setup after loading the view.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:@"firstTime"];
    [userDefaults synchronize];
    
    // Setting notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(profileUpdateNotificationForCurrentVC)
                                                 name:@"profileUpdateNotificationForCurrentVC" object:nil];
    
    nameTextField.delegate = self;
    addressLine1TextField.delegate = self;
    addressLine2TextField.delegate = self;
    cityTextField.delegate = self;
    stateTextField.delegate = self;
    zipTextField.delegate = self;
    emailTextField.delegate = self;
    phoneNumberTextField.delegate = self;
    aboutMeTextView.delegate = self;
    
//    emailTextField.enabled = NO;
//    emailTextField.textColor = [UIColor appLightGrayColor];
    
    //  Set text color for infolabel of upload videos
    [infoLabel setTextColor:[UIColor appLightGrayColor]];
    
    [self setupTagsForTextFields];
    
    profileModel = [[SMProfileModel alloc] init];
    [profileModel setDelegate:self];
    if(![[ReusedMethods sharedObject] userProfileInfo])
        [profileModel callProfileDataAPICall];
    else
        [self updateUI:[[ReusedMethods sharedObject] userProfileInfo]];
    _serverCall = [[WebServiceCalls alloc] init];
    
    // updateProgressBarValue
    progressBarView.progress  =  [ReusedMethods profileProgresValue] ;
    
    
   // [SMSharedFilesClass setProfilePicture2Button:_profilePicture];
    [profileModel createExpandableView];
    
    
   // [profileModel displayThumbNailsImagesOnView:photosDisplayBGView];
    //[profileModel displayThumbNailsImagesOnView:videosDisplayView];
    //[self  updatePhotosVideosConstraights];
    
   // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [profileModel setUPThumbNailsOnView:photosDisplayBGView ofCount:kMAXIMAGES];
        [profileModel setUPThumbNailsOnView:videosDisplayView ofCount:kMAXVIDEOS];
        [SMSharedFilesClass setProfilePicture2Button:_profilePicture];
        [profileModel displayThumbNailsImagesOnView:photosDisplayBGView];
        [profileModel displayThumbNailsImagesOnView:videosDisplayView];
        //Do background work
       // dispatch_async(dispatch_get_main_queue(), ^{
            //Update UI
            [self  updatePhotosVideosConstraights];
        //});
    //});

    
    [[[ReusedMethods sharedObject] userProfileInfo] removeObjectForKey:NEW_EMAIL];
    
//    CGFloat height   =  [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    height  =  MAX(height, CGRectGetMaxY(progressBarView.frame));
//    contentViewHeightConstraint.constant  =  height;
    
   // [self.contentView setNeedsDisplay];
    
    //Update the profile image content mode
    [self.profilePicture setBackgroundContentMode:UIViewContentModeScaleAspectFill];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(isActionSheetOpened == 1){
        
        if (isCamera == NO)
        {
        
       // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self addLoader];
            [SMSharedFilesClass setProfilePicture2Button:_profilePicture];
            [profileModel displayThumbNailsImagesOnView:photosDisplayBGView];
            [profileModel displayThumbNailsImagesOnView:videosDisplayView];

            //Do background work
           // dispatch_async(dispatch_get_main_queue(), ^{
                //Update UI
                [self  updatePhotosVideosConstraights];
                [self performSelector:@selector(removeLoader) withObject:nil afterDelay:0.5];

           // });
        //});
        }
        isCamera = YES;
        
    }
    
    nameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
}

- (void) addLoader{
    [CircleLoaderView addToWindow];
}

- (void) removeLoader{
    [CircleLoaderView removeFromWindow];
}

- (void) setupTagsForTextFields{
    
    nameTextField.returnKeyType  =  UIReturnKeyNext;
    addressLine1TextField.returnKeyType  = UIReturnKeyNext;
    addressLine2TextField.returnKeyType  =  UIReturnKeyNext;
    cityTextField.returnKeyType  =  UIReturnKeyNext;
    stateTextField.returnKeyType  =  UIReturnKeyNext;
    zipTextField.returnKeyType  = UIReturnKeyNext;
    phoneNumberTextField.returnKeyType  =  UIReturnKeyNext;
    
    nameTextField.tag  =  PROFILE_NAME_TEXTFIELD_TAG;
    addressLine1TextField.tag  = PROFILE_ADDRESSLINE1_TEXTFIELD_TAG;
    addressLine2TextField.tag  =  PROFILE_ADDRESSLINE2_TEXTFIELD_TAG;
    cityTextField.tag  =  PROFILE_CITY_TEXTFIELD_TAG;
    stateTextField.tag  =  PROFILE_STATE_TEXTFIELD_TAG;
    zipTextField.tag  = PROFILE_ZIP_TEXTFIELD_TAG;
    phoneNumberTextField.tag  =  PROFILE_PHOE_NUMBER_TEXTFIELD_TAG;
    emailTextField.tag  = PROFILE_EMAIL_TEXTFIELD_TAG;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    textField.text = text;
    
    if(textField  == phoneNumberTextField){
        int length = (int)[self getLength:textField.text];
            //NSLog(@"Length  =  %d ",length);
            
            if(length == 10)
            {
                if(range.length == 0)
                    return NO;
            }
            
            if(length == 3)
            {
                NSString *num = [self formatNumber:textField.text];
                textField.text = [NSString stringWithFormat:@"(%@) ",num];
                
                if(range.length > 0)
                    textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
            }
            else if(length == 6)
            {
                NSString *num = [self formatNumber:textField.text];
                //NSLog(@"%@",[num  substringToIndex:3]);
                //NSLog(@"%@",[num substringFromIndex:3]);
                textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
                
                if(range.length > 0)
                    textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
            }
        
        [[[ReusedMethods sharedObject] userProfileInfo] setObject:[textField.text stringByAppendingString:string] forKey:PHONE_NUMBER];
        
        [textFieldsData setObject:[textField.text stringByAppendingString:string] forKey:PHONE_NUMBER];
        return YES;

    }
    //City and State field restricted to enter only strings
    if (  (textField == cityTextField)  ||  (textField == stateTextField)   )
    {
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "];
        
        for (int i = 0; i < [string length]; i++) {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c]) {
                return NO;
            }
        }
    }
    NSString *key = nil;
    if(textField == nameTextField)
        key = NAME;
    else if(textField == addressLine1TextField)
        key = ADDRESSLINE1;
    else if(textField == addressLine2TextField)
        key = ADDRESSLINE2;
    else if(textField == cityTextField)
        key = CITY;
    else if(textField == stateTextField)
        key = STATE;
    else if(textField == zipTextField)
        key = ZIP;
    else if(textField == emailTextField && emailTextField.enabled  == NO)
        key = EMAIL;
    else if(textField == phoneNumberTextField)
        key = PHONE_NUMBER;
    else if (textField  == emailTextField && emailTextField.enabled == YES)
        key = NEW_EMAIL;
    
    UITextPosition *beginning = textField.beginningOfDocument;
    UITextPosition *start = [textField positionFromPosition:beginning offset:range.location];
    UITextPosition *end = [textField positionFromPosition:start offset:range.length];
    UITextRange *textRange = [textField textRangeFromPosition:start toPosition:end];
    
    // this will be the new cursor location after insert/paste/typing
    NSInteger cursorOffset = [textField offsetFromPosition:beginning toPosition:start] + string.length;
    
    // now apply the text changes that were typed or pasted in to the text field
    [textField replaceRange:textRange withText:string];
    
    // now go modify the text in interesting ways doing our post processing of what was typed...
    NSString *text = [textField.text mutableCopy];
    // ... etc
    
    // now update the text field and reposition the cursor afterwards
    textField.text = text;
    UITextPosition *newCursorPosition = [textField positionFromPosition:textField.beginningOfDocument offset:cursorOffset];
    UITextRange *newSelectedRange = [textField textRangeFromPosition:newCursorPosition toPosition:newCursorPosition];
    [textField setSelectedTextRange:newSelectedRange];
    
    if([key isEqualToString:EMAIL]  ||  [key isEqualToString:NEW_EMAIL])
        text = [SMValidation removeUnwantedSpaceForString:text];
    
//    NSLog(@"%@ : %@", key, text);n
    [[[ReusedMethods sharedObject] userProfileInfo] setObject:text forKey:key];
    [textFieldsData setObject:text forKey:key];
    
    if (textField != emailTextField) {
        [ReusedMethods setCapitalizationForFirstLetterOfField:textField];
    }

    if (textField == stateTextField){
        textField.text = [textField.text uppercaseString];
    }
    
    return NO;
}

//- (void) textViewDidBeginEditing:(UITextView *)textView{
//    textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
//}


- (int)getLength:(NSString *)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = (int)[mobileNumber length];
    
    return length;
}


- (NSString *)formatNumber:(NSString *)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSLog(@"%@", mobileNumber);
    
    int length = (int)[mobileNumber length];
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
        
    }
    
    return mobileNumber;
}


- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    UITextPosition *beginning = textView.beginningOfDocument;
    UITextPosition *start = [textView positionFromPosition:beginning offset:range.location];
    UITextPosition *end = [textView positionFromPosition:start offset:range.length];
    UITextRange *textRange = [textView textRangeFromPosition:start toPosition:end];
    
    // this will be the new cursor location after insert/paste/typing
    NSInteger cursorOffset = [textView offsetFromPosition:beginning toPosition:start] + text.length;
    
    // now apply the text changes that were typed or pasted in to the text field
    [textView replaceRange:textRange withText:text];
    
    // now go modify the text in interesting ways doing our post processing of what was typed...
    NSString *t = [textView.text mutableCopy];
    // ... etc
    
    // now update the text field and reposition the cursor afterwards
    textView.text = t;
    UITextPosition *newCursorPosition = [textView positionFromPosition:textView.beginningOfDocument offset:cursorOffset];
    UITextRange *newSelectedRange = [textView textRangeFromPosition:newCursorPosition toPosition:newCursorPosition];
    [textView setSelectedTextRange:newSelectedRange];
    
//    NSString *string = [textView.text stringByReplacingCharactersInRange:range withString:text];
//    textView.text = string;
    [[[ReusedMethods sharedObject] userProfileInfo] setObject:textView.text forKey:ABOUTME];
    
    [textFieldsData setObject:textView.text forKey:ABOUTME];
    
    [ReusedMethods setCapitalizationForFirstLetterOfField:textView];

    
    return NO;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Update UI Methods

- (void) updateUI:(NSDictionary *)profileInfo{
    
    nameTextField.text = [ReusedMethods capitalizedString:[profileInfo objectForKey:NAME]];
    addressLine1TextField.text = [profileInfo objectForKey:ADDRESSLINE1];
    addressLine2TextField.text = [profileInfo objectForKey:ADDRESSLINE2];
    cityTextField.text = [profileInfo objectForKey:CITY];
    stateTextField.text = [[profileInfo objectForKey:STATE] uppercaseString];
    zipTextField.text = [profileInfo objectForKey:ZIP];
    emailTextField.text = [profileInfo objectForKey:EMAIL];
    phoneNumberTextField.text = [profileInfo objectForKey:PHONE_NUMBER];
    aboutMeTextView.text = [profileInfo objectForKey:ABOUTME];
    
//    NSMutableArray *arrayImages = [[NSMutableArray alloc] init];
    
    //    [ReusedMethods setProfileImages:arrayImages];
    //    [_arrayProfileImages removeAllObjects];
    //    _arrayProfileImages = [[NSMutableArray alloc] initWithArray:[ReusedMethods profileImages]];
    //    for (NSString *strPath in _arrayProfileImages) {
    //    }
}

- (void) updateUI{
   
    [ReusedMethods applyShadowToView:aboutMeBGView];
    
    [ReusedMethods applyBlueButtonStyle:self.uploadPhotosButton];
    [ReusedMethods applyBlueButtonStyle:self.uploadVideosButton];

    aboutMeTextView.placeholder = @"Use this space to tell us more about you.\nFor example what makes you unique, your ideal job or why you chose your profession.";//You may also share any advanced training or practice management skills or courses you have taken.";
    
    NSString * infoText  = @"Show employers what makes you unique! Some example of video topics include: why you chose this field, a short bio/intro, patient education lesson, treatment planning presentation or even patient testimonials.\nVideos cannot exceed 3 minutes.";
    
    [infoLabel setText:infoText];
   
}



#pragma mark - IBAction Methods

- (IBAction)uploadPhotosButton:(id)sender {
    isActionSheetOpened = 1;
    [self.view endEditing:YES];
    [self.contentView endEditing:YES];
    
    _imagesCount = [[[ReusedMethods userProfile] objectForKey:@"image"]count];//[SMSharedFilesClass listFileAtPath:[SMSharedFilesClass profileImagesPath]];
    if(_imagesCount < kMAXIMAGES){
        
        if([ReusedMethods isPermissionGranted]) {
            _mediaType = imageType;
            UIActionSheet *popup = [SMSharedFilesClass actionSheetWithDelegate:self];
            [popup showInView:self.view];
        }
        else{
            [ReusedMethods showPermissionRequiredAlert];
        }
    }
    else{
        [[[RBACustomAlert alloc] initWithTitle:[NSString stringWithFormat:@"Already uploaded %i images", kMAXIMAGES] message:@"Please remove existing image to upload new image from below." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

- (IBAction)uploadVideosButtonAction:(id)sender {
    isActionSheetOpened = 1;
    [self.view endEditing:YES];
    [self.contentView endEditing:YES];

    _videosCount =  [[[ReusedMethods userProfile] objectForKey:@"video"]count];//[SMSharedFilesClass listFileAtPath:[SMSharedFilesClass profileVideosPath]];
    if(_videosCount < kMAXVIDEOS){
        if([ReusedMethods isPermissionGranted]) {
            _mediaType = videoType;
            UIActionSheet *popup = [SMSharedFilesClass actionSheetWithDelegate:self];
            [popup showInView:self.view];
        }
        else{
            [ReusedMethods showPermissionRequiredAlert];
        }
    }
    else{
        [[[RBACustomAlert alloc] initWithTitle:[NSString stringWithFormat:@"Already uploaded %i videos", kMAXVIDEOS] message:@"Please remove existing video to upload new Video from below." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
//    [self allocImagePickerController:2];
}


- (IBAction)uploadUserProfileImageButtonAction:(id)sender {
    isActionSheetOpened = 1;
    [self.view endEditing:YES];
    if([ReusedMethods isPermissionGranted]) {
        _profilePictureCount =  [[[ReusedMethods userProfile] valueForKey:@"profile_url"] length] ? 1 : 0; //[SMSharedFilesClass listFileAtPath:[SMSharedFilesClass profilePicturePath]];
        if(kMAXPPICTURES > _profilePictureCount){
            _mediaType = pictureType;
            UIActionSheet *popup = [SMSharedFilesClass actionSheetWithDelegate:self];
            [popup showInView:self.view];
        }
        else{
          RBACustomAlert * alert =  [[RBACustomAlert alloc] initWithTitle:@"Already uploaded your profile picture" message:@"Do you want to change it?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alert setTag:PROFILE_PHOTO_UPDATE_TAG];
            [alert show];
        }
    }
    else{
        [ReusedMethods showPermissionRequiredAlert];
    }
}

#pragma mark - UIActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    // do your logic
    if(buttonIndex == 0){
        isCamera = YES;
        if(_mediaType == imageType || _mediaType == pictureType)
            [self openAlubmVC];
        else
            [self allocImagePickerController:2];
    }
    else if(buttonIndex == 1){
        isCamera = YES;
        //        if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]){
        [self openCamera];
        //        }
    }
}

- (void) openCamera{
    [self allocImagePickerController:1];
}

- (void) allocImagePickerController:(int) tag{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//        picker.view.tag = tag;
        picker.delegate = self;
        if(tag == 1)
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        else
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if(_mediaType == videoType)
            picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (void) openAlubmVC{
    //    NSInteger images = [ReusedMethods listFileAtPath:[ReusedMethods profileImagesPath]];
    //    if(images < kMAXIMAGES){
    NSInteger max = 0;
    
    if(_mediaType == imageType){
        max = kMAXIMAGES - _imagesCount;
    }
    else if(_mediaType == videoType){
        max = kMAXVIDEOS - _videosCount;
    }
    else{
        max = kMAXPPICTURES - _profilePictureCount;
    }
    
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    elcPicker.maximumImagesCount = max;//kMAXVIDEOS - _videosCount; //Set the maximum number of images to select, defaults to 5
    if(_mediaType == videoType)
        elcPicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
    
//    elcPicker.returnsImage = ( _mediaType == imageType );
    elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return selected order of images
    elcPicker.imagePickerDelegate = self;
    
    //Present modally
    [self presentViewController:elcPicker animated:YES completion:nil];
    //    }
}

- (void) setImage2ProfilePicture:(id)sender{
    if([sender isKindOfClass:[UIImage class]]){
        NSArray *images = [SMSharedFilesClass allFilesAtPath:[SMSharedFilesClass profilePicturePath]];
        [SMSharedFilesClass removeAllObjectAtPath:images type:_mediaType];
        [_profilePicture setBackgroundImage:(UIImage *)sender forState:UIControlStateNormal];
        //[_profilePicture setImage:nil forState:UIControlStateNormal];
    }
}

#pragma mark - ELCImagePickerController Delegate

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
//    [ReusedMethods setProfileImages:nil];
    
        for (NSDictionary *imageDict in info){
//            if (_propertyType == 2){
//                
//            }
//            else{
            UIImage *image = [imageDict objectForKey:UIImagePickerControllerOriginalImage];
            [self saveImage:image];
            
            if(_mediaType == pictureType){
                [self setImage2ProfilePicture:image];
            }
//            }
            //        [_arrayProfileImages addObject:[ReusedMethods dateFromImage:image]];
        }
        
//    [_arrayProfileImages addObjectsFromArray:info];
//    [ReusedMethods setProfileImages:_arrayProfileImages];
//    [self sendAllFiles:_arrayProfileImages];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self uploadFiles];
}



- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    isActionSheetOpened  = 0;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //    if(picker.view.tag == 1){
    //        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //        NSLog(@"%@", image);
    //    }
    //    else{
//    [ReusedMethods setProfileImages:nil];
//    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //NSLog(@"type=%@",type);
    if (_mediaType == videoType)
    {
        [CircleLoaderView addToWindow];
        NSURL *urlvideo = [info objectForKey:UIImagePickerControllerMediaURL];
        
        //        NSString *strUrl = [urlvideo lastPathComponent];
        //
        //        NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:@"" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        //
        //            // video
        AVURLAsset *sourceAsset = [AVURLAsset URLAssetWithURL:urlvideo options:nil];
        CMTime duration = sourceAsset.duration;
        float seconds = CMTimeGetSeconds(duration);
        NSLog(@"\nduration.value : %f", seconds);
//        if(duration.value)
        if(kMAXVIDEOTIME > seconds){

            NSData *videoData = [NSData dataWithContentsOfURL:urlvideo];
            [self saveVideo:videoData fileName:[urlvideo lastPathComponent] videoURL:urlvideo];
            NSLog(@"Video url : %@", urlvideo);
        }
        else{
            [[[RBACustomAlert alloc] initWithTitle:@"Exceeded the duration time limit" message:[NSString stringWithFormat:@"Please make sure that your video should not exceed %i minutes", kMAXVIDEOTIME / 60] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
            [self performSelector:@selector(removeLoader) withObject:nil afterDelay:0.5];
        }
    }
    else
    {
//        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//        NSString *savedFileAtPath = [ReusedMethods saveImageAtDocumentoryPath:image withName:nil];
//        [_arrayProfileImages addObject:savedFileAtPath];
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self saveImage:image];
        if(_mediaType == pictureType){
            [self setImage2ProfilePicture:image];
        }
//        NSString *savedFileAtPath = [ReusedMethods saveImageAtDocumentoryPath:image withName:[NSString stringWithFormat:@"image%@%ld", [ReusedMethods authToken], _arrayProfileImages.count] needExtension:YES];
//        [_arrayProfileImages addObject:savedFileAtPath];
//        [ReusedMethods setProfileImages:_arrayProfileImages];
//        NSLog(@"%@", image);
        
        [self uploadFiles];

    }
    //    }
//    [self sendAllFiles:_arrayProfileImages];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //[self uploadFiles];
}

// generate thumbnail  of video  and  save  it  to documents  to send

-(UIImage *)generateThumbImage : (NSURL *)filepath
{
    NSURL *url = filepath;//[NSURL fileURLWithPath:filepath];
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    CMTime time = [asset duration];
    time.value = 0;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    
    return thumbnail;
}



- (void) uploadFiles{
    NSArray *navCons = [self.navigationController viewControllers];
    for (UIViewController *con in navCons)
    {
        if ([con isKindOfClass:[SMScreenTitleButtonsVC class]])
        {
            [(SMScreenTitleButtonsVC *)con uploadImages];
            break;
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    isActionSheetOpened  = 0;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//- (void)requestFinished:(ASIHTTPRequest *)request
//{
//    NSString *str = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
//    NSLog(@"Success: %@", str);
//    [self moveAllTempFiles2images];
//    [CircleLoaderView removeFromWindow];
//}
//
//- (void)requestFailed:(ASIHTTPRequest *)request
//{
////    NSString *str = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
//    NSLog(@"Failed: %@", request.error);
//    [CircleLoaderView removeFromWindow];
//}

- (void) sendAllFiles:(NSMutableArray *)arrayImages
{
//    [CircleLoaderView addToWindowWithCircleColor:[UIColor appGreenColor] arcColor:[UIColor appWhiteColor]];
    
//    _serverCall.keyType = _mediaType == imageType ? k_IMG_FILES_KEY : k_VDI_FILES_KEY;
//    [_serverCall performSelector:@selector(makeServerCallForFiles:) withObject:self afterDelay:1.0];
}

- (void) saveImage:(UIImage *)image{
    
    NSString *file = [ReusedMethods GUID];
    
    if(_mediaType == pictureType){
        NSString *profilePath = [SMSharedFilesClass profileTempPicturePath];
        
        NSArray *images = [SMSharedFilesClass allFilesAtPath:profilePath];
        for (NSString *name in images) {
            NSString *filePath = [profilePath stringByAppendingPathComponent:name];
            [self removeFileAtPath:filePath];
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[ReusedMethods userProfile]];
        [dict setObject:file forKey:@"profile"];
        [ReusedMethods setUserProfile:dict];
        
        NSString * mediaString  = [SMSharedFilesClass  keyForMedia:_mediaType];
        
        profilePath = [SMSharedFilesClass profilePicturePath];
        images = [SMSharedFilesClass allFilesAtPath:profilePath];
        for (NSString *name in images) {
            
            NSMutableDictionary *  dict  =  [[NSMutableDictionary alloc] init];
            [dict setObject:mediaString forKey:@"type"];
            [dict setObject:name forKey:@"file"];
            
            APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_DELETE ModuleName:MODULE_PROFILE MethodType:METHOD_TYPE_POST Parameters:dict SuccessCallBack:@selector(fileDeleteSuccessResponseCall:) AndFailureCallBack:@selector(fileDeleteFailResponseCall:)];
            
            WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
            service.mediaType  = _mediaType;
            [service makeWebServiceCall];
            
            NSString *filePath = [profilePath stringByAppendingPathComponent:name];
            [self removeFileAtPath:filePath];
        }
    }
    
    [SMSharedFilesClass saveImageAtDocumentoryPath:image withName:file needExtension:YES mediaType:_mediaType];
//    [_arrayProfileImages addObject:savedFileAtPath];
}

- (void) fileDeleteSuccessResponseCall:(NSDictionary *)profileInfo{
    
    NSLog(@"Profile Info : %@", profileInfo);
}

- (void) fileDeleteFailResponseCall:(NSDictionary *)profileInfo{
    
}

- (void) removeFileAtPath:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if([fileManager fileExistsAtPath:filePath])
        [fileManager removeItemAtPath:filePath error:&error];
    if(error){
        NSLog(@"Error removing file at Path : %@", filePath);
    }
    else
        NSLog(@"File removed at Path : %@", filePath);
}

- (void) saveVideo:(NSData *)videoData fileName:(NSString *)fileName videoURL:(NSURL *) videoUrl {
    NSString *  guid  =  [ReusedMethods GUID];
    NSString *ext = [[fileName componentsSeparatedByString:@"."] lastObject];
    ext = @"MP4";
    NSString *nameWithExt = [NSString stringWithFormat:@"%@.%@", guid, ext];

    
    // Create the asset url with the video file
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:videoUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    // Check if video is supported for conversion or not
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality])
    {
        //Create Export session
        AVAssetExportSession *exportSession = [[AVAssetExportSession       alloc]initWithAsset:avAsset presetName:AVAssetExportPresetLowQuality];
        
        //Creating temp path to save the converted video
       // NSString* documentsDirectory=     [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        //NSString* savedImagePath= [documentsDirectory stringByAppendingPathComponent:@"temp.mp4"];
        
        
        
        
        NSString *savedImagePath = [SMSharedFilesClass tempPathForKey:_mediaType];
        
        int random = rand() % 10000;
        
        NSError *error = nil;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:savedImagePath]){
            [[NSFileManager defaultManager] createDirectoryAtPath:savedImagePath withIntermediateDirectories:YES attributes:nil error:&error]; //Create folder
            [SMSharedFilesClass addSkipBackupAttributeToItemAtPath:savedImagePath];
            //        [self addSkipBackupAttributeToItemAtPath:[self profileImagesPath]];
        }
       // savedImagePath = [savedImagePath stringByAppendingPathComponent:name];
        
       // NSString *savedImagePath = [SMSharedFilesClass tempPathForKey:_mediaType];
        savedImagePath = [savedImagePath stringByAppendingPathComponent:[NSString  stringWithFormat:@"%@",nameWithExt]];
        NSURL *url = [[NSURL alloc] initFileURLWithPath:savedImagePath];
        
        //Check if the file already exists then remove the previous file
        if ([[NSFileManager defaultManager]fileExistsAtPath:savedImagePath])
        {
            [[NSFileManager defaultManager]removeItemAtPath:savedImagePath error:nil];
        }
        exportSession.outputURL = url;
        //set the output file format if you want to make it in other file format (ex .3gp)
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status])
            {
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"Export session failed");
                    break;
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Export canceled");
                    break;
                case AVAssetExportSessionStatusCompleted:
                {
                    //Video conversion finished
                    NSLog(@"Successful!");
                    [self uploadFiles];

                    
                    
                }
                    break;
                default:
                    break;
            }
        }];
    }
    else
    {
        NSLog(@"Video file not supported!");
    }
    
   // [SMSharedFilesClass saveImageAtDocumentoryPath:videoData withName:nameWithExt needExtension:NO mediaType:_mediaType];
    UIImage *  thumbNailImage  =  [self  generateThumbImage:videoUrl];
    [SMSharedFilesClass saveImageAtDocumentoryPath:thumbNailImage withName:guid needExtension:YES mediaType:videoThumbnailType];
}

- (void) alertView:(RBACustomAlert *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1 && alertView.tag != PROFILE_PHOTOS_DISPLAY_BGVIEW_TAG && alertView.tag != PROFILE_VIDEOS_DISPLAY_BGVIEW_TAG){
        _mediaType = pictureType;
        _profilePictureCount = 0;
        UIActionSheet *sheet = [SMSharedFilesClass actionSheetWithDelegate:self];
        [sheet showInView:self.view];
    }
    else if (buttonIndex  == [alertView cancelButtonIndex]) {
        
        _mediaType  =  [self  getMediaTypeWithAlertTag:alertView.tag]; //  (alertView.tag  == PROFILE_PHOTOS_DISPLAY_BGVIEW_TAG ) ? imageType : videoType ;
        
        [self deleteDataFileFromServerAtIndexPath:profileModel.selectedDeleteObjectIndexPath];
    }

}

#pragma  mark  - SERVER DELEGATE METHODS

- (void) showErrorMessages:(NSString *) error{
    
}
- (void) successResponseCall:(NSDictionary *)profileInfo{
    
}


- (void)deleteSelectedImage{
    [self displayDeleteAlertWithString:@"Are you sure, you want to delete this image?" andtag:PROFILE_PHOTOS_DISPLAY_BGVIEW_TAG];
}
- (void)deleteSelectedVideo{
    [self displayDeleteAlertWithString:@"Are you sure, you want to delete this video?" andtag:PROFILE_VIDEOS_DISPLAY_BGVIEW_TAG];
}
- (void) deleteSelectedResume{
    [self displayDeleteAlertWithString:@"Are you sure, you want to delete this resume?" andtag:PROFILE_RESUME_DISPLAY_BGVIEW_TAG];
}
- (void) deleteSelectedRecommendation{
    [self displayDeleteAlertWithString:@"Are you sure, you want to delete this recommendation?" andtag:PROFILE_RECOMMENDATIONS_DISPLAY_BGVIEW_TAG];
}


- (void)displaySelectedVideo:(id) selectedVideo{
    UIStoryboard * addProfileStoryBoard =  [UIStoryboard storyboardWithName:SM_USER_PROFILE_DESCRIPTION_STORYBOARD bundle:nil];
    SMUserPicturesVideosDisplayVC *smUserPicturesVideosDisplayVC  =  [addProfileStoryBoard  instantiateViewControllerWithIdentifier:SM_USER_PROFILE_VIDEOS_DISPLAY_VC];
    smUserPicturesVideosDisplayVC.selectedVideoString  = selectedVideo;
    [self presentViewController:smUserPicturesVideosDisplayVC animated:YES completion:nil];
}

- (void) displayDeleteAlertWithString:(NSString *) alertString andtag:(NSInteger) tag{
    NSInteger count = [[SMSharedFilesClass sharedFileObject] uploadingCount];
    if(count){
        [[[RBACustomAlert alloc] initWithTitle:@"Swiss Monkey" message:@"The files have been uploading to server\nyou could not delete files now" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
    else{
        RBACustomAlert * deleteAlert = [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:alertString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
        [deleteAlert setTag:tag];
        [deleteAlert show];
    }
}


#pragma mark - Server call

//- (void) deleteDataFileFromServerAtIndexPath:(NSIndexPath *) indexpath
//{
//    
//    NSString * mediaString  = [SMSharedFilesClass  keyForMedia:_mediaType];
//    
//    NSArray * array =   [self  getCorrespondingObjectsArrayWithMedia:_mediaType];//([mediaString isEqualToString: k_VDI_FILES_KEY]) ? [SMSharedFilesClass getProfileVideosArray] : [SMSharedFilesClass getProfileImagesArray];
//    
//    NSString * serverKey  =  [self getServerKeyStringFromMediaType:_mediaType];
//    NSString * fileObject = [array objectAtIndex:indexpath.row];
//    
//    NSMutableDictionary *  dict  =  [[NSMutableDictionary alloc] init];
//    [dict setObject:mediaString forKey:@"type"];
//    [dict setObject:fileObject forKey:@"file"];
//    
//    BOOL  isFileNotSavedToServer = NO;
//    
//    //    if([serverKey isEqualToString:@"resume"]){
//    /* NSString * serverResume  =  [[[ReusedMethods sharedObject] userProfileInfo] objectForKey:serverKey];
//     if(![serverResume isEqualToString:fileObject]){
//     isFileNotSavedToServer  =  YES;
//     */ //===UPLOAD5RESUMES===
//    
//    
//    NSArray * existedObjectsArray  =  [[ReusedMethods userProfile] objectForKey:serverKey];
//    if(![existedObjectsArray containsObject:fileObject])
//        isFileNotSavedToServer  =  YES;
//    
//    //    }else if(serverKey){
//    //        NSArray * existedObjectsArray  =  [[[ReusedMethods sharedObject] userProfileInfo] objectForKey:serverKey];
//    //        if(![existedObjectsArray containsObject:fileObject])
//    //            isFileNotSavedToServer  =  YES;
//    //
//    //    }
//    if(isFileNotSavedToServer)
//    {
//        [SMSharedFilesClass removeFileFromLocalAtIndex:profileModel.selectedDeleteObjectIndexPath andMediaType:_mediaType];
//        [profileModel displayThumbNailsImagesOnView:[self getCorrespondingViewWithMediaType:_mediaType]];
//        [self updatePhotosVideosConstraights];
//        return;
//        
//    }
//    APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_DELETE ModuleName:MODULE_PROFILE MethodType:METHOD_TYPE_POST Parameters:dict SuccessCallBack:@selector(fileDeleteSuccessResponseCallForDelete:) AndFailureCallBack:@selector(showErrorMessagesForDelete:)];
//    
//    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
//    [service makeWebServiceCall];
//}

- (NSArray *) getServerFiles{
    switch (_mediaType) {
        case imageType:
        {
           // NSString *path = [SMSharedFilesClass profileImagesPath];
           // return  [SMSharedFilesClass allFilesAtPath:path];
            return [[ReusedMethods userProfile] objectForKey:@"image"];
        }
            break;
        case videoType:
        {
           // NSString *path = [SMSharedFilesClass profileVideosPath];
            //return  [SMSharedFilesClass allFilesAtPath:path];
            return [[ReusedMethods userProfile] objectForKey:@"video"];

        }
            break;
        default:
            return nil;
            break;
    }
}

- (void) deleteDataFileFromServerAtIndexPath:(NSIndexPath *) indexpath
{
    
    NSString * mediaString  = [SMSharedFilesClass  keyForMedia:_mediaType];
    
    NSArray * array =   [self getServerFiles];//[self  getCorrespondingObjectsArrayWithMedia:_mediaType];//([mediaString isEqualToString: k_VDI_FILES_KEY]) ? [SMSharedFilesClass getProfileVideosArray] : [SMSharedFilesClass getProfileImagesArray];
    
    NSString * serverKey  =  [self getServerKeyStringFromMediaType:_mediaType];
    NSString * fileObject = nil;
    
    if(indexpath.row < array.count)
        fileObject = [array objectAtIndex:indexpath.row];
    
    
    BOOL  isFileNotSavedToServer = NO;
    
    //    if([serverKey isEqualToString:@"resume"]){
    /* NSString * serverResume  =  [[[ReusedMethods sharedObject] userProfileInfo] objectForKey:serverKey];
     if(![serverResume isEqualToString:fileObject]){
     isFileNotSavedToServer  =  YES;
     */ //===UPLOAD5RESUMES===
    //    if(!fileObject)
    //    {
    //        [SMSharedFilesClass removeFileFromLocalAtIndex:profileModel.selectedDeleteObjectIndexPath andMediaType:_mediaType];
    //        [profileModel displayThumbNailsImagesOnView:[self getCorrespondingViewWithMediaType:_mediaType]];
    //        [self updatePhotosVideosConstraights];
    //        return;
    //
    //    }
    
    NSArray * existedObjectsArray  =  [[ReusedMethods userProfile] objectForKey:serverKey];
    if(![existedObjectsArray containsObject:fileObject])
        isFileNotSavedToServer  =  YES;
    
    //    }else if(serverKey){
    //        NSArray * existedObjectsArray  =  [[[ReusedMethods sharedObject] userProfileInfo] objectForKey:serverKey];
    //        if(![existedObjectsArray containsObject:fileObject])
    //            isFileNotSavedToServer  =  YES;
    //
    //    }
    if(!fileObject || isFileNotSavedToServer)
    {
        [SMSharedFilesClass removeFileFromLocalAtIndex:indexpath andMediaType:_mediaType];
        [profileModel displayThumbNailsImagesOnView:[self getCorrespondingViewWithMediaType:_mediaType]];
        [self updatePhotosVideosConstraights];
        return;
        
    }
    NSMutableDictionary *  dict  =  [[NSMutableDictionary alloc] init];
    [dict setObject:mediaString forKey:@"type"];
    [dict setObject:fileObject forKey:@"file"];
    
    APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_DELETE ModuleName:MODULE_PROFILE MethodType:METHOD_TYPE_POST Parameters:dict SuccessCallBack:@selector(fileDeleteSuccessResponseCallForDelete:) AndFailureCallBack:@selector(showErrorMessagesForDelete:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
    [service makeWebServiceCall];
}

#pragma mark - Server response callback methods

- (void) showErrorMessagesForDelete:(WebServiceCalls *)error
{
    NSString * errorMsg;
    if(error.responseError){
        errorMsg =  [[error responseError].userInfo objectForKey:@"NSLocalizedDescriptionKey"];
    }else{
        if ([[[error responseData] objectForKey:@"error"] length]) {
            errorMsg  = [[error responseData] objectForKey:@"error"];
        }
    }
    [[[RBACustomAlert  alloc] initWithTitle:APP_TITLE message:errorMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
}

- (void) fileDeleteSuccessResponseCallForDelete:(NSDictionary *)profileInfo
{
    NSLog(@"Profile Info : %@", profileInfo);
    [SMSharedFilesClass removeFileFromLocalAtIndex:profileModel.selectedDeleteObjectIndexPath andMediaType:_mediaType];
    if(_mediaType  ==  videoType){
      [SMSharedFilesClass removeFileFromLocalAtIndex:profileModel.selectedDeleteObjectIndexPath andMediaType:videoThumbnailType];
    }
    //[smAddProfileFourthVCModel displayThumbNailsImagesOnView:(mediaType = imageType) ? self.photosDisplayBGView : self.videosDisplayView];
    [self updateProfileInfoAfterDelete];
    [profileModel displayThumbNailsImagesOnView:[self getCorrespondingViewWithMediaType:_mediaType]];
    [self updatePhotosVideosConstraights];
    
}

- (void) updateProfileInfoAfterDelete
{
    NSMutableDictionary *  profiledict  = [[NSMutableDictionary alloc]initWithDictionary:[ReusedMethods  userProfile]];
    NSString *  idString  =  [self getServerKeyStringFromMediaType:_mediaType];
    NSString *  urlstring =  [self  getServerKeyStringForURlWithMediaType:_mediaType];
    
    NSMutableArray  *  iDsArray  =  [[NSMutableArray alloc] initWithArray: [profiledict  objectForKey:idString]];
    NSMutableArray *  urlsArray  =  [[NSMutableArray  alloc] initWithArray: [profiledict  objectForKey:urlstring]];
    
    [iDsArray  removeObjectAtIndex:profileModel.selectedDeleteObjectIndexPath.row];
    [urlsArray  removeObjectAtIndex:profileModel.selectedDeleteObjectIndexPath.row];
    
    [profiledict setObject:iDsArray forKey:idString];
    [profiledict setObject:urlsArray forKey:urlstring];
    
    if(_mediaType  ==  videoType){
        NSString *  thumbnailURLString =  [self  getServerKeyStringForURlWithMediaType:videoThumbnailType];
        NSMutableArray *  thumbnailURLsArray  =  [[NSMutableArray  alloc] initWithArray: [profiledict  objectForKey:thumbnailURLString]];
        [thumbnailURLsArray  removeObjectAtIndex:profileModel.selectedDeleteObjectIndexPath.row];
        [profiledict setObject:thumbnailURLsArray forKey:thumbnailURLString];
    }
    [ReusedMethods setUserProfile:profiledict];
}

- (NSString *) getServerKeyStringFromMediaType:(MediaType) currentMediaType{
    
    NSString *serverKey = nil;
    
    switch (currentMediaType) {
        case imageType:
            serverKey = @"image";
            break;
        case videoType:
            serverKey = @"video";
            break;
        case resumeType:
            serverKey = @"resume";
            break;
        case recommendationType:
            serverKey = @"recomendationLettrs";
            break;
        case videoThumbnailType:
            serverKey = @"videoThumbnail";
            break;

        default:
            break;
    }
    
    return serverKey;
}

- (NSString *) getServerKeyStringForURlWithMediaType:(MediaType) currentMediaType{
    
    NSString *serverKey = nil;
    
    switch (currentMediaType) {
        case imageType:
            serverKey = @"image_url";
            break;
        case videoType:
            serverKey = @"video_url";
            break;
        case resumeType:
            serverKey = @"resume_url";
            break;
        case recommendationType:
            serverKey = @"recomendationLettrs_url";
            break;
        case videoThumbnailType:
            serverKey = @"videoThumbnail";
            break;
        default:
            break;
    }
    
    return serverKey;
}


- (MediaType) getMediaTypeWithAlertTag:(NSInteger) alertTag{
    
    switch (alertTag) {
        case PROFILE_PHOTOS_DISPLAY_BGVIEW_TAG:
            return imageType;
            break;
        case PROFILE_VIDEOS_DISPLAY_BGVIEW_TAG:
            return videoType;
            break;
        case PROFILE_RESUME_DISPLAY_BGVIEW_TAG:
            return resumeType;
            break;
        case PROFILE_RECOMMENDATIONS_DISPLAY_BGVIEW_TAG:
            return recommendationType;
            break;
        default:
            return 0;
            break;
    }
    
}

- (NSArray *) getCorrespondingObjectsArrayWithMedia:(MediaType) media {
    //Getting the urls from profile info dictionary instead of ID.
    switch (media) {
        case imageType:
            return  [[ReusedMethods userProfile] valueForKey:@"image_url"];
            break;
        case videoType:
            return [[ReusedMethods userProfile] valueForKey:@"video_url"];
            break;
        default:
            return nil;
            break;
    }
    
}

- (UIView *) getCorrespondingViewWithMediaType:(MediaType) media{
    switch (media) {
        case imageType:
            return  self.photosDisplayBGView;
            break;
        case videoType:
            return self.videosDisplayView;
            break;
        default:
            return nil;
            break;
    }
    
}
- (void) profileUpdateNotificationForCurrentVC{
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SMSharedFilesClass setProfilePicture2Button:_profilePicture];
        [profileModel displayThumbNailsImagesOnView:photosDisplayBGView];
        [profileModel displayThumbNailsImagesOnView:videosDisplayView];
        //Do background work
       // dispatch_async(dispatch_get_main_queue(), ^{
            //Update UI
            [self  updatePhotosVideosConstraights];
       // });
   // });
    if (textFieldsData.count > 0) {
        [[[ReusedMethods sharedObject] userProfileInfo] addEntriesFromDictionary:textFieldsData];
        //[textFieldsData removeAllObjects];
    }
    
}

- (IBAction)changeEmailButtonAction:(id)sender {
    emailTextField.enabled  = YES;
    emailTextField.textColor = [UIColor blackColor];
    [emailTextField  becomeFirstResponder];
}


@end
