//
//  SMUserPicturesVideosDisplayModel.m
//  SwissMonkey
//
//  Created by Kasturi on 3/1/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "SMUserPicturesVideosDisplayModel.h"

@implementation SMUserPicturesVideosDisplayModel
@synthesize profileImagesArray,profileVideosArray;

- (id) init{
    
    self  =  [super init];
    if(self){
       // profileImagesArray  =  [SMSharedFilesClass getProfileImagesArray];
       // profileVideosArray  =  [SMSharedFilesClass  getProfileVideosArray];
    }
    return self;
}


#pragma mark - IMAGES DISPLAY RELATED METHODS
-(void)createExpandableView
{
    float screenWidth  = [[UIScreen mainScreen] bounds].size.width;
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    expandableView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    expandableView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.9];
    // [self.view addSubview:expandableView];
    
    // Adding UIImageView
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60, screenWidth - 20, screenWidth - 20)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
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

# pragma  mark  --------- SWIPE  GESTURE  METHODS  -------
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
    //Getting the image urls from profile info dictionary instead of image ID.
    if(photoIndex < ([[[ReusedMethods userProfile] valueForKey:@"image_url"] count] -  1)){
        photoIndex++;
        [self loadExpandablemage];
        [self swipeAnimationExpandableImageView:kCATransitionFromRight];
    }
    
}


-(void)addExapandableViewOnView:(UIView *) selfView
{
   // UIWindow *  window  =  [[[UIApplication sharedApplication] delegate] window];
    [selfView addSubview:expandableView];
    //photoIndex = 0;
    
    //Getting the image urls from profile info dictionary instead of image ID.
    if ([[[ReusedMethods userProfile] valueForKey:@"image_url"] count] == 1)
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
    [SMSharedFilesClass setProfileImagesOnView:expandableImageView atIndexPath:indexPath];
    //Getting the image urls from profile info dictionary instead of image ID.
    if (photoIndex == [[[ReusedMethods userProfile] valueForKey:@"image_url"] count]-1)
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

#pragma mark - VIDEOS DISPLAY RELATED METHODS

- (NSArray *) getProfileVideosArray{
    NSString *path = [SMSharedFilesClass profileTempVideosPath];
    NSArray *videos = [SMSharedFilesClass allFilesAtPath:path];
    if(![videos count]){
        path = [SMSharedFilesClass profileVideosPath];
        videos = [SMSharedFilesClass allFilesAtPath:path];
    }
    return videos;
}

- (void) setUpWebViewForDisplayVideosOnView:(UIView *) selfView{
    UIWebView *  webView  =  [[UIWebView alloc]  initWithFrame:CGRectMake(0, NAVIGATION_HEIGHT, CGRectGetWidth(selfView.frame), CGRectGetHeight(selfView.frame)  -  (2 * NAVIGATION_HEIGHT))];
    webView.delegate  =  (id)self.delegate;
    [selfView addSubview:webView];
}


@end
