//
//  SMHomeModel.h
//  SwissMonkey
//
//  Created by Kasturi on 24/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotificationView.h"


@class SMHomeVC;
@class SMProfileVC;
@class SMUserProfileDescriptionVC;
@class SMSettingsVC;
@class SMLoginVC;
@class SMScreenTitleButtonsVC;
@class SMHelpVC;


@protocol SMHomeModelDelegate<UITableViewDataSource, UITableViewDelegate>


-(void)serverCallSavedJobsSuccessRespone:(NSDictionary *)service;
-(void)serverCallSavedJobsFailureRespone:(NSString *)error;

- (void)rangeSliderValueDidChange:(MARKRangeSlider *)slider;
- (void) notificationSuccessCall;

@end


@interface SMHomeModel : NSObject <UITextFieldDelegate>

@property (nonatomic, strong) id<SMHomeModelDelegate> delegate;

@property (nonatomic, strong) JVMenuPopoverView *menuPopover;
@property (nonatomic, strong) NotificationView *notiView;
@property (nonatomic, strong) JVMenuItems *menuItems;

@property  (nonatomic, strong)  SMHomeVC *  homeVC;
@property  (nonatomic, strong)  SMHelpVC *helpVC;
@property  (nonatomic, strong)  SMProfileVC * profileVC;
@property  (nonatomic, strong)  SMScreenTitleButtonsVC *firstProfileVC;

@property  (nonatomic, strong)  SMUserProfileDescriptionVC * userProfileDescriptionVC;

@property  (nonatomic, strong)  SMSettingsVC * settingsVC;

@property (nonatomic, strong) SMLoginVC * logInVC;

@property (nonatomic,strong) UIStoryboard *  storyboard , * userProfileDescriptionStoryboard;

@property  (nonatomic, retain)  UITableView *  notificationsTbleView;
@property (nonatomic, retain)  NSMutableArray *notificationsListArray;


- (void)menuPopoverOfViewController:(UIViewController *) vc;
- (JVMenuItems *)menuItems;
- (void) makeServerCallForJobSearch;
- (void)makeApiCallForNotificationsList;
- (void) makeServerCallForSavedJobs;
- (void) callDropDownListMethods;


#pragma mark - NOTIFICATIONS METHODS

- (void)  setUpNotificationsView;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;



-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView;
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
