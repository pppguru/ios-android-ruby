//
//  SMAddProfileFourthVCModel.m
//  SwissMonkey
//
//  Created by Prasad on 2/22/16.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import "SMAddProfileFourthVCModel.h"

@interface SMAddProfileFourthVCModel(){
    UIView * expandableView;
    UIImageView * expandableImageView;
    UIButton * leftButton,*rightButton;
    int photoIndex;
    NSArray * displayImagesArray;
    MediaType   mediaType;
}

@end

@implementation SMAddProfileFourthVCModel
@synthesize profileImagesArray,profileVideosArray;

- (id)init{
    self  =  [super init];
    if(self){
        
        
    }
    return self;
}

#pragma mark - Compensation Preferences Dropdown Handler

- (void)openCompensationPreferences:(UITextField*)textField{
    NSMutableDictionary  *  totalListDict  =  [[ReusedMethods sharedObject] dropDownListDict];
    NSString *  keyString  =  [self getKeyForDropDownListOfTextFieldTag:[textField  tag]];
    
    [ReusedMethods setupPopUpViewForTextField:textField withDisplayArray:[totalListDict  objectForKey:keyString] withDel:_delegate displayKey:@"compensation_name" returnKey:@"compensation_id" withTag:kCompRange];
}

#pragma mark - TEXTFIELD  DELEGATE  METHODS

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    if([textField tag]  !=  PROFILE_LICENCE_NUMBER_TEXTFIELD_TAG){
        return NO;
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    
}


- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    
    if([textField tag]  ==  PROFILE_COMPRANGE_TEXTFIELD_TAG){
        [self openCompensationPreferences:textField];
        return NO;
    }
    else{
        return YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //    textField.text = text;
    
    
    UITextPosition *beginning = textField.beginningOfDocument;
    UITextPosition *start = [textField positionFromPosition:beginning offset:range.location];
    UITextPosition *end = [textField positionFromPosition:start offset:range.length];
    UITextRange *textRange = [textField textRangeFromPosition:start toPosition:end];
    
    // this will be the new cursor location after insert/paste/typing
    NSInteger cursorOffset = [textField offsetFromPosition:beginning toPosition:start] + string.length;
    
    //  not allowing cursor not exceeds  11  digits  and not  moved  beyond  the  $
    if(cursorOffset == 0 || cursorOffset == 12)
        return NO;
    
    // now apply the text changes that were typed or pasted in to the text field
    [textField replaceRange:textRange withText:string];
    
    // now go modify the text in interesting ways doing our post processing of what was typed...
    NSString *t = [textField.text mutableCopy];
    // ... etc
    
    // now update the text field and reposition the cursor afterwards
    textField.text = t;
    NSString *value = textField.text;
    NSString *key = nil;
    
    if([textField  tag]== PROFILE_EXPECTEDSALARY_TAG){
        key = @"from_salary_range";
        BOOL dollor = [textField.text hasPrefix:@"$"];
        if(!dollor)
        {
            NSLog(@"=== %@",textField.text);
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@"$" withString:@""];
            
            textField.text = [NSString stringWithFormat:@"$%@", textField.text];
        }
        value = [textField.text stringByReplacingOccurrencesOfString:@"$" withString:@""];
    }
    if([textField  tag]== PROFILE_EXPECTED_TO_SALARY_TAG){
        key = @"to_salary_range";
        BOOL dollor = [textField.text hasPrefix:@"$"];
        if(!dollor)
        {
            NSLog(@"=== %@",textField.text);
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@"$" withString:@""];
            
            textField.text = [NSString stringWithFormat:@"$%@", textField.text];
        }
        value = [textField.text stringByReplacingOccurrencesOfString:@"$" withString:@""];
    }
    
    UITextPosition *newCursorPosition = [textField positionFromPosition:textField.beginningOfDocument offset:cursorOffset];
    UITextRange *newSelectedRange = [textField textRangeFromPosition:newCursorPosition toPosition:newCursorPosition];
    [textField setSelectedTextRange:newSelectedRange];
    
    //    NSLog(@"%@ : %@", key, text);n
    [[[ReusedMethods sharedObject] userProfileInfo] setObject:value forKey:key];
    [self.textFieldsData setObject:value forKey:key];
    return NO;
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
    [[[ReusedMethods sharedObject] userProfileInfo] setObject:t forKey:@"comments"];
    [self.textFieldsData setObject:t forKey:@"comments"];
    
    [ReusedMethods setCapitalizationForFirstLetterOfField:textView];

    
    return NO;
}

- (NSString *) getKeyForDropDownListOfTextFieldTag:(NSInteger) tag{
    
    if (tag  ==  PROFILE_COMPRANGE_TEXTFIELD_TAG) {
        return  @"comprange";
    }
    return @"";
}


//-(void) setUPThumbNailImagesOnView:(UIView *) BGView{
//
//    float xPos  =  0;
//    float yPos  =  20;
//    float viewWidth  = 60;
//    float viewHeight  = 60;
//    for (int i  =  0; i  < 5; i ++) {
//
//
//
//        UIButton *  imgButton  =  [UIButton buttonWithType:UIButtonTypeCustom];
//        [imgButton setFrame:CGRectMake(xPos, yPos, viewWidth, viewHeight)];
//        [imgButton setTag:i];
//        [imgButton addTarget:self action:@selector(imgButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [imgButton setBackgroundColor:[UIColor clearColor]];
//        [BGView addSubview:imgButton];
//
//        float deleteButtonWidth  = 30;
//        float deleteXpos  = CGRectGetMaxX(imgButton.frame) -  (deleteButtonWidth/2);
//        float deleteYpos  =  CGRectGetMinY(imgButton.frame) - (deleteButtonWidth/2);
//
//
//        UIButton *  deleteButton  =  [UIButton buttonWithType:UIButtonTypeCustom];
//        [deleteButton setFrame:CGRectMake(deleteXpos, deleteYpos, deleteButtonWidth, deleteButtonWidth)];
//        [deleteButton setTag:i];
//        [[deleteButton layer] setCornerRadius:CGRectGetWidth(deleteButton.frame)/2];
//        [[deleteButton layer] setMasksToBounds:YES];
//        [deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [deleteButton setBackgroundColor:[UIColor appLightPinkColor]];
//        [deleteButton setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
//        [BGView addSubview:deleteButton];
//
//        xPos  = CGRectGetMaxX(imgButton.frame) + 30 ;
//        if(xPos  >= CGRectGetWidth(BGView.frame)){
//            xPos  = 0;
//            yPos  =  CGRectGetMaxY(imgButton.frame) + 20;
//        }
//
//    }
//
//}
//
//-(void) setUPThumbNailVideosImagesOnView:(UIView *) BGView{
//
//    float xPos  =  0;
//    float yPos  =  20;
//    float viewWidth  = 60;
//    float viewHeight  = 60;
//    for (int i  =  0; i  < 3; i ++) {
//        UIButton *  imgButton  =  [UIButton buttonWithType:UIButtonTypeCustom];
//        [imgButton setFrame:CGRectMake(xPos, yPos, viewWidth, viewHeight)];
//        [imgButton setTag:i];
//        [imgButton addTarget:self action:@selector(videoImgButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [imgButton setBackgroundColor:[UIColor clearColor]];
//        [BGView addSubview:imgButton];
//
//        float deleteButtonWidth  = 30;
//        float deleteXpos  = CGRectGetMaxX(imgButton.frame) -  (deleteButtonWidth/2);
//        float deleteYpos  =  CGRectGetMinY(imgButton.frame) - (deleteButtonWidth/2);
//
//
//        UIButton *  deleteButton  =  [UIButton buttonWithType:UIButtonTypeCustom];
//        [deleteButton setFrame:CGRectMake(deleteXpos, deleteYpos, deleteButtonWidth, deleteButtonWidth)];
//        [deleteButton setTag:i];
//        [[deleteButton layer] setCornerRadius:CGRectGetWidth(deleteButton.frame)/2];
//        [[deleteButton layer] setMasksToBounds:YES];
//        [deleteButton addTarget:self action:@selector(deleteVideoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [deleteButton setBackgroundColor:[UIColor appLightPinkColor]];
//        [deleteButton setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
//
//        [BGView addSubview:deleteButton];
//
//        xPos  = CGRectGetMaxX(imgButton.frame) + 30 ;
//        if(xPos  >= CGRectGetWidth(BGView.frame)){
//            xPos  = 0;
//            yPos  =  CGRectGetMaxY(imgButton.frame) + 20;
//        }
//
//    }
//
//}

- (void)setUPThumbNailsOnView:(UIView *)bgView ofCount:(int) count{
    
    float xPos  =  0;
    float yPos  =  0;
    float horizantalGap  =  20;
    float screenWidth  =  [UIScreen mainScreen].bounds.size.width;
    float viewWidth  = ((screenWidth - 40)- (2 * horizantalGap) )/3; //(CGRectGetWidth(bgView.frame) - 0)/3;
    //    float viewHeight  = 60;
    //    [bgView setBackgroundColor:[UIColor redColor]];
    for (int i  =  0; i  < count; i ++) {
        
        UIView * imageBGView  =  [[UIView alloc] initWithFrame:CGRectMake(xPos, yPos, viewWidth, viewWidth)];
        [imageBGView setTag:i];
        //        [imageBGView setBackgroundColor:[UIColor greenColor]];
        
        UIButton *  imgButton  =  [UIButton buttonWithType:UIButtonTypeCustom];
        [imgButton setFrame:CGRectMake(0, 12, viewWidth - 30, viewWidth - 30)];
        [imgButton setTag:i];
        
        if (bgView.tag  ==  PROFILE_PHOTOS_DISPLAY_BGVIEW_TAG)
            [imgButton addTarget:self action:@selector(imgButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        else if(bgView.tag == PROFILE_VIDEOS_DISPLAY_BGVIEW_TAG)
            [imgButton addTarget:self action:@selector(videoImgButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        else if (bgView.tag == PROFILE_RESUME_DISPLAY_BGVIEW_TAG)
            [imgButton addTarget:self action:@selector(resumeImgButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        else if(bgView.tag == PROFILE_RECOMMENDATIONS_DISPLAY_BGVIEW_TAG)
            [imgButton addTarget:self action:@selector(recommendationImgButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [imgButton setBackgroundColor:[UIColor clearColor]];
        imgButton.layer.borderWidth = 0.5f;
        imgButton.layer.borderColor = [[UIColor appGrayColor] CGColor];
        imgButton.layer.cornerRadius = 5;
        imgButton.layer.masksToBounds = YES;
        [imageBGView addSubview:imgButton];
        
        float deleteButtonWidth  = 20;
        float deleteXpos  = CGRectGetMaxX(imgButton.frame) -  (deleteButtonWidth/2);
        float deleteYpos  =  CGRectGetMinY(imgButton.frame) - (deleteButtonWidth/2);
        
        
        UIButton *  deleteButton  =  [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setFrame:CGRectMake(deleteXpos, deleteYpos, deleteButtonWidth, deleteButtonWidth)];
        [deleteButton setTag:i];
        [[deleteButton layer] setCornerRadius:CGRectGetWidth(deleteButton.frame)/2];
        [[deleteButton layer] setMasksToBounds:YES];
        
        if(bgView.tag == PROFILE_PHOTOS_DISPLAY_BGVIEW_TAG)
            [deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        else if(bgView.tag == PROFILE_VIDEOS_DISPLAY_BGVIEW_TAG)
            [deleteButton addTarget:self action:@selector(deleteVideoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        else if (bgView.tag == PROFILE_RESUME_DISPLAY_BGVIEW_TAG)
            [deleteButton addTarget:self action:@selector(deleteResumeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        else if(bgView.tag == PROFILE_RECOMMENDATIONS_DISPLAY_BGVIEW_TAG)
            [deleteButton addTarget:self action:@selector(deleteRecommendationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [deleteButton setBackgroundColor:[UIColor appLightPinkColor]];
        [deleteButton setImage:[UIImage imageNamed:@"cross_small"] forState:UIControlStateNormal];
        [imageBGView addSubview:deleteButton];
        
        [bgView addSubview:imageBGView];
        
        
        xPos  = CGRectGetMaxX(imageBGView.frame) + 0 ;
        if(xPos  >= CGRectGetWidth(bgView.frame)){
            xPos  = 0;
            yPos  =  CGRectGetMaxY(imageBGView.frame) + 0;
        }
        //        [imageBGView setBackgroundColor:[UIColor greenColor]];
    }
}

- (void) displayThumbNailsImagesOnView:(UIView *) BGView{
    
    NSArray *  imagesArray  = [self getCorrespondingObjectsArrayWithTag:BGView.tag];
    int  count  =  [self  getCorrespondingMaximunArrayCountWithTag:BGView.tag]; // ( BGView.tag  ==  PROFILE_PHOTOS_DISPLAY_BGVIEW_TAG) ? kMAXIMAGES:kMAXVIDEOS ;
    
    for (int i  =  0; i < count; i++) {
        UIView * view  =  (UIView *)[BGView viewWithTag:i];
        UIButton *  button  = (UIButton *)[[view subviews] objectAtIndex:0];
        NSIndexPath  *  indexpath  =  [NSIndexPath indexPathForRow:i inSection:0];
        if(i< imagesArray.count){
            [self displayObjectsCorrespondingToTheTag:BGView.tag onButton:button atIndex:indexpath];
            [[button imageView] setContentMode:UIViewContentModeScaleAspectFill];
            [view setHidden:NO];
        }else{
            [view setHidden:YES];
            
        }
    }
}

- (NSArray *) getCorrespondingObjectsArrayWithTag:(NSInteger) tag {
    //Getting the urls from profile info dictionary instead of ID.
    switch (tag) {
        case PROFILE_PHOTOS_DISPLAY_BGVIEW_TAG:
            return  [[ReusedMethods userProfile] valueForKey:@"image_url"];
            break;
        case PROFILE_VIDEOS_DISPLAY_BGVIEW_TAG:
            return [[ReusedMethods userProfile] valueForKey:@"video_url"];
            break;
        case PROFILE_RESUME_DISPLAY_BGVIEW_TAG:
            return [[ReusedMethods userProfile] valueForKey:@"resume_url"];
            break;
        case PROFILE_RECOMMENDATIONS_DISPLAY_BGVIEW_TAG:
            return [[ReusedMethods userProfile] valueForKey:@"recomendationLettrs_url"];
            break;
        default:
            return nil;
            break;
    }
    
}

- (int) getCorrespondingMaximunArrayCountWithTag:(NSInteger) tag {
    switch (tag) {
        case PROFILE_PHOTOS_DISPLAY_BGVIEW_TAG:
            return  kMAXIMAGES;
            break;
        case PROFILE_VIDEOS_DISPLAY_BGVIEW_TAG:
            return kMAXVIDEOS;
            break;
        case PROFILE_RESUME_DISPLAY_BGVIEW_TAG:
            return kMAXRESUMES;
            break;
        case PROFILE_RECOMMENDATIONS_DISPLAY_BGVIEW_TAG:
            return kMAXLETTERSOFRECOMMENDATION;
            break;
        default:
            return 0;
            break;
    }
    
}

- (void) displayObjectsCorrespondingToTheTag:(NSInteger)  tag onButton:(UIButton *) button atIndex:(NSIndexPath *) indexpath {
    switch (tag) {
        case PROFILE_PHOTOS_DISPLAY_BGVIEW_TAG:
            [SMSharedFilesClass setProfileImagesOnView:button atIndexPath:indexpath];;
            break;
        case PROFILE_VIDEOS_DISPLAY_BGVIEW_TAG:
            [SMSharedFilesClass setVideoImagesOnView:button atIndexpath:indexpath];
            break;
        case PROFILE_RESUME_DISPLAY_BGVIEW_TAG:
            [SMSharedFilesClass setResumeImagesOnView:button atIndexPath:indexpath];
            break;
        case PROFILE_RECOMMENDATIONS_DISPLAY_BGVIEW_TAG:
            [SMSharedFilesClass setLetterOfRecommendationImagesOnView:button atIndexPath:indexpath];
            break;
        default:
            break;
    }
    
}





//- (void) displayThumbNailImagesOfView:(UIView *)BgView{
////    for (int i  =  0; i < profileImagesArray.count; i++) {
////
////        UIButton *  button  =  (UIButton *)[BgView viewWithTag:i];
////        NSIndexPath  *  indexpath  =  [NSIndexPath indexPathForRow:i inSection:0];
////        [SMSharedFilesClass setProfileImagesOnView:button atIndexPath:indexpath];
////        [[button imageView] setContentMode:UIViewContentModeScaleAspectFill];
////    }
//}
//- (void) displayThumbNailVideosOfView:(UIView *)BgView{
//    for (int i  =  0; i < profileVideosArray.count; i++) {
//
//        UIButton *  button  =  (UIButton *)[BgView viewWithTag:i];
//        NSIndexPath  *  indexpath  =  [NSIndexPath indexPathForRow:i inSection:0];
//        [SMSharedFilesClass setVideoImagesOnView:button atIndexpath:indexpath];
//        [[button imageView] setContentMode:UIViewContentModeScaleAspectFill];
//    }
//
//}
//
//

- (void)imgButtonAction:(id)sender{
    photoIndex  = (int)[sender tag];
    mediaType  =  imageType;
    //Getting the image urls from profile info dictionary instead of image ID.
    displayImagesArray =  [[ReusedMethods userProfile] valueForKey:@"image_url"];
    [self addExapandableView];
}
- (void)deleteButtonAction:(id)sender{
    self.selectedDeleteObjectIndexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    [self.delegate deleteSelectedImage];
}
- (void) videoImgButtonAction:(id) sender{
    //Getting the video urls from profile info dictionary instead of Video ID.
    [self.delegate displaySelectedVideo:[[[ReusedMethods userProfile] valueForKey:@"video_url"] objectAtIndex:[sender tag]]];
}
- (void)deleteVideoButtonAction:(id) sender{
    self.selectedDeleteObjectIndexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    [self.delegate deleteSelectedVideo];
}
- (void) resumeImgButtonAction:(id) sender{
    photoIndex  = (int)[sender tag];
    mediaType  =  resumeType;
    //Getting the resume urls from profile info dictionary instead of resume ID.
    displayImagesArray =  [[ReusedMethods userProfile] valueForKey:@"resume_url"];
    [self addExapandableView];
}
- (void)deleteResumeButtonAction:(id) sender{
    self.selectedDeleteObjectIndexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    [self.delegate deleteSelectedResume];
}
- (void) recommendationImgButtonAction:(id) sender{
    photoIndex  = (int)[sender tag];
    mediaType  =  recommendationType;
    //Getting the urls from profile info dictionary instead of ID.
    displayImagesArray =  [[ReusedMethods userProfile] valueForKey:@"recomendationLettrs_url"];
    [self addExapandableView];
}
- (void)deleteRecommendationButtonAction:(id) sender{
    self.selectedDeleteObjectIndexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    [self.delegate deleteSelectedRecommendation];
}




#pragma mark - EXPANDABLE VIEW FOR IMAGES DISPLAY RELATED METHODS

-(void)createExpandableView
{
    float screenWidth  = [[UIScreen mainScreen] bounds].size.width;
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    expandableView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    expandableView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.9];
    // [self.view addSubview:expandableView];
    
    // Adding UIImageView
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60, screenWidth - 20, screenWidth - 20)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.center = expandableView.center;
    imageView.layer.cornerRadius = 15.0f;
    imageView.layer.masksToBounds = YES;
    
    [expandableView addSubview:imageView];
    
    expandableImageView  = imageView;
    
    // Adding Left and Right Buttons
    leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (imageView.center.y)-75 , 60, 150)];
    [leftButton setImage:[UIImage imageNamed:@"leftarrow"] forState:UIControlStateNormal];
    [leftButton setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.1]];
    [leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    // [expandableView addSubview:leftButton];
    
    rightButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 60, (imageView.center.y)-75, 60, 150)];
    [rightButton setImage:[UIImage imageNamed:@"rightarrow"] forState:UIControlStateNormal];
    [rightButton setBackgroundColor: [UIColor colorWithWhite:0.9 alpha:0.1]];
    [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    //[expandableView addSubview:rightButton];
    
    // Close button
    UIButton * closeButton = [[UIButton alloc] initWithFrame:CGRectMake(expandableView.frame.size.width - 60,30, 50, 50)];
    [closeButton setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeExpandableView) forControlEvents:UIControlEventTouchUpInside];
    [expandableView addSubview:closeButton];
    
    
    // add swipe  gesture  for  expandable  view
    
    UISwipeGestureRecognizer *swipeLeftToRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipePreviousAction:)];
    [swipeLeftToRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [expandableView addGestureRecognizer:swipeLeftToRight];
    UISwipeGestureRecognizer *swipeRightToLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeNextAction:)];
    [swipeRightToLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [expandableView addGestureRecognizer:swipeRightToLeft];
    
}

-(void)closeExpandableView
{
    [expandableView removeFromSuperview];
}

-(void)leftButtonAction
{
    photoIndex--;
    [self loadExpandablemage];
    [self swipeAnimationExpandableImageView:kCATransitionFromLeft];
    
}

-(void)rightButtonAction
{
    photoIndex++;
    [self loadExpandablemage];
    [self swipeAnimationExpandableImageView:kCATransitionFromRight];
}

# pragma  mark  - SWIPE  GESTURE  METHODS

- (void) swipePreviousAction:(UISwipeGestureRecognizer*)sender{
    
    // dont execute  if  the  photo index  0 //  will crash
    if(photoIndex != 0){
        photoIndex--;
        [self loadExpandablemage];
        [self swipeAnimationExpandableImageView:kCATransitionFromLeft];
    }
}

-(void)swipeNextAction:(UISwipeGestureRecognizer*)sender{
    
    //  if photo reaches  count  dont allow  to increse
    if(photoIndex < (displayImagesArray.count -  1)){
        photoIndex++;
        [self loadExpandablemage];
        [self swipeAnimationExpandableImageView:kCATransitionFromRight];
    }
    
}


-(void)addExapandableView
{
    UIWindow *  window  =  [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:expandableView];
    //photoIndex = 0;
    if (displayImagesArray.count == 1)
    {
        leftButton.hidden = YES;
        rightButton.hidden = YES;
    }
    else
    {
        leftButton.hidden = NO;
        rightButton.hidden = NO;
    }
    leftButton.hidden = YES;
    [self loadExpandablemage];
}

-(void)loadExpandablemage
{
    // NSString * imageURL = [[self getProfileImagesArray] objectAtIndex:photoIndex];
    NSIndexPath  *  indexPath  =  [NSIndexPath indexPathForRow:photoIndex inSection:0];
    if(mediaType  ==  imageType)
        [SMSharedFilesClass setProfileImagesOnView:expandableImageView atIndexPath:indexPath];
    else if (mediaType  ==  resumeType)
    {
        //  NSIndexPath  *  indexPath  =  [NSIndexPath indexPathForRow:photoIndex inSection:2];
        [SMSharedFilesClass  setResumeImagesOnView:expandableImageView atIndexPath:indexPath];
    }
    else if (mediaType  ==  recommendationType)
        [SMSharedFilesClass  setLetterOfRecommendationImagesOnView:expandableImageView atIndexPath:indexPath];
    
    if (photoIndex == displayImagesArray.count-1)
    {
        rightButton.hidden = YES;
    }
    else
    {
        rightButton.hidden  = NO;
    }
    if (photoIndex == 0)
    {
        leftButton.hidden = YES;
    }
    else
    {
        leftButton.hidden = NO;
    }
}

//-(void)imageTapLoadExpandViewWithRow:(int)row index:(int)index
//{
//    //selectedPost = [[self getProfileImagesArray] objectAtIndex:row];
//    photoIndex = index;
//    UIWindow *  window  =  [[[UIApplication sharedApplication] delegate] window];
//    [window addSubview:expandableView];
//    [self loadExpandablemage];
//}

-(void)swipeAnimationExpandableImageView:(NSString *)leftRight
{
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setDuration:0.5f];
    [animation setType:kCATransitionPush];
    animation.subtype = leftRight;
    [expandableImageView.layer addAnimation:animation forKey:NULL];
}







@end
