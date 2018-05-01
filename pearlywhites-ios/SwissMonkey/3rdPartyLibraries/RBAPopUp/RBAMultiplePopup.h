//
//  RBAMultiplePopup.h
//  FleetSync-Mobile
//
//  Created by Prasad on 9/9/15.
//  Copyright (c) 2015 RBA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingTableView.h"

typedef enum {
    multiplePopupPinDirectionAny = 0,
    multiplePopupPinDirectionUp,
    multiplePopupPinDirectionDown,
} multiplePopupPinDirection;

typedef enum {
    multiplePopupPopTipAnimationSlide = 0,
    multiplePopupPopTipAnimationPop
} multiplePopupPopTipAnimation;


@protocol RBAMultiplePopupDelegate;

@interface RBAMultiplePopup : UIView<UISearchBarDelegate>


@property (nonatomic, weak)            id<RBAMultiplePopupDelegate>	delegate;

@property (nonatomic, strong)			NSString				*title;
@property (nonatomic, strong)			NSString				*message;
@property (nonatomic, strong)           UIView	                *customView;

@property (nonatomic, strong)			UIColor					*backgroundColor;
@property (nonatomic, strong)			UIColor					*borderColor;

@property (nonatomic, strong)			UIColor					*titleTextColor;
@property (nonatomic, strong)			UIColor					*messageTextColor;

@property (nonatomic, strong)			UIFont					*titleFont;
@property (nonatomic, strong)			UIFont					*messageFont;

@property (nonatomic, assign)           CGFloat                 cornerRadius;
@property (nonatomic, assign)			CGFloat                 borderWidth;
@property (nonatomic, assign)           CGFloat                 bubbleWidth;



@property (nonatomic, assign)			NSTextAlignment     titleTextAlignment;
@property (nonatomic, assign)			NSTextAlignment     messageTextAlignment;
@property (nonatomic, strong, readonly) id                      targetObject;

@property (nonatomic, assign)			BOOL                    disableTapToDismiss;
@property (nonatomic, assign)			BOOL                    dismissTapAnywhere;

@property (nonatomic, assign)           BOOL                    has3DStyle;
@property (nonatomic, assign)           BOOL                    hasShadow;
@property (nonatomic, assign)           BOOL                    isTableView;

@property (nonatomic, assign)           CGFloat                 sidePadding;
@property (nonatomic, assign)           CGFloat                 topMargin;

@property (nonatomic, assign)           PopTipAnimation       animation;
@property (nonatomic, assign)           multiplePopupPinDirection          preferredPinDirection;

@property (nonatomic,strong) NSMutableArray * contactsArray;
@property (nonatomic,strong) NSMutableArray * allData;
@property (nonatomic,strong) id  textFeild;
@property (nonatomic,strong) NSString * key;
@property (nonatomic,strong) NSString * keyId;
@property (nonatomic,strong) NSString * idName;
@property (nonatomic,strong) NSString * dataType;
@property (nonatomic,strong) NSMutableArray * selectedRowsArray;
@property (nonatomic,strong) NSMutableArray * selectedCellsArray;

@property (nonatomic, strong) TPKeyboardAvoidingTableView         *tblView;


// Initialization methods
- (id)initWithTitle:(NSString *)titleToShow message:(NSString *)messageToShow  delegate: (id)delegate titleColor:(UIColor *)titleColor  messageColor:(UIColor *)messageColor  backGroundColor:(UIColor *)backGroundColor borderColor:(UIColor *)borderColor;

- (id)initWithCustomView:(UIView *)aView;

//- (id)initWithTitle:(NSString *)titleToShow message:(NSString *)messageToShow;
//- (id)initWithMessage:(NSString *)messageToShow;


- (void)presentPointingAtView:(UIView *)targetView inView:(UIView *)containerView animated:(BOOL)animated;
- (void)presentPointingAtBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated;
- (void)autoDismissAnimated:(BOOL)animated atTimeInterval:(NSTimeInterval)timeInvertal;
- (multiplePopupPinDirection) getPinDirection;

@end


@protocol RBAMultiplePopupDelegate <NSObject>
- (void)popTipViewWasDismissedByUser:(RBAMultiplePopup *)popTipView;
//- (void) selectedMultipleValueData:(NSMutableArray *)selectedData andTypeName:(NSString*)titleName andIdName:(NSString*) idName andDataType:(NSString*) dataType;

- (void) selectedMultipleValueData:(NSMutableArray *)selectedData withkeyId:(NSString *)keyId andKey:(NSString*)key andDataType:(PopupType) dataType;

- (void) itemSelectedwithData:(NSDictionary*)data andDataType:(PopupType) dataType selected:(BOOL)isSelected;
@end
