//
//  SMAddProfileDetailsFourthController.m
//  MBXPageController
//
//  Created by Kasturi on 2/3/16.
//  Copyright (c) 2016 Moblox. All rights reserved.
//

#import "SMAddProfileDetailsFourthController.h"
#import "SMUserPicturesVideosDisplayVC.h"
#import "CircleLoaderView.h"
#import "SMScreenTitleButtonsVC.h"

@interface SMAddProfileDetailsFourthController (){
    SMAddProfileFourthVCModel * smAddProfileFourthVCModel;
   // MediaType  mediaType;
    NSInteger  resumeCount ,  lettersOfRecommendationCount;
   BOOL isActionSheetOpened, isCamera;
}

@end

@implementation SMAddProfileDetailsFourthController
@synthesize compensationPreferencesTextField,expectedSalaryTextField, toSalaryTextField,otherInfoTextView,otherDescriptionView,photosTitleLabelHeightConstraint,photosDisplayViewheightConstraint,videosTitleLabelHeightConstraint,videosDisplayViewheightConstraint, resumeTitleLabel,resumeDisplayView,resumeTitleLabelHeightConstraint,resumeDisplayViewheightConstraint,recommendationsTitleLabel,recommendationsDisplayView,recommendationTitleLabelHeightConstraint,recommendationDisplayViewheightConstraint,photosDisplayBGView,videosDisplayView, contentViewHeightConstraint, mediaType;

@synthesize compensationPreferenceBGView, uploadLetterOfRecommendationButton, uploadResumeButton;

- (void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self setupUIUpdates];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isCamera = NO;
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(profileUpdateNotificationForCurrentVC)
                                                 name:@"profileUpdateNotificationForCurrentVC" object:nil];

    smAddProfileFourthVCModel = [[SMAddProfileFourthVCModel alloc] init];
    smAddProfileFourthVCModel.delegate = self;
    smAddProfileFourthVCModel.textFieldsData = [[NSMutableDictionary alloc] init];
    [self provideDelegates];
    //[self setupUIUpdates];
    [self updateUI:[[ReusedMethods sharedObject] userProfileInfo]];
    
    // updateProgressBarValue
    self.progressView.progress  =  [ReusedMethods profileProgresValue] ;
    [smAddProfileFourthVCModel createExpandableView];
    
   // [smAddProfileFourthVCModel setUPThumbNailsOnView:photosDisplayBGView ofCount:kMAXIMAGES];
  //  [smAddProfileFourthVCModel setUPThumbNailsOnView:videosDisplayView ofCount:kMAXVIDEOS];
    [smAddProfileFourthVCModel setUPThumbNailsOnView:resumeDisplayView ofCount:kMAXRESUMES];
    [smAddProfileFourthVCModel setUPThumbNailsOnView:recommendationsDisplayView ofCount:kMAXLETTERSOFRECOMMENDATION];
    
    //[smAddProfileFourthVCModel displayThumbNailsImagesOnView:photosDisplayBGView];
  //  [smAddProfileFourthVCModel displayThumbNailsImagesOnView:videosDisplayView];
    [smAddProfileFourthVCModel displayThumbNailsImagesOnView:resumeDisplayView];
    [smAddProfileFourthVCModel  displayThumbNailsImagesOnView:recommendationsDisplayView];
//    [self.po];

    
    //Add the content of Terms and Services
    NSString *htmlString = @"<h1>Terms and Services</h1><h2>Terms</h2><p>Some <em>text</em></p><img src='http://blogs.babble.com/famecrawler/files/2010/11/mickey_mouse-1097.jpg' width=70 height=100 />";
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    self.textViewTermsAndServices.attributedText = attributedString;
    
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(isActionSheetOpened == 1){
        if (isCamera == NO)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self addLoader];
                [smAddProfileFourthVCModel displayThumbNailsImagesOnView:photosDisplayBGView];
                [smAddProfileFourthVCModel displayThumbNailsImagesOnView:videosDisplayView];
                //Do background work
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Update UI
                    [self  updatePhotosVideosConstraights];
                    [self performSelector:@selector(removeLoader) withObject:nil afterDelay:0.5];
                });
            });
        }
        isCamera = YES;
    }
}

- (void) addLoader{
    [CircleLoaderView addToWindow];
}

- (void) removeLoader{
    [CircleLoaderView removeFromWindow];
}


- (void) setupUIUpdates{
   
    otherInfoTextView.placeholder  =  @"If you have other salary requirements or comments, please include here.";
    [expectedSalaryTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [toSalaryTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self updatePhotosVideosConstraights];
    
}

- (void) updateUI:(NSDictionary *)profileInfo
{
    NSString *  compensationPreferencesString;
    
    compensationPreferencesString  = ![ReusedMethods isObjectClassNameString:[profileInfo objectForKey:COMRANGE]] ?   [ReusedMethods getcorrespondingStringWithId:[profileInfo objectForKey:COMRANGE]  andKey:COMRANGE]:[profileInfo objectForKey:COMRANGE] ;
    
    compensationPreferencesTextField.botomBorder.hidden = YES;
    compensationPreferencesTextField.text = [ReusedMethods replaceEmptyString:compensationPreferencesString emptyString:SPACE];
    NSString *salary = [ReusedMethods replaceEmptyString:[profileInfo objectForKey:FROM_SALARY] emptyString:SPACE];
    if(![salary hasPrefix:@"$"])
        salary = [NSString stringWithFormat:@"$%d", [salary intValue]];
    expectedSalaryTextField.text = salary;
    [expectedSalaryTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    
    NSString *toSalary = [ReusedMethods replaceEmptyString:[profileInfo objectForKey:TO_SALARY] emptyString:SPACE];
    if(![toSalary hasPrefix:@"$"])
        toSalary = [NSString stringWithFormat:@"$%d", [toSalary intValue]];
    toSalaryTextField.text = toSalary;
    [toSalaryTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    otherInfoTextView.text = [[profileInfo objectForKey:COMMENTS] length]? [profileInfo objectForKey:COMMENTS] : nil;
    
    [ReusedMethods applyShadowToView:compensationPreferenceBGView];
    [ReusedMethods applyShadowToView:otherDescriptionView];
    [ReusedMethods applyShadowToView:_termsAndServicesContainerView];
    [ReusedMethods applyBlueButtonStyle:uploadLetterOfRecommendationButton];
    [ReusedMethods applyBlueButtonStyle:uploadResumeButton];
    
    //Terms and Services
    BOOL isTermsServicesChecked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"TermsAndServiceChecked"] boolValue];
    [self.btnAgree setSelected:isTermsServicesChecked];
}

- (void)provideDelegates{
    compensationPreferencesTextField.delegate  = self;
    expectedSalaryTextField.delegate  = self;
    toSalaryTextField.delegate = self;
    otherInfoTextView.delegate  = self;
}

- (void) updatePhotosVideosConstraights{
    float horizantalGap  =  20;
    float screenWidth  =  [UIScreen mainScreen].bounds.size.width;
    float viewWidth  = ((screenWidth - 40)- (2 * horizantalGap) )/3;
    
//    if ([SMSharedFilesClass getProfileImagesArray].count == 0) {
//        photosTitleLabelHeightConstraint.constant = 0;
//        photosDisplayViewheightConstraint.constant = 0;
//    }else{
//        photosTitleLabelHeightConstraint.constant = 21;
//        photosDisplayViewheightConstraint.constant =  [SMSharedFilesClass  getProfileImagesArray].count > 3 ? viewWidth * 2 : viewWidth;
//    }
//    
//    if ([SMSharedFilesClass getProfileVideosArray].count == 0) {
//        videosTitleLabelHeightConstraint.constant = 0;
//        videosDisplayViewheightConstraint.constant = 0;
//    }else{
//        videosTitleLabelHeightConstraint.constant = 21;
//        videosDisplayViewheightConstraint.constant = viewWidth;
//    }
    
    //Getting the urls from profile info dictionary instead of ID.
    if ([[[ReusedMethods userProfile] valueForKey:@"resume_url"] count] == 0) {
        resumeTitleLabelHeightConstraint.constant = 0;
        resumeDisplayViewheightConstraint.constant = 0;
    }else{
        resumeTitleLabelHeightConstraint.constant = 21;
        resumeDisplayViewheightConstraint.constant =  [[[ReusedMethods userProfile] valueForKey:@"resume_url"] count] > 3 ? viewWidth * 2 : viewWidth;
        
        //resumeDisplayViewheightConstraint.constant =  viewWidth; //=====UPLOAD5RESUMES===
    }
    

    
    if ([[[ReusedMethods userProfile] valueForKey:@"recomendationLettrs_url"] count] == 0) {
        recommendationTitleLabelHeightConstraint.constant = 0;
        recommendationDisplayViewheightConstraint.constant = 0;
    }else{
        recommendationTitleLabelHeightConstraint.constant = 21;
        recommendationDisplayViewheightConstraint.constant =  [[[ReusedMethods userProfile] valueForKey:@"recomendationLettrs_url"] count] > 3 ? viewWidth * 2 : viewWidth;
    }
    
    [self.contentView  layoutSubviews];
    [self.contentView updateConstraints];
    contentViewHeightConstraint.constant  =  CGRectGetMaxY(_agreeCheckboxContainerView.frame) + CGRectGetHeight(self.progressView.frame) + 100 ;
    
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
#pragma mark - UIActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0){
        isCamera = YES;
        [self openAlubmVC];
    }
    else if(buttonIndex == 1){
        isCamera = YES;
        [self openCamera];
    }
}

- (void) openCamera{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (void) openAlubmVC{
    
    NSInteger max = 0;
    
    if(mediaType == resumeType){
        max = kMAXRESUMES - resumeCount;
    }
    else if(mediaType == recommendationType){
        max = kMAXLETTERSOFRECOMMENDATION - lettersOfRecommendationCount;
    }
    
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    elcPicker.maximumImagesCount = max; //Set the maximum number of images to select, defaults to 5
    elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return selected order of images
    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
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

#pragma mark - ELCImagePickerController Delegate

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    for (NSDictionary *imageDict in info){
        UIImage *image = [imageDict objectForKey:UIImagePickerControllerOriginalImage];
        [self saveImage:image];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self uploadFiles];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    isActionSheetOpened = 0;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) saveImage:(UIImage *)image{
    [SMSharedFilesClass saveImageAtDocumentoryPath:image withName:[ReusedMethods GUID] needExtension:YES mediaType:mediaType];
    
    //[smAddProfileFourthVCModel  displayThumbNailsImagesOnView:resumeDisplayView];
    //[smAddProfileFourthVCModel displayThumbNailsImagesOnView:recommendationsDisplayView];
   // [self updatePhotosVideosConstraights];
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:( NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self saveImage:image];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self uploadFiles];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    isActionSheetOpened = 0;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark  - Dropdown interaction

- (IBAction)clickedCompensationPreference:(id)sender {
    [smAddProfileFourthVCModel openCompensationPreferences:self.compensationPreferencesTextField];
}

#pragma mark - TEXTFIELD  DELEGATE  METHODS
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    return [smAddProfileFourthVCModel textFieldShouldBeginEditing:textField];
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    [smAddProfileFourthVCModel textFieldDidEndEditing:textField];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    return [smAddProfileFourthVCModel textFieldShouldReturn:textField];
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return [smAddProfileFourthVCModel textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
   return  [smAddProfileFourthVCModel textView:textView shouldChangeTextInRange:range replacementText:text];
}

#pragma  mark -  RBA POPUP DELEGATE METHODS

- (void) selectedValue:(id)value withKeyId:(NSString *)keyId titleName:(NSString *)titleName withKey:(NSString *)key selectedCell:(UITableViewCell *)selectedCell withType:(PopupType)typePopup{
    
    NSString *serverkey = nil;
    if(typePopup == kCompRange)
        serverkey = COMRANGE;
    
    [[[ReusedMethods sharedObject] userProfileInfo] setObject:value forKey:serverkey];
    [smAddProfileFourthVCModel.textFieldsData setObject:value forKey:key];
}

- (void)popTipViewWasDismissedByUser:(RBAPopup *)popTipView{
    
}

#pragma  mark - BUTTON ACTIONS

- (IBAction)agreeButtonAction:(id)sender {
    //Change the button status
    [_btnAgree setSelected:![_btnAgree isSelected]];
    
    //Save the check status
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:_btnAgree.isSelected] forKey:@"TermsAndServiceChecked"];
}

- (IBAction)uploadLetterofRecomendationsButtonAction:(id)sender {
//    UIActionSheet *popup = [SMSharedFilesClass actionSheetWithDelegate:self];
//    _mediaType = recommendationType;
//    [popup showInView:self.view];
//
    isActionSheetOpened  = 1;
    [self.contentView endEditing:YES];
    lettersOfRecommendationCount = [[[ReusedMethods userProfile] objectForKey:@"recomendationLettrs"]count]; //[SMSharedFilesClass listFileAtPath:[SMSharedFilesClass profilePRecommendationLettersPath]];
    if(kMAXLETTERSOFRECOMMENDATION > lettersOfRecommendationCount){
        if([ReusedMethods isPermissionGranted]){
            mediaType = recommendationType;
            UIActionSheet *popup = [SMSharedFilesClass actionSheetWithDelegate:self];
            [popup showInView:self.view];
            
        }
        else{
            [ReusedMethods showPermissionRequiredAlert];
        }
    }
    else{
//        [[[RBACustomAlert alloc] initWithTitle:@"Already uploaded your resume" message:@"Do you want to change it?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] show];
        [[[RBACustomAlert alloc] initWithTitle:[NSString stringWithFormat:@"Already uploaded %i images", kMAXLETTERSOFRECOMMENDATION] message:@"Please delete your existing letters from below to add new letter." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

- (IBAction)uploadResumeButtonAction:(id)sender {
    isActionSheetOpened  = 1;
    [self.contentView endEditing:YES];
    
    resumeCount = [[[ReusedMethods userProfile] objectForKey:@"resume"]count];//[SMSharedFilesClass listFileAtPath:[SMSharedFilesClass profileResumePath]];
    if(kMAXRESUMES > resumeCount){
        if([ReusedMethods isPermissionGranted]){
            mediaType = resumeType;
            UIActionSheet *popup = [SMSharedFilesClass actionSheetWithDelegate:self];
            [popup showInView:self.view];
            
        }
        else{
            [ReusedMethods showPermissionRequiredAlert];
        }
    }
    else{
        [[[RBACustomAlert alloc] initWithTitle:@"Already uploaded your resume" message:@"Please delete your existing resume from below to add new resume." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
    }
}



//- (void)deleteSelectedImage{
//    [self displayDeleteAlertWithString:@"Are you sure, you want to delete this image?" andtag:PROFILE_PHOTOS_DISPLAY_BGVIEW_TAG];
//}
//- (void)deleteSelectedVideo{
//    [self displayDeleteAlertWithString:@"Are you sure, you want to delete this video?" andtag:PROFILE_VIDEOS_DISPLAY_BGVIEW_TAG];
//}
- (void) deleteSelectedResume{
    [self displayDeleteAlertWithString:@"Are you sure, you want to delete this resume?" andtag:PROFILE_RESUME_DISPLAY_BGVIEW_TAG];
}
- (void) deleteSelectedRecommendation{
    [self displayDeleteAlertWithString:@"Are you sure, you want to delete this recommendation?" andtag:PROFILE_RECOMMENDATIONS_DISPLAY_BGVIEW_TAG];
}


//- (void)displaySelectedVideo:(id) selectedVideo{
//    UIStoryboard * addProfileStoryBoard =  [UIStoryboard storyboardWithName:SM_USER_PROFILE_DESCRIPTION_STORYBOARD bundle:nil];
//    SMUserPicturesVideosDisplayVC *smUserPicturesVideosDisplayVC  =  [addProfileStoryBoard  instantiateViewControllerWithIdentifier:SM_USER_PROFILE_VIDEOS_DISPLAY_VC];
//    smUserPicturesVideosDisplayVC.selectedVideoString  = selectedVideo;
//    [self presentViewController:smUserPicturesVideosDisplayVC animated:YES completion:nil];
//}

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

#pragma mark - RBACUSTOM ALERT DELEGATE  METHODS

- (void) alertView:(RBACustomAlert *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex  == [alertView cancelButtonIndex]) {
        
        mediaType  =  [self  getMediaTypeWithAlertTag:alertView.tag]; //  (alertView.tag  == PROFILE_PHOTOS_DISPLAY_BGVIEW_TAG ) ? imageType : videoType ;
        
        [self deleteDataFileFromServerAtIndexPath:smAddProfileFourthVCModel.selectedDeleteObjectIndexPath];
    }
}

#pragma mark - Server call

//- (void) deleteDataFileFromServerAtIndexPath:(NSIndexPath *) indexpath
//{
//    
//    NSString * mediaString  = [SMSharedFilesClass  keyForMedia:mediaType];
//    
//    NSArray * array =   [self  getCorrespondingObjectsArrayWithMedia:mediaType];//([mediaString isEqualToString: k_VDI_FILES_KEY]) ? [SMSharedFilesClass getProfileVideosArray] : [SMSharedFilesClass getProfileImagesArray];
//    
//    NSString * serverKey  =  [self getServerKeyStringFromMediaType:mediaType];
//    NSString * fileObject = [array objectAtIndex:indexpath.row];
//    
//    NSMutableDictionary *  dict  =  [[NSMutableDictionary alloc] init];
//    [dict setObject:mediaString forKey:@"type"];
//    [dict setObject:fileObject forKey:@"file"];
//    
//    BOOL  isFileNotSavedToServer = NO;
//    
////    if([serverKey isEqualToString:@"resume"]){
//       /* NSString * serverResume  =  [[[ReusedMethods sharedObject] userProfileInfo] objectForKey:serverKey];
//        if(![serverResume isEqualToString:fileObject]){
//            isFileNotSavedToServer  =  YES;
//        */ //===UPLOAD5RESUMES===
//            
//            
//    NSArray * existedObjectsArray  =  [[ReusedMethods userProfile] objectForKey:serverKey];
//    if(![existedObjectsArray containsObject:fileObject])
//        isFileNotSavedToServer  =  YES;
//    
////    }else if(serverKey){
////        NSArray * existedObjectsArray  =  [[[ReusedMethods sharedObject] userProfileInfo] objectForKey:serverKey];
////        if(![existedObjectsArray containsObject:fileObject])
////            isFileNotSavedToServer  =  YES;
////        
////    }
//    if(isFileNotSavedToServer)
//    {
//        [SMSharedFilesClass removeFileFromLocalAtIndex:smAddProfileFourthVCModel.selectedDeleteObjectIndexPath andMediaType:mediaType];
//        [smAddProfileFourthVCModel displayThumbNailsImagesOnView:[self getCorrespondingViewWithMediaType:mediaType]];
//        [self updatePhotosVideosConstraights];
//        return;
//        
//    }
//    APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_DELETE ModuleName:MODULE_PROFILE MethodType:METHOD_TYPE_POST Parameters:dict SuccessCallBack:@selector(fileDeleteSuccessResponseCall:) AndFailureCallBack:@selector(showErrorMessages:)];
//    
//    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
//    [service makeWebServiceCall];
//}

- (NSArray *) getServerFiles{
    switch (mediaType) {
        case resumeType:
        {
           // NSString *path = [SMSharedFilesClass profileResumePath];
           // return  [SMSharedFilesClass allFilesAtPath:path];
            return [[ReusedMethods userProfile] objectForKey:@"resume"];

        }
            break;
        case recommendationType:
        {
            //NSString *path = [SMSharedFilesClass profilePRecommendationLettersPath];
            //return  [SMSharedFilesClass allFilesAtPath:path];
            return [[ReusedMethods userProfile] objectForKey:@"recomendationLettrs"];

        }
            break;
        default:
            return nil;
            break;
    }
}

- (void) deleteDataFileFromServerAtIndexPath:(NSIndexPath *) indexpath
{
    
    NSString * mediaString  = [SMSharedFilesClass  keyForMedia:mediaType];
    
    NSArray * array =   [self getServerFiles];//[self  getCorrespondingObjectsArrayWithMedia:_mediaType];//([mediaString isEqualToString: k_VDI_FILES_KEY]) ? [SMSharedFilesClass getProfileVideosArray] : [SMSharedFilesClass getProfileImagesArray];
    
    NSString * serverKey  =  [self getServerKeyStringFromMediaType:mediaType];
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
        [SMSharedFilesClass removeFileFromLocalAtIndex:smAddProfileFourthVCModel.selectedDeleteObjectIndexPath andMediaType:mediaType];
        [smAddProfileFourthVCModel displayThumbNailsImagesOnView:[self getCorrespondingViewWithMediaType:mediaType]];
        [self updatePhotosVideosConstraights];
        return;
        
    }
    NSMutableDictionary *  dict  =  [[NSMutableDictionary alloc] init];
    [dict setObject:mediaString forKey:@"type"];
    [dict setObject:fileObject forKey:@"file"];
    
    APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_DELETE ModuleName:MODULE_PROFILE MethodType:METHOD_TYPE_POST Parameters:dict SuccessCallBack:@selector(fileDeleteSuccessResponseCall:) AndFailureCallBack:@selector(showErrorMessages:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
    [service makeWebServiceCall];
}


#pragma mark - Server response callback methods

- (void) showErrorMessages:(WebServiceCalls *)error
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

- (void) fileDeleteSuccessResponseCall:(NSDictionary *)profileInfo
{
    NSLog(@"Profile Info : %@", profileInfo);
    [SMSharedFilesClass removeFileFromLocalAtIndex:smAddProfileFourthVCModel.selectedDeleteObjectIndexPath andMediaType:mediaType];
    //[smAddProfileFourthVCModel displayThumbNailsImagesOnView:(mediaType = imageType) ? self.photosDisplayBGView : self.videosDisplayView];
    [self updateProfileInfoAfterDelete];
    [smAddProfileFourthVCModel displayThumbNailsImagesOnView:[self getCorrespondingViewWithMediaType:mediaType]];
    [self updatePhotosVideosConstraights];

}

- (void) updateProfileInfoAfterDelete
{
    NSMutableDictionary *  profiledict  = [[NSMutableDictionary alloc]initWithDictionary:[ReusedMethods  userProfile]];
    NSString *  idString  =  [self getServerKeyStringFromMediaType:mediaType];
    NSString *  urlstring =  [self  getServerKeyStringForURlWithMediaType:mediaType];
    
    NSMutableArray  *  iDsArray  =  [[NSMutableArray alloc] initWithArray: [profiledict  objectForKey:idString]];
    NSMutableArray *  urlsArray  =  [[NSMutableArray  alloc] initWithArray: [profiledict  objectForKey:urlstring]];
    
    [iDsArray  removeObjectAtIndex:smAddProfileFourthVCModel.selectedDeleteObjectIndexPath.row];
    [urlsArray  removeObjectAtIndex:smAddProfileFourthVCModel.selectedDeleteObjectIndexPath.row];
    
    
    [profiledict setObject:iDsArray forKey:idString];
    [profiledict setObject:urlsArray forKey:urlstring];
    
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
    //Getting the image urls from profile info dictionary instead of image ID.
    switch (media) {
        case imageType:
            return  [[ReusedMethods userProfile] valueForKey:@"image_url"];
            break;
        case videoType:
            return [[ReusedMethods userProfile] valueForKey:@"video_url"];
            break;
        case resumeType:
            return [[ReusedMethods userProfile] valueForKey:@"resume_url"];
            break;
        case recommendationType:
            return [[ReusedMethods userProfile] valueForKey:@"recomendationLettrs_url"];
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
        case resumeType:
            return self.resumeDisplayView;
            break;
        case recommendationType:
            return self.recommendationsDisplayView;
            break;
        default:
            return nil;
            break;
    }

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
        default:
            break;
    }
    
    return serverKey;
}

- (void) profileUpdateNotificationForCurrentVC{
    [smAddProfileFourthVCModel displayThumbNailsImagesOnView:resumeDisplayView];
    [smAddProfileFourthVCModel  displayThumbNailsImagesOnView:recommendationsDisplayView];
    [self updatePhotosVideosConstraights];
    
    if (smAddProfileFourthVCModel.textFieldsData.count > 0) {
        [[[ReusedMethods sharedObject] userProfileInfo] addEntriesFromDictionary:smAddProfileFourthVCModel.textFieldsData];
        [smAddProfileFourthVCModel.textFieldsData removeAllObjects];
    }
}




@end
