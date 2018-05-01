//
//  CustomAlert.m
//  FleetSync-Mobile
//
//  Created by Yadagiri Neeli on 11/09/15.
//  Copyright (c) 2015 RBA. All rights reserved.
//

#import "RBACustomAlert.h"

@interface RBACustomAlert()<UITextFieldDelegate>{
    int xGap;
    float width;
}

@property (nonatomic, strong) NSString *title, *message;
@property (nonatomic, strong) UILabel *lblTitle/*, *lblMessage*/;
@property (nonatomic, strong) id lblMessage;
@property (nonatomic, assign) UIWindow *mainWindow;

@end

@implementation RBACustomAlert

- (id) initWithTitle: (NSString *) t message: (NSString *) m delegate: (id) d cancelButtonTitle: (NSString *) cancelButtonTitle otherButtonTitles: (NSString *) otherButtonTitles, ...
{
    if ( (self = [super init] ) ) // will call into initWithFrame, thus TSAlertView_commonInit is called
    {
        xGap = 10;
        width = 300;
        self.title = t;
        self.message = m;
        self.delegate = d;
        self.buttons = [[NSMutableArray alloc] init];
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.35]];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.mainWindow = appDelegate.window;
        
        [self setFrame:[UIScreen mainScreen].bounds];
        [self.mainWindow addSubview:self];
        
        if ( nil != cancelButtonTitle )
        {
            [self addButtonWithTitle: cancelButtonTitle ];
            self.cancelButtonIndex = 0;
        }
        
        if ( nil != otherButtonTitles )
        {
//            firstOtherButtonIndex = [self.buttons count];
            [self addButtonWithTitle: otherButtonTitles ];
            
            va_list args;
            va_start(args, otherButtonTitles);
            
            id arg;
            while ( nil != ( arg = va_arg( args, id ) ) )
            {
                if ( ![arg isKindOfClass: [NSString class] ] )
                    return nil;
                
                [self addButtonWithTitle: (NSString*)arg ];
            }
        }
        [self addSubviews];
        _alertView.layer.shadowOffset = CGSizeMake(-10, 10);
        _alertView.layer.shadowRadius = 5;
        _alertView.layer.shadowOpacity = 0.5;
        [_alertView setFrame:CGRectMake(0, 0, width, 20)];
    }
    
    return self;
}

- (void) addSubviews{
    _alertView = [[UIView alloc] init];
    [_alertView setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]];
    //[_alertView  setBackgroundColor:[]]
    [self addSubview:_alertView];
    
    self.lblTitle = [[UILabel alloc] init];
    [self.lblTitle setFont:[UIFont appLatoLightFont14]];
    [self.lblTitle setTextAlignment:NSTextAlignmentCenter];
    [_alertView addSubview:self.lblTitle];
//    [self.lblTitle setBackgroundColor:[UIColor yellowColor]];
//    [self.lblTitle setTextColor:[UIColor appGrayColor]];
    [self.lblTitle setTextColor:[UIColor lightGrayColor]];
    [self.lblTitle setLineBreakMode:NSLineBreakByWordWrapping];
    [self.lblTitle setNumberOfLines:0];
    
    CGFloat maxWidth = width - (2 * xGap);
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont appNormalTextFont]};
    CGRect rect = [self.message boundingRectWithSize:CGSizeMake(maxWidth, 400) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    if (rect.size.height < 200) {
        self.lblMessage = [[UILabel alloc] init];
        [self.lblMessage setFont:[UIFont appNormalTextFont]];
        [self.lblMessage setTextAlignment:NSTextAlignmentCenter];
        [_alertView addSubview:self.lblMessage];
        //    [self.lblMessage setBackgroundColor:[UIColor purpleColor]];
        //    [self.lblMessage setTextColor:[UIColor appLightGrayColor]];
        [self.lblMessage setTextColor:[UIColor blackColor]];
        [self.lblMessage setLineBreakMode:NSLineBreakByWordWrapping];
        [self.lblMessage setNumberOfLines:0];
    }else{
        self.lblMessage = [[UITextView alloc] init];
        [self.lblMessage setFont:[UIFont appNormalTextFont]];
//        [self.lblMessage setTextAlignment:NSTextAlignmentCenter];
        [_alertView addSubview:self.lblMessage];
        //    [self.lblMessage setBackgroundColor:[UIColor purpleColor]];
        //    [self.lblMessage setTextColor:[UIColor appLightGrayColor]];
        [self.lblMessage setTextColor:[UIColor blackColor]];
        //    [self.lblMessage setLineBreakMode:NSLineBreakByWordWrapping];
        //    [self.lblMessage setNumberOfLines:0];
        [self.lblMessage setBackgroundColor:[UIColor clearColor]];
        [self.lblMessage setEditable:NO];
        [self.lblMessage setSelectable:NO];
    }

}

- (NSInteger) addButtonWithTitle: (NSString *) t
{
    UIButton* b = [UIButton buttonWithType: UIButtonTypeCustom];
    [b.titleLabel setNumberOfLines:2];
    b.tag = self.buttons.count;
    [b setTitle: t forState: UIControlStateNormal];
    [b setTitleColor:[UIColor appWhiteColor] forState:UIControlStateNormal];
    
    UIImage* buttonBgNormal = [UIImage imageNamed: @""];
    buttonBgNormal = [buttonBgNormal stretchableImageWithLeftCapWidth: buttonBgNormal.size.width / 2.0 topCapHeight: buttonBgNormal.size.height / 2.0];
    [b setBackgroundImage: buttonBgNormal forState: UIControlStateNormal];
    
    UIImage* buttonBgPressed = [UIImage imageNamed: @""];
    buttonBgPressed = [buttonBgPressed stretchableImageWithLeftCapWidth: buttonBgPressed.size.width / 2.0 topCapHeight: buttonBgPressed.size.height / 2.0];
    [b setBackgroundImage: buttonBgPressed forState: UIControlStateHighlighted];
    [b setBackgroundColor:[UIColor appGreenColor]];
    [b addTarget: self action: @selector(onButtonPress:) forControlEvents: UIControlEventTouchUpInside];
    [self.buttons addObject: b];
    [self addSubview: b];
    UIFont *font =  [UIFont appLatoLightFont14];
    
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect rect = [t boundingRectWithSize:b.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    float height = 50;
    if(CGRectGetHeight(rect) > height){
        font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    }
    [b.titleLabel setFont:font];
    
//    [self setNeedsLayout];
    
    return self.buttons.count-1;
}

- (void) onButtonPress: (id) sender
{
    int buttonIndex = (int)[_buttons indexOfObjectIdenticalTo: sender];
    
    if ( [self.delegate respondsToSelector: @selector(alertView:clickedButtonAtIndex:)] )
    {
        [self.delegate alertView: self clickedButtonAtIndex: buttonIndex ];
    }
    
    if ( buttonIndex == self.cancelButtonIndex )
    {
        if ( [self.delegate respondsToSelector: @selector(alertViewCancel:)] )
        {
            [self.delegate alertViewCancel: self ];
        }
    }
    
    [self dismissWithClickedButtonIndex: buttonIndex  animated: YES];
}

- (void) dismissWithClickedButtonIndex: (NSInteger)buttonIndex animated: (BOOL) animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if ( self.style == CustomAlertViewStyleInput && [self.inputTextField isFirstResponder] )
    {
        [self.inputTextField resignFirstResponder];
    }
    
    if ( animated )
    {
            [UIView animateWithDuration: 0.2 animations: ^{
            }completion: ^(BOOL finished)
             {
                 [self removeFromSuperview];
                 [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification];
                 [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
             }];
            [UIView commitAnimations];
    }
    
   // [[[SharedClass sharedObject] alertsArray] removeObject:self];
//    if ([[SharedClass sharedObject] alertsArray].count > 0) {
//        RBACustomAlert *otherAlert = [[[SharedClass sharedObject] alertsArray] firstObject];
//        [otherAlert show];
//    }
}

- (void) show
{
//    if(self.tag == PASSWORD_ENTERING_ALERT_TAG){
//        [[SharedClass sharedObject] setIsPasswordPopUpPresent:YES];
//    }
//    
//    if ([[SharedClass sharedObject] alertsArray].count > 0) {
//        if ([[[SharedClass sharedObject] alertsArray] containsObject:self]) {
//            [self displayAlert];
//        }else{
//            [[[SharedClass sharedObject] alertsArray] addObject:self];
//        }
//    }else{
//        [[[SharedClass sharedObject] alertsArray] addObject:self];
//        [self displayAlert];
//    }
//    
//    if (self.tag == SYNC_RESULT_ALERT_TAG && [[[SharedClass sharedObject] alertsArray] count] > 1) {
//        for (int i = 0; i < [[[SharedClass sharedObject] alertsArray] count]; i ++) {
//            RBACustomAlert *alert = [[[SharedClass sharedObject] alertsArray] objectAtIndex:i];
//            if (alert.tag != SYNC_RESULT_ALERT_TAG) {
//                alert.delegate = nil;
//                [alert dismissWithClickedButtonIndex:0 animated:YES];
//                i--;
//            }
//            
//        }
//        for (RBACustomAlert *alert in [[SharedClass sharedObject] alertsArray]) {
//            if (alert.tag != SYNC_RESULT_ALERT_TAG) {
//                alert.delegate = nil;
//                [alert dismissWithClickedButtonIndex:0 animated:YES];
//            }
//        }
//    }
    
        [self displayAlert];
}

- (void) displayAlert{
    [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate:[NSDate date]];
    [self pulse];
    
//    TSAlertViewController* avc = [[TSAlertViewController alloc] init];
//    avc.view.backgroundColor = [UIColor clearColorInFleetSync];
//    
//    // $important - the window is released only when the user clicks an alert view button
//    TSAlertOverlayWindow* ow = [[TSAlertOverlayWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
//    ow.alpha = 0.0;
//    ow.backgroundColor = [UIColor clearColorInFleetSync];
//    ow.rootViewController = avc;
//    [ow makeKeyAndVisible];
    
//    self.alpha = 0;
    
//    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
//        NSLog(@"%@", [window class]);
//    }
    // fade in the window
//    [UIView animateWithDuration: 0.2 animations: ^{
//        self.alpha = 1;
//    }];
    
    // add and pulse the alertview
    // add the alertview
//    [avc.view addSubview: self];
//    [self sizeToFit];
//    self.center = CGPointMake( CGRectGetMidX( avc.view.bounds ), CGRectGetMidY( avc.view.bounds ) );
//    self.frame = CGRectIntegral( self.frame );
//    
//    if ( [self.delegate respondsToSelector: @selector(willPresentAlertView:)] )
//    {
//        [self.delegate willPresentAlertView: self ];
//    }
//
//
//    if ( self.style == TSAlertViewStyleInput )
//    {
//        [self layoutSubviews];
//        [self.inputTextField becomeFirstResponder];
//    }
}

- (void) pulse
{
    // pulse animation thanks to:  http://delackner.com/blog/2009/12/mimicking-uialertviews-animated-transition/
    
    _alertView.transform = CGAffineTransformMakeScale(0.6, 0.6);
    [UIView animateWithDuration: 0.2
                     animations: ^{
                         _alertView.transform = CGAffineTransformMakeScale(1.1, 1.1);
                     }
                     completion: ^(BOOL finished){
                         [UIView animateWithDuration:1.0/15.0
                                          animations: ^{
                                              _alertView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                                          }
                                          completion: ^(BOOL finished){
                                              [UIView animateWithDuration:1.0/7.5
                                                               animations: ^{
                                                                   _alertView.transform = CGAffineTransformIdentity;
//                                                                   [self setNeedsDisplay];
                                                                   
//                                                                   if ( [self.delegate respondsToSelector: @selector(didPresentAlertView:)] )
//                                                                   {
//                                                                       [self.delegate didPresentAlertView: self ];
//                                                                   }
                                                               }];
                                          }];
                     }];
    
}

- (CGSize) titleLabelSize
{
    CGFloat maxWidth = width - (2 * xGap);
    //	CGSize s = [self.titleLabel.text sizeWithFont: self.titleLabel.font constrainedToSize: CGSizeMake(maxWidth, 1000) lineBreakMode: self.titleLabel.lineBreakMode];
    NSDictionary *attributes = @{NSFontAttributeName: self.lblTitle.font};
    CGRect rect = [self.lblTitle.text boundingRectWithSize:CGSizeMake(maxWidth, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    CGSize s = rect.size;
    if ( s.width < maxWidth )
        s.width = maxWidth;
    
    return s;
}

- (CGSize) messageLabelSize
{
    CGFloat maxWidth = width - (2 * xGap);
    //	CGSize s = [self.messageLabel.text sizeWithFont: self.messageLabel.font constrainedToSize: CGSizeMake(maxWidth, 1000) lineBreakMode: self.messageLabel.lineBreakMode];
    
    NSDictionary *attributes = @{NSFontAttributeName: ((UILabel *)self.lblMessage).font};
    CGRect rect = [((UILabel *)self.lblMessage).text boundingRectWithSize:CGSizeMake(maxWidth, 400) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    CGSize s = rect.size;
    if ( s.width < maxWidth )
        s.width = maxWidth;
    
    return s;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //    Drawing code;
    float xPos = xGap;
//    width = CGRectGetWidth(_alertView.frame);
    float maxWidth = width - (2 * xPos);
    float gap = 12;
    float yPos = gap;
    
//    [_alertView setFrame:CGRectMake(0, 0, width, 20)];
//    [_alertView setCenter:self.center];
    
    [self.lblTitle setText:self.title];
    CGSize size = [self titleLabelSize];
    [self.lblTitle setFrame:CGRectMake(xPos, yPos, maxWidth, size.height)];
    yPos += size.height + gap;
    
    if(self.message){
        [self.lblMessage setText:self.message];
        size = [self messageLabelSize];
        [self.lblMessage setFrame:CGRectMake(xPos, yPos, maxWidth, size.height)];
        yPos += size.height + (gap * 2);
        [self.lblMessage setHidden:NO];
    }
    else{
        [self.lblMessage setHidden:YES];
    }
    
    for (UIView *subView in _alertView.subviews) {
        if(subView != self.lblTitle && subView != self.lblMessage && ![self.buttons containsObject:subView] && self.inputTextField != subView){
            CGRect frame = subView.frame;
            frame.origin.y = yPos;
            frame.size.width = width;
            frame.origin.x = xPos;
            subView.frame = frame;
            yPos += CGRectGetHeight(frame) + gap;
            //            NSLog(@"%@", [subView class]);
        }
    }
    
    if(self.inputTextField){
        [self.inputTextField setFrame:CGRectMake(xPos, yPos, maxWidth, 40)];
        [_alertView addSubview:self.inputTextField];
        yPos += CGRectGetHeight(self.inputTextField.frame) + gap;
    }
    
    BOOL two = NO;
    xPos = 0;
    float btnWidth = width;
    if(self.buttons.count == 2){
        two = YES;
        btnWidth = (width - 1) / 2;
    }
    
    for (UIButton *button in self.buttons) {
        [button setFrame:CGRectMake(xPos, yPos, btnWidth, 40)];
        if(two)
            xPos = btnWidth + 1;
        else
            yPos += 41;
        [_alertView addSubview:button];
        [button setBackgroundColor:[UIColor appGreenColor]];
    }
    CGRect frame = _alertView.frame;
    frame.size.height = yPos + (two ? 40 : 0) - 1;
    [_alertView setFrame:frame];
    
//    [_alertView setFrame:CGRectMake(0, 0, width, yPos + (two ? 40 : 0) - 1)];
    [_alertView setCenter:self.center];
    
//    [_alertView setBackgroundColor:[UIColor greenColor]];
//    [_lblMessage setBackgroundColor:[UIColor redColor]];
//    [_lblTitle setBackgroundColor:[UIColor grayColor]];
    
    if(_style != CustomAlertViewStyleInput){
        [self performSelector:@selector(adjustAlertView) withObject:nil afterDelay:0.05];
    }
}

- (void) adjustAlertView{
    [self performSelectorOnMainThread:@selector(adjustAlertViewForKeyboardHeight) withObject:nil waitUntilDone:YES];
}

- (void) adjustAlertViewForKeyboardHeight{
    [self adjustViewBasedOnKeyboardHeight:0];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.inputTextField resignFirstResponder];
}

- (void) setStyle:(CustomAlertViewStyle)style{
    self.inputTextField = [[JVFloatLabeledTextField alloc] init];
    self.inputTextField.placeholder  =  @"Email Address";
    self.inputTextField.textColor  =  [UIColor  appGrayColor];
    UIFont * font = [UIFont appNormalTextFont];
    self.inputTextField.font  =  font;
    _inputTextField.delegate = self;
    self.inputTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _style = style;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (void) keyboardWillShow:(NSNotification *) notification{
    _inputTextField.delegate = self;
    NSDictionary* userInfo = [notification userInfo];
    CGRect frame =  [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize keyboardSize = frame.size;
    [self adjustViewBasedOnKeyboardHeight:keyboardSize.height];
//    [self setNeedsDisplay];
}

- (void) keyboardWillHide:(NSDictionary *) userInfo{
    [self adjustViewBasedOnKeyboardHeight:0];
//    [self setNeedsDisplay];
}

- (void) adjustViewBasedOnKeyboardHeight:(float) keyboardHeight{
//    CGRect rect = [self convertRect:_inputTextField.frame fromView:self];
//    float yPos = CGRectGetMaxY(rect);
//    NSLog(@"TextField : %@", NSStringFromCGRect(rect));
    
    CGRect rect = [self convertRect:_alertView.frame fromView:self];
    float occupiedYPos = CGRectGetMaxY(rect);
//    NSLog(@"AlertView : %@", NSStringFromCGRect(rect));
   // NSLog(@"%@ : %li", NSStringFromCGRect([UIScreen mainScreen].bounds), (long)[[SharedClass sharedObject] keypadHeight]);
   // float visibleYPos = CGRectGetHeight([UIScreen mainScreen].bounds) - (keyboardHeight + [[SharedClass sharedObject] keypadHeight]);
    
    float visibleYPos = CGRectGetHeight([UIScreen mainScreen].bounds) - (keyboardHeight + 100);

    if(visibleYPos < 0){
        visibleYPos = CGRectGetHeight([UIScreen mainScreen].bounds) - (keyboardHeight);
    }
    visibleYPos -= 5;
    CGRect frame = _alertView.frame;
    frame.origin.y -= (occupiedYPos - visibleYPos);
    [UIView animateWithDuration: 0.2 animations: ^{
//        if(keyboardHeight || [[SharedClass sharedObject] keypadHeight])
        if (keyboardHeight)
            _alertView.frame = frame;
        else
            _alertView.center = self.center;
    }completion: ^(BOOL finished)
     {
     }];
    [UIView commitAnimations];
    
    //NSLog(@"\nOccupied : %f\nVisible : %f", occupiedYPos, visibleYPos);
//    rect = [_inputTextField convertRect:_inputTextField.frame fromView:self];
}

@end
