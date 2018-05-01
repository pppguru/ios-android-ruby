//
//  SMSearchModel.h
//  SwissMonkey
//
//  Created by Baalu on 3/11/16.
//  Copyright © 2016 rapidBizApps. All rights reserved.
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


@protocol SMSearchModelDelegate

-(void)serverCallSavedJobsSuccessRespone:(NSDictionary *)service;
-(void)serverCallSavedJobsFailureRespone:(NSString *)error;
-(void)serverCallSuccessRespone:(NSDictionary *)service;
-(void)serverCallFailureRespone:(NSString *)error;
- (void)rangeSliderValueDidChange:(MARKRangeSlider *)slider;
- (void) notificationSuccessCall;
- (void) removeActiviyIndicator;
- (void) notificationsViewJobButtonAction:(NSDictionary *) jobDetails;

@end

@interface SMSearchModel : NSObject<UITextFieldDelegate>
@property (nonatomic, strong) id<SMSearchModelDelegate> delegate;

@property (nonatomic, strong) NSMutableDictionary *searchDict;
@property (nonatomic, strong) NSMutableArray *shiftsArray;

@property (nonatomic, strong) JVMenuPopoverView *menuPopover;
@property (nonatomic, strong) NotificationView *notiView;
@property (nonatomic, strong) UIView *bGView;
@property (nonatomic, strong)  UILabel * footerSectionTitle;
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
@property (nonatomic, retain)  NSMutableArray *selectedPositionsArray;


- (NSMutableArray *) getTotalPositionObjects;
- (NSString *) getKeyForDropDownListOfTextFieldTag:(NSInteger) tag;
- (NSInteger) updateRangeTextFieldText:(NSString *) rangeTxtFldText withSender:(id) sender;
- (NSDictionary *) updateRangeTextFieldTextDict:(NSString *) rangeTxtFldText withSender:(id) sender;
- (void) changeWorkDayPreferencesButtonStateOfButton:(UIButton * ) button;
- (MARKRangeSlider *) setUpProgressViewOnView:(UIView *) compensationRangeProgressView;
- (void) makeServerCallForJobSearch;
- (void) makeServerCallForSavedJobs;
- (void) callDropDownListMethods;
- (void)menuPopoverOfViewController:(UIViewController *) vc;



#pragma mark - TEXTFIELD DELEGTE METHODS

- (BOOL) textFieldShouldReturn:(UITextField *)textField;
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField;
- (void) textFieldDidEndEditing:(UITextField *)textField;
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

#pragma mark - NOTIFICATIONS METHODS

- (void)  setUpNotificationsView;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)makeApiCallForNotificationsList;
- (void) makeApiCallForViewedNotificationsList;
- (void) displayNoItemsFoundMessage;


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView;
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
