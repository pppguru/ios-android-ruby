//
//  CustomAlert.h
//  FleetSync-Mobile
//
//  Created by Yadagiri Neeli on 11/09/15.
//  Copyright (c) 2015 RBA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"

@class RBACustomAlert;

typedef enum
{
    CustomAlertViewStyleNormal,
    CustomAlertViewStyleInput,
    
} CustomAlertViewStyle;

@protocol CustomAlertDelegate <NSObject>

- (void) alertView:(RBACustomAlert *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@optional
- (void)alertViewCancel:(RBACustomAlert *)alertView;

@end

@interface RBACustomAlert : UIView

@property (nonatomic, strong) id<CustomAlertDelegate> delegate;
@property (nonatomic, readwrite) NSInteger cancelButtonIndex;//, firstOtherButtonIndex;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, readwrite) CustomAlertViewStyle style;
@property (nonatomic, strong) JVFloatLabeledTextField *inputTextField;
@property (nonatomic, strong) UIView *alertView;

- (id) initWithTitle: (NSString *) t message: (NSString *) m delegate: (id) d cancelButtonTitle: (NSString *) cancelButtonTitle otherButtonTitles: (NSString *) otherButtonTitles, ...;
- (void) dismissWithClickedButtonIndex: (NSInteger)buttonIndex animated: (BOOL) animated;
- (void) show;

@end
