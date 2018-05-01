//
//  JobProfileDescriptionVC.m
//  SwissMonkey
//
//  Created by Kasturi on 1/28/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "SMJobProfileDescriptionVC.h"
#import "SMUserProfileDescriptionVC.h"



@implementation SMJobProfileDescriptionVC{
    
    SMJobProfileDescriptionModel *  smJobProfileModel;
}
@synthesize nameLabel, jobTypeLabel, addressLabel, siteLinkButton, phoneButton,emailButton, jobButton, jobInfoTableView,profileInfoTableView, practiceInfoButton, practiceInfoCollectionView;


#pragma mark - LIFE  CYCLE  METHODS


- (void) viewDidLoad{
    
    [super viewDidLoad];
    
    smJobProfileModel  =  [[SMJobProfileDescriptionModel alloc] init];
    smJobProfileModel.delegate  =  self;
    
    // set  up  navigation  view  on the  view
    [ReusedMethods setNavigationViewOnView:self.view WithTitle:@"Results" andBackgroundColor:[UIColor whiteColor]];
    [ReusedMethods setUpLeftButton:self withImageName:@"back"];
//    [smJobProfileModel getJobDetails:_jobID];
    
//    [addressLabel setNumberOfLines:3];
//    [addressLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    
    [[siteLinkButton titleLabel] setTextAlignment:NSTextAlignmentLeft];
    
    //  Set color for job title
    [jobTypeLabel setTextColor:[UIColor appHeadingGrayColor]];
    
    smJobProfileModel.jobDetails = _jobDetails;
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicator.frame = CGRectMake(30, 30, 23, 23);
    [_comapanyLogo addSubview:_activityIndicator];
    [self updateUI];
    [smJobProfileModel createExpandableView];
    
    [practiceInfoCollectionView registerNib:[UINib nibWithNibName:@"PracticeDescriptionCustomView" bundle:nil]
     forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
            withReuseIdentifier:@"PracticeInfoHeaderView"];
    
    //Customize the table view of Job info
    jobInfoTableView.rowHeight = UITableViewAutomaticDimension;
    jobInfoTableView.estimatedRowHeight = 100.f;
    
    //Customize the phone and email
    phoneButton.titleLabel.numberOfLines = 1;
    phoneButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    phoneButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
    
    emailButton.titleLabel.numberOfLines = 1;
    emailButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    emailButton.titleLabel.lineBreakMode = NSLineBreakByClipping;

}

- (void)  viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void) updateUI{
//    NSDictionary *dropDownData = [ReusedMethods sharedObject].dropDownListDict;
//    NSArray *positions = [dropDownData objectForKey:@"positions"];
    NSDictionary *job = _jobDetails;
    NSLog(@"Job : %@", job);
//    NSString *predicateString = [NSString stringWithFormat:@"position_id = %@", [job objectForKey:@"position"]];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
//    NSArray *array = [positions filteredArrayUsingPredicate:predicate];
//    NSDictionary *position = [array firstObject];
    
    [self loadImageInBackground:[job objectForKey:@"company_logo"]];
    NSString *companyName = [ReusedMethods getValidString:[job objectForKey:@"company_name"]];
    NSString  * primaryContactName  =  [ReusedMethods replaceNullString:[job objectForKey:@"contact_name"]  withSpace:YES];
    if([companyName isEqualToString:ANONYMOUS]){
        primaryContactName = ANONYMOUS;
    }
    primaryContactName  =  primaryContactName.length? primaryContactName : @"";
    
    NSString *address1 = [ReusedMethods replaceNullString:[job objectForKey:@"address1"]  withSpace:YES];
    NSString *address2 = [ReusedMethods replaceNullString:[job objectForKey:@"address2"]  withSpace:YES];
    address2  = address2.length ? [NSString stringWithFormat:@",%@",address2]: @"";
    
    NSLog(@"Address Line1: %@, Address Line2: %@",address1,address2);
    
    NSString *city = [ReusedMethods replaceNullString:[job objectForKey:@"city"]  withSpace:YES];
    NSString *state = [[ReusedMethods replaceNullString:[job objectForKey:STATE]  withSpace:YES] uppercaseString];
    NSString *zipcode = [ReusedMethods replaceNullString:[job objectForKey:@"zipcode"]  withSpace:YES];
    
    [nameLabel setText:[job objectForKey:@"position"]];
    [jobTypeLabel setText:[[job objectForKey:@"job_type"] uppercaseString]];
    NSLog(@"website= == ==%@", [job objectForKey:@"website"]);

    NSString *webSiteAddres =  [job objectForKey:@"website"]?  [job objectForKey:@"website"] : @"- - -";
    
    if (webSiteAddres.length == 0 ) {
        webSiteAddres = @"- - -";
    }
//    [siteLinkButton setTitle:webSiteAddres forState:UIControlStateNormal];
    if (![webSiteAddres isEqualToString:@"- - -"]
        && ![webSiteAddres isEqualToString:ANONYMOUS]){
        
        NSMutableAttributedString *websiteTitle = [[NSMutableAttributedString alloc] initWithString:webSiteAddres];
        
        [websiteTitle addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [websiteTitle length])];
        [websiteTitle addAttribute:NSForegroundColorAttributeName value:[UIColor appPinkColor] range:NSMakeRange(0, [websiteTitle length])];
        [siteLinkButton setAttributedTitle:websiteTitle forState:UIControlStateNormal];
    }
    
    [siteLinkButton setTitle:webSiteAddres forState:UIControlStateNormal];
    [siteLinkButton setTitle:webSiteAddres forState:UIControlStateHighlighted];
    
    self.mainContactLabel.text = primaryContactName;
    self.companyLabel.text = companyName;
//    [addressLabel setText:[NSString stringWithFormat:@"%@ %@ %@ %@", [job objectForKey:@"address1"], [job objectForKey:@"address2"], [job objectForKey:@"city"], [job objectForKey:@"zipcode"]]];
    
//    [practiceInfoButton setBackgroundColor:[UIColor redColor]];
    [addressLabel setText:[NSString stringWithFormat:@"%@%@\n%@, %@, %@",address1, address2,city,state,zipcode]];
    NSString *phoneNumber = [SMValidation changeDisplayFormateOfPhonenumber:[_jobDetails objectForKey:@"company_phoneno"]];
    NSString *emailID = [ReusedMethods replaceNullString:[_jobDetails objectForKey:@"company_email"] withSpace:YES];
    if(phoneNumber){
        [phoneButton setTitle:phoneNumber forState:UIControlStateNormal];
        [phoneButton setImage:[UIImage imageNamed:@"phone_icon"] forState:UIControlStateNormal];
    }
    else{
        [phoneButton setTitle:nil forState:UIControlStateNormal];
    }
    
    if(emailID && ![companyName isEqualToString:ANONYMOUS]){
        //[emailButton setTitle:emailID forState:UIControlStateNormal];
        [emailButton setImage:[UIImage imageNamed:@"email"] forState:UIControlStateNormal];
        
        NSMutableAttributedString *emailAttributedString = [[NSMutableAttributedString alloc] initWithString:emailID ];
        [emailAttributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [emailAttributedString length])];
        [emailAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor appLightTextColor] range:NSMakeRange(0, [emailAttributedString length])];

        [emailButton setAttributedTitle:emailAttributedString forState:UIControlStateNormal];
        emailButton.titleLabel.attributedText = emailAttributedString;
    }
    else{
        [emailButton setTitle:nil forState:UIControlStateNormal];
    }
    
    //  make  empty  if practiceInfo is anonymous
    if([companyName isEqualToString:ANONYMOUS]){
        [siteLinkButton setTitle:SPACE forState:UIControlStateNormal];
        siteLinkButton.titleLabel.text = SPACE;
        [addressLabel setText:[NSString stringWithFormat:@"%@, %@, %@",city,state,zipcode]];
        [emailButton setTitle:nil forState:UIControlStateNormal];
        [phoneButton setTitle:nil forState:UIControlStateNormal];
    }
    //  make  empty  if contact name is anonymous
    if([primaryContactName containsString:ANONYMOUS]){
        
        if([companyName isEqualToString:ANONYMOUS]){
        [addressLabel setText:[NSString stringWithFormat:@"%@, %@, %@",city,state,zipcode]];
        }
        
        
        [phoneButton setTitle:nil forState:UIControlStateNormal];
        [emailButton setTitle:nil forState:UIControlStateNormal];
        [emailButton setAttributedTitle:nil forState:UIControlStateNormal];
        emailButton.titleLabel.attributedText = nil;

    }
    
//    [siteLinkButton.titleLabel setText:companyName];
    [_comapanyLogo.layer setCornerRadius:CGRectGetHeight(_comapanyLogo.frame) / 2.0];
    [_comapanyLogo.layer setMasksToBounds:YES];
//    [siteLinkButton setUserInteractionEnabled:NO];
//    [siteLinkButton setBackgroundColor:[UIColor redColor]];
//    NSLog(@"%@", job);
    
    //Customize the tab buttons
    [self initializeTabButtons];
    
    //Customize the apply button
    [ReusedMethods applyGreenButtonStyle:self.jobProfileApplyNowButton];
    
}

- (void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

}

#pragma mark - UI Tab Button Customization

- (void) initializeTabButtons {
    //Customize the Job  Button
    [jobButton setTitleColor:[UIColor appCustomMediumPurpleColor] forState:UIControlStateNormal];
    [jobButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [jobButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    //Customize the Practice Info Button
    [practiceInfoButton setTitleColor:[UIColor appCustomMediumBlueColor] forState:UIControlStateNormal];
    [practiceInfoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [practiceInfoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    //Set default selected state to Job Button
    [self tabButtonSelected:jobButton];
    [self tabButtonDeselected:practiceInfoButton];
}

- (void)tabButtonSelected:(UIButton*)tabButton {
    [tabButton setSelected:YES];
    
    if (tabButton == jobButton)
        [tabButton setBackgroundColor:[UIColor appCustomPurpleColor]];
    else if (tabButton == practiceInfoButton)
        [tabButton setBackgroundColor:[UIColor appCustomMediumBlueColor]];
    
    [ReusedMethods applyBottomBorderIndicator:tabButton];
}

- (void)tabButtonDeselected:(UIButton*)tabButton {
    [tabButton setSelected:NO];
    
    if (tabButton == practiceInfoButton)
        [tabButton setBackgroundColor:[UIColor appCustomLightBlueColor]];
    else if (tabButton == jobButton)
        [tabButton setBackgroundColor:[UIColor appCustomLightPurpleColor]];
    
    [ReusedMethods removeBottomBorder:tabButton];
}

#pragma mark - Image Load


- (void) loadImageInBackground :(NSString *) strURL{
    NSURL* url = [NSURL URLWithString:strURL];
    if(url){
        [_comapanyLogo setBackgroundColor:[UIColor blackColor]];
        _activityIndicator.hidden = NO;
        [_activityIndicator startAnimating];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse * response,
                                                   NSData * data,
                                                   NSError * error) {
                                   if (!error){
                                       [_comapanyLogo setBackgroundColor:[UIColor clearColor]];
                                       _comapanyLogo.image = [UIImage imageWithData:data];
                                       _activityIndicator.hidden = YES;
                                       [_activityIndicator stopAnimating];
                                       // do whatever you want with image
                                   }
                                   
                               }];
    }
}

#pragma mark - BUTTON ACTIONS

- (IBAction)siteLinkButtonAction:(id)sender {
    NSString *urlString = [smJobProfileModel.jobDetails objectForKey:@"website"];
    if (![urlString containsString:@"http://"] && ![urlString containsString:@"https://"]) {
        urlString = [NSString stringWithFormat:@"http://%@",[smJobProfileModel.jobDetails objectForKey:@"website"]];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    
    if(url && [[UIApplication sharedApplication] canOpenURL:url])
        [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)phoneCallButtonAction:(id)sender {
    NSString *phoneNumber = [SMValidation  formatePhoneNumberTxtFieldString:[phoneButton titleForState:UIControlStateNormal]];
    if(phoneNumber){
        NSString *phoneStr = [[NSString alloc] initWithFormat:@"tel:%@",phoneNumber];
        NSURL *phoneURL = [[NSURL alloc] initWithString:phoneStr];
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
}

- (IBAction) emailButtonAction: (id)sender{
    if(emailButton.titleLabel.text.length){
    [self showComposer:nil];
    }
}

- (IBAction) updateMenuButtonsStatus:(id) sender{
    BOOL jobButtonClicked =  ([sender tag] == JOBBUTTON_TAG) ? YES : NO;
    if(jobButtonClicked){
        [self tabButtonSelected:jobButton];
        [self tabButtonDeselected:practiceInfoButton];
    }
    else{
        [self tabButtonSelected:practiceInfoButton];
        [self tabButtonDeselected:jobButton];
    }
    
    [jobInfoTableView  setHidden:!jobButtonClicked];
    [practiceInfoCollectionView setHidden:jobButtonClicked];
}

- (IBAction) applyNowButtonAction:(id)sender{
   
    // RBACustomAlert * alert =  [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"Your Profile will be sent to the employer.\nWould you like to send it?" delegate:self cancelButtonTitle:@"No, Review It" otherButtonTitles:@"Yes, Send It",nil];
    
    RBACustomAlert * alert =  [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"Your Profile will be sent to the employer.\nWould you like to send it?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    [alert setTag:APPLYNOW_ALERT_TAG];
    [alert show];
}

- (IBAction)navViewLeftButtonAction:(id)sender{
    [self.navigationController  popViewControllerAnimated:YES];
}


#pragma mark - EMail composer  when tapping on Email button
-(void) showComposer:(NSString *)sender
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
    
    body = @"";
    [tempMailCompose setSubject:@"Swiss Monkey: Job Inquiry"];
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



#pragma  mark  - TABLE  VIEW  DELEGATE METHODS

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [smJobProfileModel tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [smJobProfileModel  tableView:tableView numberOfRowsInSection:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [smJobProfileModel  tableView:tableView cellForRowAtIndexPath:indexPath];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [smJobProfileModel  tableView:tableView heightForRowAtIndexPath:indexPath];
//}

#pragma mark - COLLECTION VIEW  DELEGATE METHODS

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return [smJobProfileModel  numberOfSectionsInCollectionView:collectionView];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return [smJobProfileModel collectionView:collectionView numberOfItemsInSection:section];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [smJobProfileModel  collectionView:collectionView cellForItemAtIndexPath:indexPath];
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    return [smJobProfileModel collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section{
    return  [smJobProfileModel collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return [smJobProfileModel collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [smJobProfileModel collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
}


#pragma mark - ALERT VIEW DELEGATE METHODS

- (void) alertView:(RBACustomAlert *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([alertView tag]  == APPLYNOW_ALERT_TAG ){
        if(buttonIndex  != [alertView cancelButtonIndex]){
            // move to profile description page
            [smJobProfileModel applyJob];
            
//            UIStoryboard * storyboard  =  [UIStoryboard storyboardWithName:SM_USER_PROFILE_DESCRIPTION_STORYBOARD bundle:nil];
//            SMUserProfileDescriptionVC *  profileVC  =  [storyboard instantiateViewControllerWithIdentifier:SM_PROFILE_DESCRIPTION_VC];
//            [self.navigationController pushViewController:profileVC animated:YES];
            
        }else{
            
            
            // send  application to server
            
        }
    }
}

@end
