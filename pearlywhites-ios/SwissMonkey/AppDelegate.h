//
//  AppDelegate.h
//  SwissMonkey
//
//  Created by Kasturi on 23/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JVMenuNavigationController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "SMTabBarViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager * locationManager;
@property (strong, nonatomic) SlideNavigationController *  navController;
@property (strong, nonatomic) SMTabBarViewController *tabBarController;

- (void) refreshTopViewAfterDownloadingAllFiles;

@end

