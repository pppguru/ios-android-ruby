//
//  ReusedMethods.h
//  SwissMonkey
//
//  Created by Kasturi on 23/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBAPopup.h"
#import "RBAMultiplePopup.h"
#import "RESideMenu.h"
#import "RBACustomAlert.h"

#define k_FILEONLY( name ) ( [ name.uppercaseString hasSuffix:@".JPG" ] || [ name.uppercaseString hasSuffix:@".JPEG" ] || [ name.uppercaseString hasSuffix:@".PNG" ] || [ name.uppercaseString hasSuffix:@".MOV" ]  || [name.uppercaseString hasSuffix:@".MP4"])

@interface ReusedMethods : NSObject

@property  (nonatomic, assign)  NSInteger activePageIndex;

+(ReusedMethods *) sharedObject;
+ (void) setupDeviceModel;
+ (DeviceModel) deviceModel;

@property (nonatomic, retain) NSMutableDictionary *dropDownListDict, *userProfileInfo;
@property (nonatomic, readwrite) DeviceModel dModel;
@property (nonatomic, readwrite) BOOL menuOpened;
@property (nonatomic, readwrite) BOOL termsAndConditionsAccepted;
@property  (nonatomic,strong) RBACustomAlert * noInternetAlert;

+(void)setSeperatorProperlyForCell:(UITableViewCell *)cell;
//+(void) menuButtonActionImplementationForVC:(UIViewController *) vc ofButton:(UIButton *) menuButton;
+ (void) moveToViewController:(Class)className
      andNavigationController:(UINavigationController *) navController;

// pop up set up method
+ (void) setupPopUpViewForTextField:(UITextField *) currentTxtFld
                   withDisplayArray:(NSMutableArray *) displayObjectsArray
                            withDel:(id)delegate
                         displayKey:(NSString *) keyString
                          returnKey:(NSString *) returnKey
                            withTag:(int) tag;

+ (void) setupPopUpViewForTextField:(UITextField *) currentTxtFld
                   withDisplayArray:(NSMutableArray *) displayObjectsArray
                            withDel:(id)delegate
                         displayKey:(NSString *) keyString
                          returnKey:(NSString *) returnKey
                            withTag:(int) tag
                      isMultiSelect:(BOOL)isMulti
                   selectedPosItems:(NSArray*)arraySelectedPosItems;

+ (void) setupDownPopUpViewForTextField:(UITextField *) currentTxtFld withDisplayArray:(NSMutableArray *) displayObjectsArray withDel:(id)delegate displayKey:(NSString *) keyString returnKey:(NSString *) returnKey  withTag:(int) tag;

+ (void) setupPopUpViewForTextView:(UITextView *) currentTxtFld withDisplayArray:(NSMutableArray *) displayObjectsArray withDel:(id)delegate displayKey:(NSString *) keyString returnKey:(NSString *) returnKey  withTag:(int) tag;
//+ (void) setupMultiplePopUpViewForTextField:(UITextField *) currentTxtFld withDisplayArray:(NSMutableArray *) displayObjectsArray withDel:(id)delegate displayKey:(NSString *) keyString returnKey:(NSString *) returnKey  withTag:(int) tag;
+(RBAMultiplePopup *)addMultiplePopupViewWithVC:(id)curentVC dataArray:(NSMutableArray *)dataArray dataKey:(NSString *)dataKey idName:(NSString *)idName textField:(id)txtFld andSelectedItems:(NSArray *)selectedItems withTag:(int)tag;
//+ (void) setupAutoPopulatedPopUpViewForTextField:(UITextField *) currentTxtFld withDisplayArray:(NSMutableArray *) displayObjectsArray withDel:(id)delegate ;
+ (void)dismissKeyboardonView:(UIView *) view;
+ (RESideMenu *) setUpResideMenuControllerWithContentVC:(UIViewController *) contentVC bottomVC:(UIViewController *) bottomVC;
+ (void) checkAppFlow;
+ (void) logout;
//+ (void)dismissKeyboardonView:(UIView *) view;
+ (void) changeGradientColorForWindow:(UIView *) view;
+ (NSString *) replaceNullString:(NSString *)strValue withSpace:(BOOL) space;
+ (NSString *) agoDate:(NSString *)date;
+ (void) saveUserProfile;
//+ (NSMutableArray *) profileImages;
//+ (void) setProfileImages:(NSMutableArray *) profileImages;
+ (NSData *) dataFromImage:(UIImage *)image;
+ (NSString *) changeDisplayFormatOfDateString:(NSString *) serverDateString withEmptyString:(NSString *) emptyString;
+ (NSString *) changeDisplayFormatOfDateString:(NSString *) serverDateString inTheFormate:(NSString *)serverFormate WithEmptyString:(NSString *) emptyString;
+ (NSString *) authToken;
+ (void) setAuthToken:(NSString *) authToken;
+ (NSString *) username;
+ (void) setUsername:(NSString *) username;
+ (NSString *) userStatus;
+ (void) setUserStatus:(NSString *) userStatus;
+ (BOOL) isAccountInActive;
+ (void)makeApiCallForDeviceToken;
+ (NSString *) GUID;
+ (void) setUserProfile:(NSDictionary *)userprofile;
+ (NSDictionary *) userProfile;
+ (NSString *) replaceEmptyString:(NSString *) contentString emptyString:(NSString *) empty;
+ (NSMutableArray *) getAvailabityOptionsDictionary;
+ (NSMutableArray *) getAvailabityOptionsDictionaryForVirtualInterView;
+ (void) setupPopUpViewForView:(id ) currentFld withDisplayArray:(NSMutableArray *) displayObjectsArray withDel:(id)delegate displayKey:(NSString *) keyString returnKey:(NSString *) returnKey  withTag:(int) tag;
+(NSArray *) getArrayFromString:(NSString *) skillsString;
#pragma mark - Navigation Bar

+ (void) setNavigationViewOnView: (UIView *)selfView WithTitle:(NSString *)title andBackgroundColor:(UIColor *) BGcolor;
+ (UIButton *) setUpRightButton:(UIViewController *)vc withImageName:(NSString *)rightButtonImageName withNotificationsCount:(NSInteger) notificationCount;
+ (void) setUpLeftButton:(UIViewController *)vc withImageName:(NSString *) leftButtonImageName;

#pragma  mark  -  KEY ID  AND  VALUE RELATED METHODS

+ (NSString *) getcorrespondingStringWithId:(NSNumber *) idNumber andKey:(NSString *) keyString;
+ (NSString *) getcorrespondingStringFromLocalOptionsDictioriesWithId:(NSNumber *)idNumber andKey:(NSString *)keyString;
+ (NSString *) getGroupKeyFromKeyString:(NSString *)keyString;
+ (NSString *) getNameKeyFromServerKeyString:(NSString *)keyString;
+ (NSString *) getIdKeyFromServerKeyString:(NSString *)keyString;
+ (BOOL) isObjectClassNameString:(id) object;
+ (NSString *)getCombainedStringFromServerResponseArrayHavingServerkey:(NSString *) serverObjectKey;
+ (BOOL) validationsForProfileData:(int)indexProfileDetailPage;

+(float)profileProgresValue;
+(void)generateThumbImage : (NSString *)filepath withImageView:(id) videoImageView;
+ (NSString *) capitalizedString:(NSString *)string;
+ (NSString *) getValidString:(NSString *) string;
+ (NSMutableArray *) getSelectedItemsArrayWithSelectedKeyArray:(NSArray *) dropDownListArray serverKey:(NSString *) serverKey filterWithKeyString: (NSString *) nameString IdString:(NSString *) idString;

+ (NSMutableAttributedString *) getAttributeString:(NSString *)labelText;
+ (NSMutableAttributedString *) getAttributeString:(NSString *)labelText withAlignment:(NSTextAlignment)textAlignment;
+ (BOOL) isPermissionGranted;
+ (void) showPermissionRequiredAlert;
+ (BOOL) isProfileFilled;
+ (BOOL) isZipCodeAvailable;

+ (void) setOldUserProfile:(NSDictionary *)userprofile;
+ (NSDictionary *) oldUserProfile;
+ (NSString *) getVideoIdFromLink:(NSString *) videourl;
+(NSMutableDictionary *)removeNullsInDict:(NSMutableDictionary *)dict;
+ (id)cleanJsonToObject:(id)data;

+ (void) checkForUserTermsAndConditionsAccepted;

+ (void) setCapitalizationForFirstLetterOfField:(id) field;
+ (void) setUpPopUpViewOnViewController:(UIViewController *) viewControlr;
+  (UIView *) ShowPopUpWithTitleTitle:(NSString *) title descriptionContent:(NSString *)  description;



#pragma mark - Top borders for selection

+ (void)applyTopBorderIndicator:(UIView*) view;

+ (void)applyTopBorderIndicator:(UIView*) view
                    borderWidth:(float) borderWidth
                    borderColor:(UIColor*) borderColor;

+ (void)removeTopBorder:(UIView*)view;

#pragma mark - Bottom borders for selection

+ (void)applyBottomBorderIndicator:(UIView*) view;
    
+ (void)applyBottomBorderIndicator:(UIView*) view
                       borderWidth:(float) borderWidth
                       borderColor:(UIColor*) borderColor;

+ (void)removeBottomBorder:(UIView*)view;

#pragma mark - Apply 3D shadow for view

+ (void)applyShadowToView:(UIView*)view;

+ (void)applyShadowToView:(UIView*)view
                   radius:(float)radius
              borderWidth:(float)borderWidth
            shadowOpacity:(float)shadowOpacity
             shadowRadius:(float)shadowRadius;

#pragma mark - Button Customization

+ (void)applyPurpleButtonStyle: (UIButton*)button;
+ (void)applyBlueButtonStyle: (UIButton*)button;
+ (void)applyGreenButtonStyle: (UIButton*)button;
+ (void)applyButtonStyle: (UIButton*)button color:(UIColor*)color;

#pragma mark - Job Types

+ (NSArray*)arrayJobTypes;

#pragma mark - Compensation Preference

+ (void)applyTextFilteringForCompensationPreferences;

@end
