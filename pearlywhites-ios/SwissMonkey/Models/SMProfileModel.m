//
//  SMProfileModel.m
//  SwissMonkey
//
//  Created by Kasturi on 05/01/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "SMProfileModel.h"

@implementation SMProfileModel{
    NSTimer * timer;
    TYMProgressBarView *progressBarView;
    
    int photoIndex;
    MediaType   mediaType;
    UIView * expandableView;
    UIImageView * expandableImageView;
    NSArray * displayImagesArray;
    UIButton * leftButton,*rightButton;

}

- (id)  init{
    
    if(self){
        
        self  =  [super init];
        
    }
    return self;
}

-(void) callProfileDataAPICall
{
    APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_INFO ModuleName:MODULE_PROFILE MethodType:METHOD_TYPE_POST Parameters:nil SuccessCallBack:@selector(successAPICall:) AndFailureCallBack:@selector(failedAPICall:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
    [service makeWebServiceCall];
}

#pragma mark - Login Success Call Back Method

-(void) successAPICall:(WebServiceCalls *)service
{
    //    NSLog(@"authtoken : %@", [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_AUTHTKEN]);
    [_delegate successResponseCall:service.responseData];
}

-(void) failedAPICall:(NSError *)error
{
    @try {
        if([error isKindOfClass:[NSError class]])
            [_delegate showErrorMessages:[error.userInfo objectForKey:@"NSLocalizedDescriptionKey"]];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

#pragma mark - PROGRESS VIEW IMPLEMENTATION


- (TYMProgressBarView *) getProgressbarViewwithFrame{
    
    // Create a progress bar view and set its appearance
  progressBarView = [[TYMProgressBarView alloc] initWithFrame:CGRectZero];
    progressBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
   // progressBarView.barBorderWidth = 0.0;
    //progressBarView.barBorderColor = [UIColor clearColor];
    //progressBarView.barFillColor  =  [UIColor appPinkColor];
    //progressBarView.barInnerBorderWidth = 0.0;
    //progressBarView.barInnerBorderColor = [UIColor clearColor];
    //progressBarView.barBackgroundColor =  [UIColor appLightGrayColor];
    
    // Set the progress
    progressBarView.progress = 0.2f;
    progressBarView.progress = 10.0f;
    
     timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(incrementProgress:) userInfo:nil repeats:YES];
    
    
    return progressBarView;
}

- (void)incrementProgress:(NSTimer *)timer {
    progressBarView.progress = progressBarView.progress + 0.01f;
    if (progressBarView.progress == 1.0) {
        progressBarView.progress = 0.0;
    }
}

#pragma mark  - DISPLAYING  THUMBNAILS AND  DELETING


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
       
        
        [imgButton setBackgroundColor:[UIColor clearColor]];
        imgButton.layer.borderWidth = 0.5f;
        imgButton.layer.borderColor = [[UIColor appGrayColor] CGColor];
        imgButton.layer.cornerRadius = CGRectGetWidth(imgButton.frame)/2;
        imgButton.layer.masksToBounds = YES;
        [imageBGView addSubview:imgButton];
        
        float deleteButtonWidth  = 20;
        float deleteXpos  = CGRectGetMaxX(imgButton.frame) -  deleteButtonWidth;
        float deleteYpos  =  CGRectGetMinY(imgButton.frame) - 5;
        
        
        UIButton *  deleteButton  =  [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setFrame:CGRectMake(deleteXpos, deleteYpos, deleteButtonWidth, deleteButtonWidth)];
        [deleteButton setTag:i];
        [[deleteButton layer] setCornerRadius:CGRectGetWidth(deleteButton.frame)/2];
        [[deleteButton layer] setMasksToBounds:YES];
        
        if(bgView.tag == PROFILE_PHOTOS_DISPLAY_BGVIEW_TAG)
            [deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        else if(bgView.tag == PROFILE_VIDEOS_DISPLAY_BGVIEW_TAG)
            [deleteButton addTarget:self action:@selector(deleteVideoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
       
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
    //Getting the image urls from profile info dictionary instead of image ID.
    switch (tag) {
        case PROFILE_PHOTOS_DISPLAY_BGVIEW_TAG:
            return  [[ReusedMethods userProfile] valueForKey:@"image_url"];
            break;
        case PROFILE_VIDEOS_DISPLAY_BGVIEW_TAG:
            return [[ReusedMethods userProfile] valueForKey:@"video_url"];
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
        default:
            break;
    }
    
}

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
    //Getting the urls from profile info dictionary instead of ID.
    [self.delegate displaySelectedVideo:[[[ReusedMethods userProfile] valueForKey:@"video_url"] objectAtIndex:[sender tag]]];
}
- (void)deleteVideoButtonAction:(id) sender{
    self.selectedDeleteObjectIndexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    [self.delegate deleteSelectedVideo];
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
