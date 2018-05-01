//
//  SMSlideLeftMenuController.m
//  SwissMonkey
//
//  Created by Expert Software Dev on 3/4/18.
//  Copyright © 2018 rapidBizApps. All rights reserved.
//

#import "SMSlideLeftMenuController.h"


@interface SMSlideLeftMenuController () {
    NSArray *arrayMenuNames;
}

@end

@implementation SMSlideLeftMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrayMenuNames = @[@"WELCOME", @"PROFILE", @"SETTINGS", @"SUPPORT", @"SIGN OUT"];
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


#pragma mark - User Interaction
- (IBAction)clickOnClose:(id)sender {
    
    [[SlideNavigationController sharedInstance] toggleLeftMenu];
}

- (IBAction)clickOnFB:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/swissmonkeyinc/"]];
}
- (IBAction)clickOnTwitter:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/swissmonkeyinc"]];
}
- (IBAction)clickOnGooglePlus:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://plus.google.com/u/0/107829396600366312840"]];
}
- (IBAction)clickOnInstagram:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.instagram.com/swissmonkeyinc/"]];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"LeftSideMenuButtonTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UILabel *menuLabel = [cell.contentView viewWithTag:999];
    menuLabel.text = [arrayMenuNames objectAtIndex:indexPath.row];
   
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc = nil;
    if(indexPath.row == 0)
    {
//        vc = [self.storyboard  instantiateViewControllerWithIdentifier:SM_SEARCH_VC];
        AppDelegate *appDelegate  =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
        vc = appDelegate.tabBarController;
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isHome"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isAdvancedSearch"];
        
        [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:NO];
        
        return;
    }
    else if (indexPath.row == 1)
    {
        if(![ReusedMethods isProfileFilled]) {
            vc = [self.storyboard  instantiateViewControllerWithIdentifier:SM_PROFILE_VC];
        }
        else {
            UIStoryboard *profileStoryboard = [UIStoryboard storyboardWithName:@"UserProfileDescription" bundle:nil];
            vc  = [profileStoryboard  instantiateViewControllerWithIdentifier:SM_PROFILE_DESCRIPTION_VC];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isHome"];
    }
    else if (indexPath.row == 2)
    {
        vc = [self.storyboard  instantiateViewControllerWithIdentifier:SM_SETTINGS_VC];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isHome"];
    }
    else if (indexPath.row == 3)
    {
        vc = [self.storyboard  instantiateViewControllerWithIdentifier:SM_HELP_VC];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isHome"];
    }
    else if (indexPath.row  ==  4)
    {
        RBACustomAlert * alert = [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"Are you sure want to sign out?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert setTag:112];
        [alert show];
    }
    
    if (vc)
        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc withCompletion:nil];
    
}

#pragma mark - Alert Delegate
- (void) alertView:(RBACustomAlert *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1)
    {
        //Logout user
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isHome"];
        [ReusedMethods logout];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}



@end
