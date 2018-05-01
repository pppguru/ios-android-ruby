//
//  AppDelegate.m
//  SwissMonkey
//
//  Created by Kasturi on 23/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import "AppDelegate.h"
#import "SMLoginVC.h"
#import "SMHomeVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate{
    UIAlertView * notificationAlert;
    NSDictionary * notificationInfo;


}
@synthesize navController,window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // google maps API KEY  AIzaSyBh0cTph0-Z52XhrFmQ9ZaEHioLNwQI-Jo
    
//    [GMSServices provideAPIKey:@"AIzaSyBvD9Ho2rn9uY0mKMFbb47UiMqcC_vkltg"];//Production
    
//    [GMSServices provideAPIKey:@"AIzaSyBh0cTph0-Z52XhrFmQ9ZaEHioLNwQI-Jo"];//Dev
    
    [ReusedMethods setupDeviceModel];
    [GMSServices provideAPIKey:k_GOOGLE_API_KEY];
    
    [SMSharedFilesClass sharedFileObject];
    
    NSLog(@"\nBaseurl: %@\nFlurry : %@\nGoogle API: %@\nBundle Identifier : %@", BASEURL, k_FLURRY_KEY, k_GOOGLE_API_KEY, BUNDLE_ID);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSMutableArray *arrayProfileImages = [ReusedMethods profileImages];
//    if(!arrayProfileImages){
//        arrayProfileImages = [[NSMutableArray alloc] init];
//        [ReusedMethods setProfileImages:arrayProfileImages];
//    }
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"firstTime"];
    [userDefaults setObject:@NO forKey:@"isAdvancedSearch"];
    [userDefaults synchronize];
    
    [self  IntegrateFlurry];
    
    
    //  //Notification Setup
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        // use registerUserNotificationSettings
        UIUserNotificationType types = UIUserNotificationActivationModeBackground|UIUserNotificationTypeBadge| UIUserNotificationTypeAlert|UIUserNotificationTypeSound;
        UIUserNotificationSettings *mysettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [application registerUserNotificationSettings:mysettings];
        [application registerForRemoteNotifications];
    } else {
        // use registerForRemoteNotifications
        [application registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeNewsstandContentAvailability| UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeSound];
    }

//    for (id familyName in [UIFont familyNames]) {
//        NSLog(@"%@", familyName);
//        for (id fontName in [UIFont fontNamesForFamilyName:familyName]) NSLog(@"  %@", fontName);
//    }
    
    
    [ReusedMethods  checkAppFlow];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    [self callDropDownListMethods];
    
    return YES;
}

- (void) refreshTopViewAfterDownloadingAllFiles{
    @try {
        UIViewController *topController = [navController topViewController];
        [topController viewWillAppear:YES];
        NSLog(@"topController : %@", [topController class]);
    }
    @catch (NSException *exception) {
        NSLog(@"NSException : %@", exception);
    }
    @finally {
        
    }
}

#pragma mark - Flurry Function

- (void)IntegrateFlurry {
    
    // crash lytics  run script  for bundle id  com.swissmonkey.swissmonkey
//    "${PODS_ROOT}/Fabric/run" ab573f58a26e75650a05d233e0ff96f68052ca38 55d845dc65f3251e319f0850f0513bfe492e0a38f3dfaa75cd27f8fcf29758c5
    
     // crash lytics  run script  for bundle id  com.rapidbizapps.swissmonkey
//    "${PODS_ROOT}/Fabric/run" ab573f58a26e75650a05d233e0ff96f68052ca38 55d845dc65f3251e319f0850f0513bfe492e0a38f3dfaa75cd27f8fcf29758c5
    
    
    
    //Enabling Flurry Analytics
//    [Flurry startSession:@"4XM6JZCKD8T43Q97K532"]; // Production
    
//    [Flurry startSession:@"SR6P8X4GV7V75HR9FMFH"]; // dev
    [Flurry startSession:k_FLURRY_KEY];
    
    [Flurry logEvent:@"SwissMonkey - iOS Application Launched"];
    
    //Fetching location for flurry analytics
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
    if(iOS8){
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                [self.locationManager requestAlwaysAuthorization];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [self.locationManager  requestWhenInUseAuthorization];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
    [self.locationManager startMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingLocation];
    
    CLLocation *location = [self.locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    
    
     [Flurry setLatitude:coordinate.latitude longitude:coordinate.longitude horizontalAccuracy:location.horizontalAccuracy verticalAccuracy:location.verticalAccuracy];
    
    //  crashlytics  code.
    [Fabric with:@[[Crashlytics class]]];

}

#pragma  mark  -  RESIDE MENU DELEGATE METHODS

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

#pragma mark - LOCATION MANAGER DELEGATE METHODS

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location manager error: %@",error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // Getting location object from array.
    CLLocation *location = [locations objectAtIndex:0];
    //Track User current location
     [Flurry setLatitude:location.coordinate.latitude longitude:location.coordinate.longitude horizontalAccuracy:location.horizontalAccuracy verticalAccuracy:location.verticalAccuracy];
    NSLog(@" coordinates :  %f,%f",location.coordinate.latitude, location.coordinate.longitude );
    
    NSNumber *lat = [NSNumber numberWithDouble:location.coordinate.latitude];
    NSNumber *lon = [NSNumber numberWithDouble:location.coordinate.longitude];
    NSDictionary *userLocation=@{@"lat":lat,@"long":lon};
    
    [[NSUserDefaults standardUserDefaults] setObject:userLocation forKey:@"userLocation"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [manager stopUpdatingLocation];
}

#pragma  mark  - PUSH NOTIFICATIONS 

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    
    NSLog(@"Device token %@",hexToken);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:hexToken forKey:@"deviceToken"];
    [defaults synchronize];
    [ReusedMethods makeApiCallForDeviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
//     if (notificationAlert != nil)
//     {
//     [notificationAlert dismissWithClickedButtonIndex:0 animated:NO];
//     }
//     notificationInfo = userInfo;
//     
//     NSString  *  message  =  [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
//     
//     notificationAlert  = [[UIAlertView alloc] initWithTitle:APP_TITLE message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [notificationAlert show];
    
    //[self  displayingAlertForPushNotificationsWithNotificationInfo:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [self saveNewlyOccuredNotificationWithInfo:userInfo];
        
    if(application.applicationState == UIApplicationStateInactive) {
        
        NSLog(@"Inactive");
        
        //Show the view with the content of the push
        [self  displayingAlertForPushNotificationsWithNotificationInfo:userInfo];

        completionHandler(UIBackgroundFetchResultNewData);
        
    } else if (application.applicationState == UIApplicationStateBackground) {
        
        NSLog(@"Background");
        
        //Refresh the local model
        
        completionHandler(UIBackgroundFetchResultNewData);
        
    } else {
        
        NSLog(@"Active");
        [self  displayingAlertForPushNotificationsWithNotificationInfo:userInfo];

        //Show an in-app banner
        completionHandler(UIBackgroundFetchResultNewData);
        
        }

}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        NSLog(@"didRegisterUser");
        [application registerForRemoteNotifications];
    }else{
        NSLog(@"show alert");
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    NSLog(@"[[ReusedMethods sharedObject] menuOpened] : %i\nStatusbar : %@", [[ReusedMethods sharedObject] menuOpened], NSStringFromCGRect([[UIApplication sharedApplication] statusBarFrame]));
//    
//    [[UIApplication sharedApplication] setStatusBarHidden:[[ReusedMethods sharedObject] menuOpened] withAnimation:UIStatusBarAnimationFade];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [ReusedMethods checkForUserTermsAndConditionsAccepted];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) displayingAlertForPushNotificationsWithNotificationInfo:(NSDictionary *) userInfo{
    if (notificationAlert != nil)
    {
        [notificationAlert dismissWithClickedButtonIndex:0 animated:NO];
    }
    notificationInfo = userInfo;
    
    NSError * error;
    NSString *jsonString = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"notification data"]];
    NSData *alertData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dict   = [NSJSONSerialization JSONObjectWithData:alertData options:0 error:&error];
    
    NSString  *  message  =  [dict objectForKey:@"notification_description"];//[[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    notificationAlert  = [[UIAlertView alloc] initWithTitle:APP_TITLE message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [notificationAlert show];
}


- (void)  saveNewlyOccuredNotificationWithInfo:(NSDictionary *) userInfo{
    
    //  getting objects  from  userdefaults data.
    NSUserDefaults *  userDefaults  =  [NSUserDefaults  standardUserDefaults];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:NOTIFICATIONS_ARRAY];
    NSMutableArray *savedArray = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    
    // convert  string <WHich is  provided  by server
    NSError * error;
    NSString *jsonString = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"notification data"]];
    NSData *alertData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dict   = [NSJSONSerialization JSONObjectWithData:alertData options:0 error:&error];

    NSString *dictPredicateString = [NSString stringWithFormat:@"id = %@", [dict objectForKey:@"id"]];
    NSPredicate *dictpredicate = [NSPredicate predicateWithFormat:dictPredicateString];
    NSArray *array = [savedArray filteredArrayUsingPredicate:dictpredicate];
    if(array.count  ==  0){
   // [savedArray  addObject:[userInfo objectForKey:@"aps"]];
    [savedArray  addObject:dict];
    }
    
    // sort  data
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"updated_at" ascending:NO];
    NSArray *descriptors=[NSArray arrayWithObject: descriptor];
    NSArray *reverseOrder=[savedArray sortedArrayUsingDescriptors:descriptors];
    
    //  dont  allow  duplicates
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:reverseOrder];
    NSArray *arrayWithoutDuplicates = [orderedSet array];
    
    // save total array  in userdefaults
    [userDefaults  setObject:[NSKeyedArchiver archivedDataWithRootObject:arrayWithoutDuplicates] forKey:NOTIFICATIONS_ARRAY];
    
    //  predicated viewd = 0  objects  to display  count in  home  view.
    
    NSString *predicateString = [NSString stringWithFormat:@"viewed = %@", @"No"];
    predicateString  =  [NSString stringWithFormat:@"%@ CONTAINS[c] '%@'", @"viewed", @"No"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    NSArray *nonVisitedNotificationsArray = [arrayWithoutDuplicates filteredArrayUsingPredicate:predicate];
    
    //  save  count  to  userdefaults
    [userDefaults  setObject:[NSNumber  numberWithInteger:nonVisitedNotificationsArray.count] forKey:USER_NOTIFICATIONS_COUNT];
    [userDefaults  synchronize];
 
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex  ==  [alertView  cancelButtonIndex]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushNotificationCountUpdate" object:nil];
    }
}

@end
