//
//  Constants.h
//  SwissMonkey
//
//  Created by Kasturi on 23/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#ifndef SwissMonkey_Constants_h
#define SwissMonkey_Constants_h

typedef enum {
    kPosition = 5,
    kExperience,
    kJobType,
    kCompRange,
    kAvialabilityOptions,
    kWorkAvailability,
    kOpportunitiesRange,
    kPracticeManagement,
    kAdditionalSkills,
    kStates
} PopupType;

typedef enum {
    kDeviceModelUnKnown = 0,
    kDeviceModeliPhone4,
    kDeviceModeliPhone5,
    kDeviceModeliPhone6,
    kDeviceModeliPhone6P
} DeviceModel;

//// Production Keys
//
//#define BASEURL @"https://app.swissmonkey.co/api/v1.0" // Production
//#define k_GOOGLE_API_KEY @"AIzaSyBvD9Ho2rn9uY0mKMFbb47UiMqcC_vkltg" //Production
//#define k_FLURRY_KEY @"4XM6JZCKD8T43Q97K532" // Production

 //Dev Keys

//#define k_FLURRY_KEY @"SR6P8X4GV7V75HR9FMFH"//Dev
//#define k_GOOGLE_API_KEY @"AIzaSyB4AIPZzAJisLVtyAlb8p54YDS7XHuVLFA"//new dev
//#define BASEURL @"https://swissmonkey-staging.rapidbizapps.com/api/v1.0" // Staging

//Old Keys

//#define k_GOOGLE_API_KEY @"AIzaSyBh0cTph0-Z52XhrFmQ9ZaEHioLNwQI-Jo" //Dev
//#define BASEURL @"http://192.168.3.133/SwissMonkey/SwissMonkey/public/api/v1.0" // Staging
//#define BASEURL @"http://swissmonkey-test.rapidbizapps.com/api/v1.0" // TEST

#define iOS8 [[[UIDevice currentDevice] systemVersion] floatValue] >= 8
#define APP_TITLE @"Swiss Monkey"
#define NAVIGATION_HEIGHT   72
#define LEFT_BUTTON_TAG  200
#define RIGHT_BUTTON_TAG 201
#define NAV_VIEW_TITLE_LABEL_TAG  202
#define NAVIGATION_VIEW_TAG 203

#pragma mark - SIGNUP FIELDS TAGS

#define  SIGNUP_USERNAME_TAG 100
#define  SIGNUP_EMAIL_TAG 101
#define  SIGNUP_PASSWORD_TAG 102
#define  SIGNUP_REENTER_PASSWORD_TAG 103
#define  SIGNUP_SEARCH_POSITION_TAG 104
#define  SIGNUP_POPUP_SEARCH_TEXTFIELD_TAG 105

#pragma mark - HOME VIEW TEXTFIELDS AND  BUTTONS  TAGS

#define HOME_POSITION_TEXTFIELD_TAG 106
#define HOME_LOCATION_TEXTFIELD_TAG 107
#define  HOME_RANGE_DECREMENT_TAG  300
#define  HOME_RANGE_INCREMENT_TAG  301
#define HOME_EXPERIENCE_TXTFLD_TAG 302
#define HOME_JOBTYPE_TXTFLD_TAG 303
#define HOME_COMPENSATION_TIMINGS_TEXTFIELD_TAG 305

#define  HOME_NOTIFICATIONVIEW_TAG   304

#define HOME_COMPENSATION_FROM_FIELD 306
#define HOME_COMPENSATION_TO_FIELD 307

#pragma mark  - JOB RESULTS VIEW BUTTON TAGS

#define  JOB_RESULTS_LISTBUTTON_TAG  601
#define  JOB_RESULTS_MAPBUTTON_TAG   602
#define JOB_RESULTS_LOCATIONTABLEVIEW_TAG 702

#pragma mark  - HOME VIEW  BOTTOM  BUTTONS  TAGS

#define HOME_BOTTOM_JOBSFORYOU_TAG 603
#define HOME_BOTTOM_APPLICATION_STATUS_TAG 604
#define HOME_BOTTOM_JOBHISTORY_TAG 605
#define HOME_BOTTOM_SAVEDJOBS_TAG 606
#define HOME_BOTTOM_SEARCH_BUTTON_TAG 607


#pragma  mark  - PROFILE SCREEN TEXTFIELDS TAGS 

#define PROFILE_POSITION_TEXTFIELD_TAG 711
#define PROFILE_EXPERIENCE_TEXTFIELD_TAG 712
#define PROFILE_BOARD_CERTIFIED_TEXTFIELD_TAG  713
#define PROFILE_LICENCE_NUMBER_TEXTFIELD_TAG  714
#define PROFILE_DATE_TXTFLD_TAG 715
#define PROFILE_STATES_LIST_BUTTON_TAG 716
#define DISPLAY_STATES_TABLEVIEW_TAG 717

#define PROFILE_JOB_TYPE_TXTFLD_TAG 730
#define PROFILE_WORK_AVAILALABILITY_TXTFLD_TAG 731
#define PROFILE_LOOKING_FOR_OPPORTUNITIES_TXTVIEW_TAG 732
#define PROFILE_AVAILALABLE_FOR_VIRTUAL_TXTVIEW_TAG 733
#define PROFILE_PERFORMANCE_MANAGEMENT_TXTVIEW_TAG 734
#define PROFILE_ADDITIONAL_SKILLS_TXTVIEW_TAG 735
#define PROFILE_LANGUAGES_TEXTFIELD_TAG 736
#define PROFILE_WORK_AVAILABILITY_AFTER_DATE_TEXTFLD_TAG 737
#define PROFILE_OTHER_PRACTICE_DESCRIPTION_TEXTFLD_TAG 738
#define PROFILE_SPECIALIZED_ASSISTANT_TRAINING_TXTVIEW_TAG 739


#define PROFILE_COMPRANGE_TEXTFIELD_TAG 741
#define PROFILE_EXPECTEDSALARY_TAG 742
#define PROFILE_OTHER_TEXTVIEW_TAG 743
#define PROFILE_VIDEOS_DISPLAY_BGVIEW_TAG 744
#define PROFILE_PHOTOS_DISPLAY_BGVIEW_TAG 745
#define PROFILE_RESUME_DISPLAY_BGVIEW_TAG 746
#define PROFILE_RECOMMENDATIONS_DISPLAY_BGVIEW_TAG 747
#define PROFILE_EXPECTED_TO_SALARY_TAG 748


#define PROFILE_NAME_TEXTFIELD_TAG  701
#define PROFILE_ADDRESSLINE1_TEXTFIELD_TAG  702
#define PROFILE_ADDRESSLINE2_TEXTFIELD_TAG  703
#define PROFILE_CITY_TEXTFIELD_TAG  704
#define PROFILE_STATE_TEXTFIELD_TAG  705
#define PROFILE_ZIP_TEXTFIELD_TAG  706
#define PROFILE_PHOE_NUMBER_TEXTFIELD_TAG  707
#define PROFILE_ABOUTME_TEXTFIELD_TAG  708
#define PROFILE_EMAIL_TEXTFIELD_TAG 710

#define k_SERVER_CALL_DELAY 0.1

#pragma  mark - DATE FORMATES

#define UTC_DATE_FORMATE               @"yyyy-MM-dd'T'HH:mm:ss'Z'"
#define SERVER_DATE_FORMATE            @"MM-dd-yyyy" // @"yyyy-MM-dd"
#define SERVER_SAVING_DATE_FORMATE     @"yyyy-MM-dd"
#define APP_DISPLAY_DATE_FORMATE       @"MM/dd/yyyy"

#pragma  mark - ALERT VIEW TAGS

#define APPLYNOW_ALERT_TAG  700
#define PROFILE_PHOTO_UPDATE_TAG 709

#define ACCOUNT_DEACTIVATED_MESSAGE @"Your account has been deactivated, please activate."

#pragma mark - STORYBOARD IDENETIFIERS

#define  SM_STORY_BOARD                         @"Main"
#define  SM_USER_PROFILE_DESCRIPTION_STORYBOARD @"UserProfileDescription"
#define  SM_ADD_PROFILE_DATA_STORYBOARD         @"SMAddProfileDetails"
#define  SM_HELP_SCREEN_VC                      @"SMHelpScreenVC"
#define  SM_LOGIN_VC                            @"SMLoginVC"
#define  SM_SIGNUP_VC                           @"SMSignUpVC"
#define  SM_REGISTERED_VC                       @"SMRegisteredViewController"
#define  SM_HOME_VC                             @"SMSearchVC"//@"SMHomeVC"
#define  SM_TABBAR_VC                           @"SMTabBarViewController"
#define  SM_LEFT_SIDE_MENU_VC                   @"LeftMenuController"
#define  SM_SEARCH_VC                           @"SMSearchVC"
#define  SM_ADVANCED_SEARCH_VC                  @"SMAdvancedSearchVC"
#define  SM_HOME_BOTTOM_VC                      @"SMHomeBottomVC"
#define  SM_PROFILE_VC                          @"SMProfileVC"
#define  SM_PROFILE_DESCRIPTION_VC              @"SMUserProfileDescriptionVC"
#define  SM_SETTINGS_VC                         @"SMSettingsVC"
#define  SM_HELP_VC                             @"SMHelpVC"
#define  SM_JOBRESULTS_VC                       @"SMJobResultsVC"
#define  SM_RE_SIDE_MENU_VC                     @"RESideMenu"
#define  SM_ADD_PROFILE_DETAILS_VC              @"SMAddProfileDetailsVC"
#define  SM_JOB_PROFILE_DESC_VC                 @"SMJobProfileDescriptionVC"
#define  SM_ADD_PROFILE_TITLES_VC               @"SMScreenTitleButtonsVC"
#define  SM_ADD_PROFILE_FIRST_VC                @"SMScreenTitleButtonsVC"
#define  SM_USER_PROFILE_VIDEOS_DISPLAY_VC      @"SMUserPicturesVideosDisplayVC"
#define MANDATORY_FIELDS_ALERT                  @"Please fill the required fields"
#define UPDATE_EMAIL_ID_KEY  @"Email Updated"
#define UPDATE_EMAIL_EXISTED_KEY @"Entered email address has already been registered. Please try with different email address."

#define kMIN_MILES 20 
#define kMAX_MILES 100
#define kINT_MILES 10
#define kMIN_MILES_INDEX 1
#define kNOTIFICATIONS_DISPLAY_COUNT 25

#define kMIN_SLIDER 0.0f
#define kMAX_SLIDER 50.0f

#define kLEFT_DEFAULT_SLIDER 0.0f
#define kRIGHT_DEFAULT_SLIDER 15.0f


#pragma mark APP CONSTANTS
#define USER_DEFAULTS_AUTHTKEN @"authtoken"
#define USER_DEFAULTS_USERNAME @"username"
#define USER_DEFAULTS_USERSTATUS @"status"
#define USER_NOTIFICATIONS_COUNT @"notificationsCount"

#define kPROFILEIMAGES @"profileImages"

#define kMORNING @"MORNING\n(7 - 12 PM)"
#define kAFTERNOON @"AFTERNOON\n(12 - 5 PM)"
#define kEVENING @"EVENING\n(5 - 7 PM)"

#define kDAYSARRAY ( @"M", @"T", @"W", @"T", @"F", @"S" )

#define KWEEKDAYSARRAY @[@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday",@"Sunday"];

#pragma mark - ALL PROFILE DATA KEYS 

#define NAME @"name"
#define ADDRESSLINE1 @"addressLine1"
#define ADDRESSLINE2 @"addressLine2"
#define CITY @"city"
#define STATE @"state"
#define ZIP @"zipcode"
#define EMAIL @"email"
#define NEW_EMAIL @"newEmail"
#define PHONE_NUMBER @"phoneNumber"
#define ABOUTME @"aboutMe"
#define POSITION @"positionID"
#define POSITION_IDS @"positionIDs"
#define EXPERIENCE @"experienceID"
#define BOARD_CERTIFIED @"boardCretifiedID"
#define LICENSE_NUMBER @"licenseNumber"
#define LICENSE_EXPIRES @"licenseExpiry"
#define LICENSE_VERIFICATION @"licenseVerified"
#define JOB_TYPE @"job_type"
#define JOB_TYPES @"job_types"
#define WORK_AVAILABILITY @"workAvailabilityID"
#define SHIFTS @"shifts"
#define LOCATION_RANGE @"locationRangeID"
#define VIRTUAL_INTERVIEW @"virtualInterviewID"
#define PRACTICE_MANAGEMENT @"practiceManagementID"
#define SKILLS @"skills"
#define COMRANGE @"compensationID"
#define SALARY @"salary"
#define FROM_SALARY @"from_salary_range"
#define TO_SALARY @"to_salary_range"
#define COMMENTS @"comments"
#define BILINGUAL_LANGUAGES @"bilingual_languages"
#define LICENSE_VERIFICATION_STATES @"licenseVerifiedStates"
#define WORK_AVAILABILITY_AFTER_DATE @"workAvailabilityDate"
#define OTHER_PRACTICE_DESCRIPTION_SOFTWARE @"newPracticeSoftware"


#define JOB_PROFILE_LANGUAGES @"languages"

#define SAVED_STATUS @"saved_status"
#define UNSAVED_MESSAGE_FLAG @"You cannot save this job"
#define NOTIFICATIONS_ARRAY @"PushNotifications_Array"
#define ANONYMOUS @"ANONYMOUS"

#define PROFILE_FIELDS_COUNT 29  //10+6+6+3 // 12+7+5+5
#define USER_BLOCKED  999
#define NOINTERNET_CONNECTION_ALERT_TAG 9999
#define VERSION_UPDATE_ALERT_TAG 888
#define TERMS_AND_CONDITIONS_ALERT_TAG 899

#pragma mark - APP EMPTY STRINGS 
#define EMPTY_STRING @"-"
#define SPACE @""


#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#endif
