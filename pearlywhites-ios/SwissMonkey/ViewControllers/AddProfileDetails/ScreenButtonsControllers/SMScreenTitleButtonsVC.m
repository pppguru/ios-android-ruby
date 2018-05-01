//
//  SMScreenTitleButtonsVC.m
//  SwissMonkey
//
//  Created by Kasturi on 2/3/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "SMScreenTitleButtonsVC.h"
#import "MBXPageViewController.h"
#import "SMUserProfileDescriptionVC.h"
#import "CircleLoaderView.h"

@interface SMScreenTitleButtonsVC () <MBXPageControllerDataSource, MBXPageControllerDataDelegate> {
    MBXPageViewController *MBXPageController;
}

@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button1;

@property (weak, nonatomic) IBOutlet UIView *container;

@end

@implementation SMScreenTitleButtonsVC


- (void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    //    [self.contentView setNeedsLayout];
    //    [self.contentView layoutIfNeeded];
    //
    //    CGFloat height   =  [self.contentView   systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    //
    //    height  =  MAX(height, CGRectGetMaxY(progressBarView.frame) + 15);
    //
    //
    //    contentViewHeightConstraint.constant  =  height ;
    
    [self updateUI];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Initialize the local variable
    self.indexProfileDetail = 0;
    
    // Initiate MBXPageController
    MBXPageController = [MBXPageViewController new];
    MBXPageController.MBXDataSource = self;
    MBXPageController.MBXDataDelegate = self;
    [MBXPageController reloadPages];
    
    // set  up  navigation  view  on the  view
    [ReusedMethods setNavigationViewOnView:self.view WithTitle:@"Profile" andBackgroundColor:[UIColor whiteColor]];
    [ReusedMethods setUpLeftButton:self withImageName:@"nav_menu_toggle"];
   // [ReusedMethods setUpRightButton:self withImageName:@"ProfileEdit" withNotificationsCount:0];
    [self setUpSaveButton];
    
    //Register the notification for saving profile
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveProfileSavedNotification:)
                                                 name:@"saveCurrentProfileDetail"
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void) receiveProfileSavedNotification:(NSNotification*)notification {
    
    if (self.indexProfileDetail == 3) { // Last page
        AppDelegate *appDelegate  =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (![appDelegate.navController.topViewController isKindOfClass:[SMUserProfileDescriptionVC class]]) {
            UIStoryboard * storyboard  =  [UIStoryboard storyboardWithName:SM_USER_PROFILE_DESCRIPTION_STORYBOARD bundle:nil];
            UIViewController *profileVC  = [storyboard instantiateViewControllerWithIdentifier:SM_PROFILE_DESCRIPTION_VC];
            [appDelegate.navController pushViewController:profileVC animated:YES];
        }
    }
    else {
        [MBXPageController moveToViewNumber:self.indexProfileDetail + 1];
    }
}

- (void) setUpSaveButton{
    
    UIButton * saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setFrame :CGRectMake(CGRectGetWidth(self.view.frame) - 80, 25, 70, 35)];
    [saveButton  setTitle:@"SAVE" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[saveButton titleLabel] setFont:[UIFont appLatoBlackFont12]];
    [saveButton addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [ReusedMethods applyGreenButtonStyle:saveButton];
    [self.view addSubview:saveButton];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self updateUI];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void) updateUI{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MBXPageViewController Delegate
- (void)MBXPageChangedToIndex:(NSInteger)index
{
    self.indexProfileDetail = index;
}

#pragma mark - MBXPageViewController Data Source

- (NSArray *)MBXPageButtons
{
    // return @[self.menuButton1, self.menuButton2, self.menuButton3,self.menuButton4];
    return @[self.button1, self.button2, self.button3,self.button4];
}

- (UIView *)MBXPageContainer
{
    return self.container;
}

- (NSArray *)MBXPageControllers
{
    // You can Load a VC directly from Storyboard
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:SM_ADD_PROFILE_DATA_STORYBOARD bundle:nil];
    
    UIViewController *demo   = [mainStoryboard instantiateViewControllerWithIdentifier:@"SMAddProfileDetailsFirstController"];
    UIViewController *demo2  = [mainStoryboard instantiateViewControllerWithIdentifier:@"SMAddProfileDetailsSecondController"];
    UIViewController *demo3  = [mainStoryboard instantiateViewControllerWithIdentifier:@"SMAddProfileDetailsThirdController"];
    UIViewController *demo4  = [mainStoryboard instantiateViewControllerWithIdentifier:@"SMAddProfileDetailsFourthController"];
    
    
    // Or Load it from a xib file
    //    UIViewController *demo3 = [UIViewController new];
    //    demo3.view = [[[NSBundle mainBundle] loadNibNamed:@"View" owner:self options:nil] objectAtIndex:0];
    
    //    // Or create it programatically
    //    UIViewController *demo4 = [[UIViewController alloc] init];
    //    demo4.view.backgroundColor = [UIColor orangeColor];
    
    //    UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake( (self.view.frame.size.width - 130)/2 , 40, 130, 40)];
    //    fromLabel.text = @"Fourth Controller";
    //
    //    [demo4.view addSubview:fromLabel];
    
    // The order matters.
    return @[demo,demo2, demo3, demo4];
}


#pragma mark - BUTTON ACTION METHODS

//- (IBAction)navViewRightButtonAction:(id)sender{
//    [self.navigationController  popViewControllerAnimated:YES];
//    
//}
//
//- (IBAction) navViewLeftButtonAction:(id)sender{
//    [self.navigationController  popViewControllerAnimated:YES];
//}

- (IBAction)saveButtonAction:(id)sender{
    [self.view endEditing:YES];
    if ([ReusedMethods isAccountInActive]) {
        Reachability *reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
        if(reachability.currentReachabilityStatus != NotReachable){
            
            BOOL result  =   [ReusedMethods validationsForProfileData:self.indexProfileDetail];
        if(result){
            [CircleLoaderView addToWindow];
            [ReusedMethods saveUserProfile];
        }
        }
        else{
            [self.view endEditing:YES];
            [[[RBACustomAlert alloc] initWithTitle:@"No Internet" message:@"Please check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        }
    }else{
        [[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:ACCOUNT_DEACTIVATED_MESSAGE delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    
}

#pragma mark - Uploading files

- (void) uploadImages{
    if([SMSharedFilesClass filesCountAtPath:[SMSharedFilesClass profileTempImagesPath]]){
        _mediaType = imageType;
        [self uploadFiles];
    }
    else{
        [self uploadVideos];
    }
}

- (void) uploadVideos{
    if([SMSharedFilesClass filesCountAtPath:[SMSharedFilesClass profileTempVideosPath]]){
        _mediaType = videoType;
        [self uploadFiles];
    }
    else{
        [self uploadPicture];
    }
}

- (void) uploadVideosThumbnails{
    if([SMSharedFilesClass filesCountAtPath:[SMSharedFilesClass profileTempVideoThumbNailPath]]){
        _mediaType = videoThumbnailType;
        [self uploadFiles];
    }
    else{
        [self uploadPicture];

    }
}



- (void) uploadPicture{
    if([SMSharedFilesClass filesCountAtPath:[SMSharedFilesClass profileTempPicturePath]]){
        _mediaType = pictureType;
        [self uploadFiles];
    }
    else{
//        [ReusedMethods saveUserProfile];
        [self uploadResume];
    }
}

- (void) uploadResume{
    if([SMSharedFilesClass filesCountAtPath:[SMSharedFilesClass profileTempResumePath]]){
        _mediaType = resumeType;
        [self uploadFiles];
    }
    else{
        [self uploadRecommendationLetters];
    }
}

- (void) uploadRecommendationLetters{
    if([SMSharedFilesClass filesCountAtPath:[SMSharedFilesClass profileTempRecommendationLettersPath]]){
        _mediaType = recommendationType;
        [self uploadFiles];
    }
    else{
        [self callProfileDataAPICall];
    }
    
}

- (void) uploadFiles{
    [SMSharedFilesClass sharedFileObject].uploadingCount += 1;
    NSLog(@"INC: Uploading server call count : %ld", [SMSharedFilesClass sharedFileObject].uploadingCount);
    [SMSharedFilesClass uploadAllLocalFilesToServer:self andMediaType:_mediaType];
}


#pragma mark - Server Respnose

-(void) callProfileDataAPICall
{
    APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_INFO ModuleName:MODULE_PROFILE MethodType:METHOD_TYPE_POST Parameters:nil SuccessCallBack:@selector(successInfoAPICall:) AndFailureCallBack:@selector(failedInfoAPICall:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
    [service setNoLoader:NO];
    [service makeWebServiceCall];
}

- (void) successInfoAPICall:(WebServiceCalls *) server{
    
    [ReusedMethods setUserProfile:server.responseData];
    [[ReusedMethods sharedObject] setUserProfileInfo:[NSMutableDictionary dictionaryWithDictionary:server.responseData]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"profileImageUpdateNotification" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"profileUpdateNotificationForCurrentVC" object:nil];
}

- (void) failedInfoAPICall:(WebServiceCalls *) server{
    [self callProfileDataAPICall];
}


#pragma mark - File Upload Delegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"Response status code : %d", request.responseStatusCode);
    if (request.responseStatusCode != 200) {
        [self handleFileUploadError:request];
        return;
    }
    
    NSString *str = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
//    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//    httpResponse.statusCode
    NSLog(@"Success: %@", str);
//    NSLog(@"responseHeaders : %@", request.responseHeaders);
    [self moveAllTempFiles2images];
    
    if(_mediaType == imageType){
        [self uploadVideos];
//        [ReusedMethods uploadAllLocalImagesToServer:self];
    }
    else if (_mediaType == videoType){
//        [self uploadVideosThumbnails];
//    }
//    else if (_mediaType == videoThumbnailType){
        [self uploadPicture];
    }
    else if (_mediaType == pictureType){
//        [CircleLoaderView removeFromWindow];
//        [ReusedMethods saveUserProfile];
        [self uploadResume];
    }
    else if (_mediaType == resumeType){
        [self uploadRecommendationLetters];
    }
    else{
        [self callProfileDataAPICall];
    }
    [SMSharedFilesClass sharedFileObject].uploadingCount -= 1;
    NSLog(@"DNC: Uploading server call count : %ld", [SMSharedFilesClass sharedFileObject].uploadingCount);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"profileImageUpdateNotification" object:nil];
//    [CircleLoaderView removeFromWindow];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self handleFileUploadError:request];
}
    
    

- (void) handleFileUploadError:(ASIHTTPRequest *)request {
    
    [CircleLoaderView removeFromWindow];
    //    if (_mediaType == pictureType){
    //        [ReusedMethods saveUserProfile];
    //    }
    [self moveAllTempFiles2images];
    [SMSharedFilesClass sharedFileObject].uploadingCount -= 1;
    NSLog(@"DNC: Uploading server call count : %ld", [SMSharedFilesClass sharedFileObject].uploadingCount);
    //    NSString *str = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"Failed: %@", request.error);
    
    NSString * errmsg;
    if(request.error){
        errmsg = [[request.error userInfo] objectForKey:@"NSLocalizedDescription"]; //[request.error objectForKey:@"NSLocalizedDescription"];
    }else{
        errmsg  =  @"something went wrong";
    }
    
    RBACustomAlert  * alert  =  [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:errmsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


- (void) moveAllTempFiles2images
{
    NSString *path = [SMSharedFilesClass tempPathForKey:_mediaType];
    
//    if(_mediaType == imageType){
//        path = [SMSharedFilesClass profileTempImagesPath];
//    }
//    else{
//        path = [SMSharedFilesClass profileTempVideosPath];
//    }
    
    
    NSArray *allTempData = [SMSharedFilesClass allFilesAtPath:path];
    
    [self  removeFileAtPath:path];
    if(_mediaType  == videoType){
        NSString *thumbNailPath = [SMSharedFilesClass tempPathForKey:videoThumbnailType];
        [self  removeFileAtPath:thumbNailPath];
    }
    return;
    
    for (NSString *sourcePath in allTempData)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        NSString *temp = [path stringByDeletingLastPathComponent];
        NSString *toPath = [temp stringByAppendingPathComponent:[sourcePath lastPathComponent]];
        NSString *tempPath = [path stringByAppendingPathComponent:[sourcePath lastPathComponent]];
        if([fileManager copyItemAtPath:tempPath toPath:toPath error:&error])
        {
            [fileManager removeItemAtPath:tempPath error:&error];
            NSLog(@"Moved image : %@", sourcePath);
        }
        else
        {
            NSLog(@"Could not move image : %@", sourcePath);
        }
    }
    NSArray *allFiles = [SMSharedFilesClass allFilesAtPath:path];
    NSLog(@"%@", allFiles);
//    [_serverCall.arrayTempFiles removeAllObjects];
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
