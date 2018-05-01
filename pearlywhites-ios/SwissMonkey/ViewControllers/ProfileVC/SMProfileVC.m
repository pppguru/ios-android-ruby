//
//  SMProfileVC.m
//  SwissMonkey
//
//  Created by Kasturi on 31/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import "SMProfileVC.h"
#import "SMAddProfileDetailsVC.h"
#import "SMScreenTitleButtonsVC.h"
#import "SMUserProfileDescriptionVC.h"
#import "UIButton+BackgroundContentMode.h"

@implementation SMProfileVC

@synthesize nameLabel,mailLabel,profileButton,progressView;

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    float cornerRadius = profileButton.frame.size.height /2 ;
    profileButton.layer.cornerRadius =  cornerRadius ;
    profileButton.layer.masksToBounds = YES;
}

- (void) viewDidLoad{
    
    [super viewDidLoad];
    
   // UIColor *firstColor = [UIColor colorWithHexString:@"87FC70"];
   // UIColor *secondColor = [UIColor colorWithHexString:@"0BD318"];
    
    // setting up new gradient colors
    //[self.label gradientEffectWithFirstColor:firstColor secondColor:secondColor];
    
    // overriding root controllers label, image and imageview
    // UIImage *newImage = [UIImage imageNamed:@"about-48"];
    // self.imageView.image = [newImage changeImageColor:[UIColor blackColor]];
    
    // set  up  navigation  view  on the  view
    
    nameLabel.text  = @"";
    mailLabel.text  = @"";
    
    [ReusedMethods setNavigationViewOnView:self.view WithTitle:@"Profile" andBackgroundColor:[UIColor whiteColor]];
    [ReusedMethods setUpLeftButton:self withImageName:@"nav_menu_toggle"];
    //[ReusedMethods setUpRightButton:self withImageName:@"ProfileEdit" withNotificationsCount:0];
    [self.menuButton addTarget:self action:@selector(navViewLeftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _profileModel = [[SMProfileModel alloc] init];
    [_profileModel setDelegate:self];
    [_profileModel callProfileDataAPICall];
    
    //Update the content mode of profile button
    [self.profileButton setBackgroundContentMode:UIViewContentModeScaleAspectFill];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [SMSharedFilesClass setProfilePicture2Button:profileButton];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.progressView.progress  =  [ReusedMethods profileProgresValue] ;
}

//- (void) navViewLeftButtonAction:(id)sender{
//    
//}

- (void) showErrorMessages:(NSString *)error{
    
}

- (void) successResponseCall:(NSDictionary *)profileInfo {
//    NSLog(@"Profile Info : %@", profileInfo);
//    NSLog(@"Profile Info : %@", [[ReusedMethods sharedObject] userProfileInfo]);
    
    [[[ReusedMethods sharedObject] userProfileInfo] removeAllObjects];
//    NSLog(@"Profile Info : %@", [[ReusedMethods sharedObject] userProfileInfo]);
    [[[ReusedMethods sharedObject] userProfileInfo] addEntriesFromDictionary:profileInfo];
    [ReusedMethods setUserProfile:[[ReusedMethods sharedObject] userProfileInfo]];
//    NSLog(@"Profile Info : %@", [[ReusedMethods sharedObject] userProfileInfo]);
    nameLabel.text  =  [ReusedMethods capitalizedString:[profileInfo objectForKey:@"name"]];
    mailLabel.text  = [profileInfo objectForKey:@"email"];
    //[SMSharedFilesClass downloadAllImagesAndVideos];
    
    self.progressView.progress  =  [ReusedMethods profileProgresValue] ;
    [SMSharedFilesClass removeUncecceryFiles];
//    NSString *zipCode = [profileInfo objectForKey:@"zipcode"];
    
    //Check if profile is filled
    if([ReusedMethods isProfileFilled]){
        [self navigate2ProfileScreen];
    }
}

- (IBAction)completeProfileButtonAction:(id)sender {
    UIStoryboard * storyBoard =  [UIStoryboard storyboardWithName:SM_ADD_PROFILE_DATA_STORYBOARD bundle:nil];
    SMScreenTitleButtonsVC * smScreentitleButtonsVC  =  [storyBoard instantiateViewControllerWithIdentifier:SM_ADD_PROFILE_TITLES_VC];
//    smScreentitleButtonsVC.
    [self.navigationController pushViewController:smScreentitleButtonsVC animated:YES];
}

- (void) navigate2ProfileScreen{
    AppDelegate *appDelegate  =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIStoryboard * storyboard  =  [UIStoryboard storyboardWithName:SM_USER_PROFILE_DESCRIPTION_STORYBOARD bundle:nil];
    SMUserProfileDescriptionVC *  profileVC  =  [storyboard instantiateViewControllerWithIdentifier:SM_PROFILE_DESCRIPTION_VC];
    [appDelegate.navController pushViewController:profileVC animated:YES];
}

- (IBAction)navViewRightButtonAction:(id)sender{
    
}

//- (IBAction) navViewLeftButtonAction:(id)sender{
//    
//}

@end
