//
//  SMSettingsVC.m
//  SwissMonkey
//
//  Created by Kasturi on 31/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import "SMSettingsVC.h"


@implementation SMSettingsVC{
    UIAlertView *  resetPasswordAlertView;
    UITextField * oldPasswordFld,* newPasswordField;
    SMSettingsModel * smSettingsModel;
    
}

- (void) viewDidLayoutSubviews{
    float cornerRadius = self.profileImageView.frame.size.height /2 ;
    self.profileImageView.layer.cornerRadius =  cornerRadius ;
    self.profileImageView.layer.masksToBounds = YES;
}

- (void) viewDidLoad{
    
    [super viewDidLoad];
    
    //UIColor *firstColor = [UIColor colorWithHexString:@"87FC70"];
    //UIColor *secondColor = [UIColor colorWithHexString:@"0BD318"];
    
    // setting up new gradient colors
   // [self.label gradientEffectWithFirstColor:firstColor secondColor:secondColor];
    
    // overriding root controllers label, image and imageview
    // UIImage *newImage = [UIImage imageNamed:@"about-48"];
    // self.imageView.image = [newImage changeImageColor:[UIColor blackColor]];
        
    // set  up  navigation  view  on the  view
    [ReusedMethods setNavigationViewOnView:self.view WithTitle:@"Settings" andBackgroundColor:[UIColor whiteColor]];
    [ReusedMethods setUpLeftButton:self withImageName:@"nav_menu_toggle"];
   // [ReusedMethods setUpRightButton:self withImageName:@"no_notification" withNotificationsCount:0];
    [self.menuButton addTarget:self action:@selector(navViewLeftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    smSettingsModel  = [[SMSettingsModel alloc] init];
    smSettingsModel.delegate  = self;
    if(![[[[ReusedMethods sharedObject] userProfileInfo] allKeys] count])
        [smSettingsModel callProfileDataAPICall];
    
    smSettingsModel.active = [ReusedMethods isAccountInActive];
    [self changeActivateButtonText];
//        [[_accountStatus titleLabel] setText:@" your account"];
}

- (void) changeActivateButtonText{
    
    if(!smSettingsModel.active)
        [_accountStatus setTitle:@"Activate your account" forState:UIControlStateNormal];
    else
        [_accountStatus setTitle:@"Deactivate your account" forState:UIControlStateNormal];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.namelabel setText:(NSString *)[[[ReusedMethods sharedObject]userProfileInfo] objectForKey:@"name"] ];
    [SMSharedFilesClass setProfilePicture2Button:self.profileImageView];

}

#pragma mark - User Interactions

- (IBAction)clickOnReceiveMessage:(id)sender {
    
    UIButton *button = (UIButton*) sender;
    [button setSelected:!button.isSelected];
}

- (IBAction)clickOnHideProfile:(id)sender {
    
    UIButton *button = (UIButton*) sender;
    [button setSelected:!button.isSelected];
}

-(void)showalert{
    
    resetPasswordAlertView = [[UIAlertView alloc] initWithTitle:@"" message:@"RESET PASSWORD" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    [resetPasswordAlertView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    
    // Alert style customization
    [[resetPasswordAlertView textFieldAtIndex:0] setSecureTextEntry:YES];
    [[resetPasswordAlertView textFieldAtIndex:1] setSecureTextEntry:YES];
    [[resetPasswordAlertView textFieldAtIndex:0] setPlaceholder:@"Old password"];
    [[resetPasswordAlertView textFieldAtIndex:1] setPlaceholder:@"New password"];
    [resetPasswordAlertView show];
}

- (IBAction)resetPasswordButtonAction:(id)sender {
    
    [self showalert];
}

- (IBAction)deactivateYourAccountAction:(id)sender {
    NSString *message = @"Do you want to Deactivate your account?";
    if(!smSettingsModel.active){
        message = @"Do you want to Activate your account?";
    }
    RBACustomAlert * alert =[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:message delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO",nil];
    alert.tag  = 790;
    [alert show];
}

- (void) updateStatus{
    [self changeActivateButtonText];
    if(smSettingsModel.active)
        [ReusedMethods setUserStatus:@"activated"];
    else
        [ReusedMethods setUserStatus:@"blocked"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld", (long)alertView.tag);
    if(alertView.tag  == 790){
        if (buttonIndex  ==  [alertView cancelButtonIndex]) {
            [smSettingsModel makeApiCallFoDeactivate];
        }
        
    }
    else if(alertView.tag == 112){
        if(buttonIndex != [alertView cancelButtonIndex]){
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isHome"];
            [ReusedMethods logout];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    else{
        if (buttonIndex  ==  [alertView cancelButtonIndex]) {
            
            if([resetPasswordAlertView textFieldAtIndex:1].text.length == 0 || [resetPasswordAlertView textFieldAtIndex:0].text.length == 0){
                RBACustomAlert  * alert  =  [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"Please enter password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }else if (![SMValidation minimumCharsValidation:[resetPasswordAlertView textFieldAtIndex:1].text]){
                RBACustomAlert  * alert  =  [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"Password must be atleast 8 characters" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
//            }else if (![[resetPasswordAlertView textFieldAtIndex:1].text isEqualToString:[resetPasswordAlertView textFieldAtIndex:2].text]){
//                RBACustomAlert  * alert  =  [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"New password is not same." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
            }
            
            else{
                [smSettingsModel makeApiCallForResetpassword:[resetPasswordAlertView textFieldAtIndex:0].text newPassword:[resetPasswordAlertView textFieldAtIndex:1].text];
            }
        }
    }
}

- (void) showErrorMessages:(NSString *)error{
    
}

- (void) successResponseCall:(NSDictionary *)profileInfo {
    [[[ReusedMethods sharedObject] userProfileInfo] removeAllObjects];
    [[[ReusedMethods sharedObject] userProfileInfo] addEntriesFromDictionary:profileInfo];
    [ReusedMethods setUserProfile:[[ReusedMethods sharedObject] userProfileInfo]];
    self.namelabel.text  =  (NSString *)[profileInfo objectForKey:@"name"];
    //[SMSharedFilesClass downloadAllImagesAndVideos];
}



@end
