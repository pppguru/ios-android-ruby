//
//  SMUserProfileDescriptionVC.m
//  SwissMonkey
//
//  Created by Kasturi on 1/22/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "SMUserProfileDescriptionVC.h"
#import "UserProfileDescriptionCell.h"
#import "UserProfileFilesListCell.h"
#import "SMScreenTitleButtonsVC.h"
#import "SMUserPicturesVideosDisplayVC.h"

@implementation SMUserProfileDescriptionVC{
    SMUserProfileDescriptionModel *  smUserProfileDescModel;

}

// the function specified in the same class where we defined the addObserver
- (void)profileImageDownload:(NSNotification *)note {
    [SMSharedFilesClass setProfilePicture2Button:profilePicImageView];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setting notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(profileImageDownload:)
                                                 name:@"profileImageUpdateNotification" object:nil];

    // set  up navigation  view
    
    [ReusedMethods setNavigationViewOnView:self.view WithTitle:@"Profile" andBackgroundColor:[UIColor whiteColor]];
    [ReusedMethods setUpLeftButton:self withImageName:@"nav_menu_toggle"];
    [self.menuButton addTarget:self action:@selector(navViewLeftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [ReusedMethods setUpRightButton:self withImageName:@"ProfileEdit" withNotificationsCount:0];
    
    // set  up  delegate class
    smUserProfileDescModel  =  [[SMUserProfileDescriptionModel alloc] init];
    smUserProfileDescModel.delegate  =  self;
    [smUserProfileDescModel callProfileDataAPICall];
    [smUserProfileDescModel createExpandableView];
    //[smUserProfileDescModel createExpandableViewLinear];
    
    //Rounded shaped profile Image
    photosArray = [[NSMutableArray alloc] initWithObjects: @"xxxx",@"xxxx",@"xxxx",@"xxxx",@"xxxx",@"xxxx", nil];
    [self aboutMeButtonAction:aboutMeButton];
    [aboutMeCollectionView registerClass:[UICollectionReusableView class]
              forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
                     withReuseIdentifier:@"HeaderView"];
    [aboutMeCollectionView registerClass:[UICollectionReusableView class]
              forSupplementaryViewOfKind: UICollectionElementKindSectionFooter
                     withReuseIdentifier:@"FooterView"];
//    
//    NSArray *arrayVedios = [SMSharedFilesClass allFilesAtPath:[SMSharedFilesClass profileVideosPath]];
//    if(![arrayVedios count])
//        arrayVedios = [SMSharedFilesClass allFilesAtPath:[SMSharedFilesClass profileTempVideosPath]];
//    
//    for (NSString *string in arrayVedios) {
//        smUserProfileDescModel.thumb = [ReusedMethods generateThumbImage:[[SMSharedFilesClass profileVideosPath] stringByAppendingPathComponent:string]];
//        
////        NSLog(@"Image : %@", _thumb);
//    }
//    NSLog(@"thumb nail image: %@",  [ReusedMethods generateThumbImage:[SMSharedFilesClass]])
    
    
    //Customize the UI
    [self initializeTabButtons];
    
    //Customize the buttons for mail and phone
    
    phoneNumButton.titleLabel.numberOfLines = 1;
    phoneNumButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    phoneNumButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
    
    emailButton.titleLabel.numberOfLines = 1;
    emailButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    emailButton.titleLabel.lineBreakMode = NSLineBreakByClipping;

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    float cornerRadius = profilePicImageView.frame.size.height / 2;
    profilePicImageView.layer.cornerRadius =  cornerRadius;
    profilePicImageView.layer.masksToBounds = YES;
    [SMSharedFilesClass setProfilePicture2Button:profilePicImageView];
    //Getting the image urls from profile info dictionary instead of image ID.
    smUserProfileDescModel.profileImagesArray  =  [[ReusedMethods userProfile] valueForKey:@"image_url"];
    smUserProfileDescModel.profileVideosArray  =  [[ReusedMethods userProfile] valueForKey:@"video_url"];
    
    [aboutMeCollectionView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    float cornerRadius = profilePicImageView.frame.size.height /2 ;
    profilePicImageView.layer.cornerRadius =  cornerRadius ;
    profilePicImageView.layer.masksToBounds = YES;
    
}

#pragma mark - UI Tab Button Customization

- (void) initializeTabButtons {
    //Customize the AboutMe Button
    [aboutMeButton setTitleColor:[UIColor appCustomMediumPurpleColor] forState:UIControlStateNormal];
    [aboutMeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [aboutMeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    //Customize the Work Button
    [workButton setTitleColor:[UIColor appCustomMediumBlueColor] forState:UIControlStateNormal];
    [workButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [workButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    //Set default selected state to AboutMe Button
    [aboutMeButton setSelected:YES];
    [workButton setSelected:NO];
}

- (void)tabButtonSelected:(UIButton*)tabButton {
    [tabButton setSelected:YES];
    
    if (tabButton == aboutMeButton)
        [tabButton setBackgroundColor:[UIColor appCustomPurpleColor]];
    else if (tabButton == workButton)
        [tabButton setBackgroundColor:[UIColor appCustomMediumBlueColor]];
    
    [ReusedMethods applyBottomBorderIndicator:tabButton];
}

- (void)tabButtonDeselected:(UIButton*)tabButton {
    [tabButton setSelected:NO];
    
    if (tabButton == workButton)
        [tabButton setBackgroundColor:[UIColor appCustomLightBlueColor]];
    else if (tabButton == aboutMeButton)
        [tabButton setBackgroundColor:[UIColor appCustomLightPurpleColor]];
    
    [ReusedMethods removeBottomBorder:tabButton];
}

#pragma mark - User Interaction - Tabbar Button

-(IBAction)aboutMeButtonAction:(id)sender
{
    [self tabButtonSelected:aboutMeButton];
    [self tabButtonDeselected:workButton];
    
    aboutMeContainerView.hidden = NO;
    workTableView.hidden = YES;
}

-(IBAction)workButtonAction:(id)sender
{
    [self tabButtonSelected:workButton];
    [self tabButtonDeselected:aboutMeButton];
    
    aboutMeContainerView.hidden = YES;
    workTableView.hidden = NO;
}

#pragma mark - User Interaction - Buttons

//  profile edit button action
- (IBAction)navViewRightButtonAction:(id)sender{
    UIStoryboard * storyBoard =  [UIStoryboard storyboardWithName:SM_ADD_PROFILE_DATA_STORYBOARD bundle:nil];
    SMScreenTitleButtonsVC * smScreentitleButtonsVC  =  [storyBoard instantiateViewControllerWithIdentifier:SM_ADD_PROFILE_TITLES_VC];
    //    smScreentitleButtonsVC.
    [self.navigationController pushViewController:smScreentitleButtonsVC animated:YES];
}

//emailButtonAction to compose email
-(IBAction)emailButtonAction:(id)sender
{
    //[self showComposer:sender];
}

//phoneNumButtonAction to make a call to that num
-(IBAction)phoneNumButtonAction:(id)sender
{
//    NSString *phoneStr = [[NSString alloc] initWithFormat:@"tel:%@",phoneNumButton.titleLabel.text];
//    NSURL *phoneURL = [[NSURL alloc] initWithString:phoneStr];
//    [[UIApplication sharedApplication] openURL:phoneURL];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TABLE VIEW DELEGATE METHODS

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [smUserProfileDescModel tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [smUserProfileDescModel  tableView:tableView numberOfRowsInSection:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [smUserProfileDescModel  tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [smUserProfileDescModel  tableView:tableView heightForRowAtIndexPath:indexPath];
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark - COLLECTION VIEW METHODS

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [smUserProfileDescModel numberOfSectionsInCollectionView:collectionView];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [smUserProfileDescModel collectionView:collectionView numberOfItemsInSection:section];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [smUserProfileDescModel collectionView:collectionView cellForItemAtIndexPath:indexPath];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [smUserProfileDescModel collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return [smUserProfileDescModel collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
}

//Add HEADER to Collection View to display Bio information at the top
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return [smUserProfileDescModel collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
}

//Header size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return [smUserProfileDescModel collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if( indexPath.section  == 0 || indexPath.section == 2 || indexPath.section == 3)
    {
    [smUserProfileDescModel collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
    
    else{
        SMUserPicturesVideosDisplayVC *smUserPicturesVideosDisplayVC  =  [self.storyboard  instantiateViewControllerWithIdentifier:SM_USER_PROFILE_VIDEOS_DISPLAY_VC];
        smUserPicturesVideosDisplayVC.selectedVideoString  =  [[[ReusedMethods  userProfile] objectForKey:@"video_url"] objectAtIndex:indexPath.row];//[smUserProfileDescModel.profileVideosArray objectAtIndex:indexPath.row];
        //[self.navigationController  pushViewController:smUserProfileDescriptionVC animated:YES];
        [self presentViewController:smUserPicturesVideosDisplayVC animated:YES completion:nil];
    }
    
    
    
}



#pragma mark - EMail composer  when tapping on Email button
-(void) showComposer:(id)sender
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil){
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail]){
            [self displayComposerSheet:sender];
        }else{
            [self launchMailAppOnDevice:sender];
        }
    }else{
        [self launchMailAppOnDevice:sender];
    }
}


// Displays an email composition interface inside the application. Populates all the Mail fields.
- (void) displayComposerSheet:(NSString *)body {
    
    MFMailComposeViewController *tempMailCompose = [[MFMailComposeViewController alloc] init];
    tempMailCompose.mailComposeDelegate = self;
    
    body = @"Feedback";
    [tempMailCompose setSubject:@"Subject"];
    [tempMailCompose setToRecipients: [NSArray arrayWithObjects:emailButton.titleLabel.text, nil] ];
    [tempMailCompose setMessageBody:body isHTML:NO];
    [self presentViewController:tempMailCompose animated:YES completion:nil];
    
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Launches the Mail application on the device. Workaround
-(void)launchMailAppOnDevice:(NSString *)body
{
    NSString *recipients = [NSString stringWithFormat:@"mailto:%@?subject=%@", @"", @"SwissMonkey"];
    NSString *mailBody = [NSString stringWithFormat:@"&body=%@", body];
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, mailBody];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

# pragma  mark -   SERVICE CALL DELEGATE METHODS  

- (void)  successResponseCall:(WebServiceCalls *)service{
    
    if ([[service.responseData allKeys] count]) {
        NSLog(@"server response data %@",service.responseData);
        [self  setupProfileData:service.responseData];
       // [SMSharedFilesClass downloadAllImagesAndVideos];
        [SMSharedFilesClass removeUncecceryFiles];
    }
    
}

- (void) showErrorMessages:(NSString *)error{
    [[[RBACustomAlert  alloc] initWithTitle:APP_TITLE message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

#pragma  mark -  SETUP SERVER DATA  IN  UI

- (void) setupProfileData:(NSDictionary *) serverResponseData{
    [ReusedMethods setUserProfile:serverResponseData];
    NSString *address1 = [ReusedMethods replaceNullString:[serverResponseData objectForKey:ADDRESSLINE1] withSpace:YES];
    NSString *address2 = [ReusedMethods replaceNullString:[serverResponseData objectForKey:ADDRESSLINE2] withSpace:YES];
    NSString * state  = [[ReusedMethods replaceNullString:[serverResponseData objectForKey:STATE] withSpace:YES] uppercaseString];
    NSString *city = [ReusedMethods replaceNullString:[serverResponseData objectForKey:CITY] withSpace:YES];
    NSString *zipcode = [ReusedMethods replaceNullString:[serverResponseData objectForKey:ZIP] withSpace:YES];
    NSString  * addressText  = [ReusedMethods  replaceEmptyString:[NSString  stringWithFormat:@"%@\n%@\n%@, %@, %@",address1,address2,city,state,zipcode] emptyString:EMPTY_STRING];
    
    NSString *  nameString  =  [ReusedMethods replaceEmptyString:[ReusedMethods capitalizedString:[serverResponseData objectForKey:NAME]] emptyString:EMPTY_STRING];
    NSString *  role  =  [ReusedMethods replaceEmptyString:[ReusedMethods  getcorrespondingStringWithId:[serverResponseData  objectForKey:POSITION] andKey:POSITION] emptyString:EMPTY_STRING];
    NSString *  emailString =  [ReusedMethods replaceEmptyString:[serverResponseData  objectForKey:EMAIL] emptyString:EMPTY_STRING];
    
    NSString *  serverPhoneNumberString  = [SMValidation changeDisplayFormateOfPhonenumber:[serverResponseData  objectForKey:PHONE_NUMBER]];
    NSString *  ph_Number  = [ReusedMethods replaceEmptyString:serverPhoneNumberString emptyString:EMPTY_STRING];
    
    NSMutableAttributedString *emailAttributedString = [[NSMutableAttributedString alloc] initWithString:emailString ];
    [emailAttributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [emailAttributedString length])];
    
//    NSAttributedString * emailAttributedString  =  [[NSAttributedString alloc] initWithString:emailString];
    NSAttributedString * phNumAttributedString = [[NSAttributedString alloc] initWithString:ph_Number];
    [addressLabel setText:addressText];
   // [emailButton.titleLabel setNumberOfLines:];
   // [emailButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [emailButton setAttributedTitle:emailAttributedString forState:UIControlStateNormal];
    emailButton.titleLabel.attributedText = emailAttributedString;
    [phoneNumButton setAttributedTitle:phNumAttributedString forState:UIControlStateNormal];
    [profileNameLabel setText:nameString];
    [designationLabel setText:role];
    [emailButton setTitleColor:[UIColor appHeadingGrayColor] forState:UIControlStateNormal];
    [phoneNumButton setTitleColor:[UIColor appHeadingGrayColor] forState:UIControlStateNormal];
    profileNameLabel.textColor = [UIColor appHeadingGrayColor] ;
    phoneNumButton.titleLabel.textColor = [UIColor appHeadingGrayColor] ;
    emailButton.titleLabel.textColor = [UIColor appHeadingGrayColor] ;
    
    float  height  =  [basicProfileContainerView   systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    _userContactViewHeightConstraint.constant  =  MAX(CGRectGetMaxY(designationLabel.frame) , height) + 25;
    
    
    [workTableView reloadData];
    [aboutMeCollectionView reloadData];
    
    [SMSharedFilesClass setProfilePicture2Button:profilePicImageView];
}


@end
