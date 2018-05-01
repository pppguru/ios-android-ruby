//
//  RBAMultiplePopup.m
//  FleetSync-Mobile
//
//  Created by Prasad on 9/9/15.
//  Copyright (c) 2015 RBA. All rights reserved.
//

#import "RBAMultiplePopup.h"


#import <QuartzCore/QuartzCore.h>
#import "MultipleSelectionOptionsCell.h"
//#import "ComplexFilterVC.h"

@interface RBAMultiplePopup ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
{
    CGSize					popupViewSize;
    BOOL					isHilight;
    multiplePopupPinDirection			multiplePopuppinDirection;
    CGFloat				_cornerRadius;
    CGFloat				_pointerSize;
    CGPoint				_targetPoint;
    UIToolbar* numberToolbar;
//    TPKeyboardAvoidingTableView         *tblView;
    CGRect              initialViewRect;
}

@property (nonatomic, strong, readwrite)	id	targetObject;
@property (nonatomic, strong) NSTimer *autoDismissTimer;
@property (nonatomic, strong) UIButton *dismissTarget;
@end


@implementation RBAMultiplePopup
@synthesize contactsArray,textFeild,key, allData, selectedRowsArray, idName, dataType, selectedCellsArray;
- (CGRect)bubbleFrame
{
    CGRect bubbleFrame;
    if (multiplePopuppinDirection == multiplePopupPinDirectionUp)
    {
        bubbleFrame = CGRectMake(_sidePadding, _targetPoint.y+_pointerSize, popupViewSize.width, popupViewSize.height);
    }
    else
    {
        bubbleFrame = CGRectMake(_sidePadding, _targetPoint.y-_pointerSize-popupViewSize.height, popupViewSize.width, popupViewSize.height);
    }
    return bubbleFrame;
}

- (CGRect)contentFrame
{
    CGRect bubbleFrame = [self bubbleFrame];
    CGRect contentFrame = CGRectMake(bubbleFrame.origin.x + _cornerRadius,
                                     bubbleFrame.origin.y + _cornerRadius,
                                     bubbleFrame.size.width - _cornerRadius*2,
                                     bubbleFrame.size.height - _cornerRadius*2);
    return contentFrame;
}

- (void)layoutSubviews
{
    if (self.customView)
    {
        CGRect contentFrame = [self contentFrame];
        [self.customView setFrame:contentFrame];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGRect bubbleRect = [self bubbleFrame];
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(currentContext, 0.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(currentContext, self.borderWidth);
    
    CGMutablePathRef bubblePath = CGPathCreateMutable();
    
    if (multiplePopuppinDirection == multiplePopupPinDirectionUp)
    {
        CGPathMoveToPoint(bubblePath, NULL, _targetPoint.x+_sidePadding, _targetPoint.y);
        CGPathAddLineToPoint(bubblePath, NULL, _targetPoint.x+_sidePadding+_pointerSize, _targetPoint.y+_pointerSize);
        
        CGPathAddArcToPoint(bubblePath, NULL,
                            bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y,
                            bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y+_cornerRadius,
                            _cornerRadius);
        CGPathAddArcToPoint(bubblePath, NULL,
                            bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y+bubbleRect.size.height,
                            bubbleRect.origin.x+bubbleRect.size.width-_cornerRadius, bubbleRect.origin.y+bubbleRect.size.height,
                            _cornerRadius);
        CGPathAddArcToPoint(bubblePath, NULL,
                            bubbleRect.origin.x, bubbleRect.origin.y+bubbleRect.size.height,
                            bubbleRect.origin.x, bubbleRect.origin.y+bubbleRect.size.height-_cornerRadius,
                            _cornerRadius);
        CGPathAddArcToPoint(bubblePath, NULL,
                            bubbleRect.origin.x, bubbleRect.origin.y,
                            bubbleRect.origin.x+_cornerRadius, bubbleRect.origin.y,
                            _cornerRadius);
        CGPathAddLineToPoint(bubblePath, NULL, _targetPoint.x+_sidePadding-_pointerSize, _targetPoint.y+_pointerSize);
    }
    else
    {
        CGPathMoveToPoint(bubblePath, NULL, _targetPoint.x+_sidePadding, _targetPoint.y);
        CGPathAddLineToPoint(bubblePath, NULL, _targetPoint.x+_sidePadding-_pointerSize, _targetPoint.y-_pointerSize);
        
        CGPathAddArcToPoint(bubblePath, NULL,
                            bubbleRect.origin.x, bubbleRect.origin.y+bubbleRect.size.height,
                            bubbleRect.origin.x, bubbleRect.origin.y+bubbleRect.size.height-_cornerRadius,
                            _cornerRadius);
        CGPathAddArcToPoint(bubblePath, NULL,
                            bubbleRect.origin.x, bubbleRect.origin.y,
                            bubbleRect.origin.x+_cornerRadius, bubbleRect.origin.y,
                            _cornerRadius);
        CGPathAddArcToPoint(bubblePath, NULL,
                            bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y,
                            bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y+_cornerRadius,
                            _cornerRadius);
        CGPathAddArcToPoint(bubblePath, NULL,
                            bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y+bubbleRect.size.height,
                            bubbleRect.origin.x+bubbleRect.size.width-_cornerRadius, bubbleRect.origin.y+bubbleRect.size.height,
                            _cornerRadius);
        CGPathAddLineToPoint(bubblePath, NULL, _targetPoint.x+_sidePadding+_pointerSize, _targetPoint.y-_pointerSize);
    }
    
    CGPathCloseSubpath(bubblePath);
    
    CGContextSaveGState(currentContext);
    CGContextAddPath(currentContext, bubblePath);
    CGContextClip(currentContext);
    
    // Fill with solid color
    CGContextSetFillColorWithColor(currentContext, [self.backgroundColor CGColor]);
    CGContextFillRect(currentContext, self.bounds);
    
    
    
    // Draw top highlight and bottom shadow
    if (self.has3DStyle)
    {
        CGContextSaveGState(currentContext);
        CGMutablePathRef innerShadowPath = CGPathCreateMutable();
        
        // add a rect larger than the bounds of bubblePath
        CGPathAddRect(innerShadowPath, NULL, CGRectInset(CGPathGetPathBoundingBox(bubblePath), -30, -30));
        
        // add bubblePath to innershadow
        CGPathAddPath(innerShadowPath, NULL, bubblePath);
        CGPathCloseSubpath(innerShadowPath);
        
        // draw top highlight
        UIColor *highlightColor = [UIColor colorWithWhite:1.0 alpha:0.75];
        CGContextSetFillColorWithColor(currentContext, highlightColor.CGColor);
        CGContextSetShadowWithColor(currentContext, CGSizeMake(0.0, 4.0), 4.0, highlightColor.CGColor);
        CGContextAddPath(currentContext, innerShadowPath);
        CGContextEOFillPath(currentContext);
        
        // draw bottom shadow
        UIColor *shadowColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        CGContextSetFillColorWithColor(currentContext, shadowColor.CGColor);
        CGContextSetShadowWithColor(currentContext, CGSizeMake(0.0, -4.0), 4.0, shadowColor.CGColor);
        CGContextAddPath(currentContext, innerShadowPath);
        CGContextEOFillPath(currentContext);
        
        CGPathRelease(innerShadowPath);
        CGContextRestoreGState(currentContext);
    }
    
    CGContextRestoreGState(currentContext);
    
    //Draw Border
    if (self.borderWidth > 0)
    {
        int numBorderComponents = (int)CGColorGetNumberOfComponents([self.borderColor CGColor]);
        const CGFloat *borderComponents = CGColorGetComponents(self.borderColor.CGColor);
        
        CGFloat red, green, blue, alpha;
        
        if (numBorderComponents == 2)
        {
            red = borderComponents[0];
            green = borderComponents[0];
            blue = borderComponents[0];
            alpha = borderComponents[1];
        }
        else
        {
            red = borderComponents[0];
            green = borderComponents[1];
            blue = borderComponents[2];
            alpha = borderComponents[3];
        }
        
        CGContextSetRGBStrokeColor(currentContext, red, green, blue, alpha);
        CGContextAddPath(currentContext, bubblePath);
        CGContextDrawPath(currentContext, kCGPathStroke);
    }
    
    CGPathRelease(bubblePath);
    
    // Draw title and text
    if (self.title)
    {
        [self.titleTextColor set];
        CGRect titleFrame = [self contentFrame];
        [self.title drawInRect:titleFrame
                      withFont:self.titleFont
                 lineBreakMode:NSLineBreakByClipping
                     alignment:self.titleTextAlignment];
    }
    
    if (self.message)
    {
        [self.messageTextColor set];
        CGRect textFrame = [self contentFrame];
        
        // Move down to make room for title
        if (self.title)
        {
            textFrame.origin.y += [self.title sizeWithFont:self.titleFont
                                         constrainedToSize:CGSizeMake(textFrame.size.width, 99999.0)
                                             lineBreakMode:NSLineBreakByClipping].height;
        }
        
        [self.message drawInRect:textFrame
                        withFont:self.messageFont
                   lineBreakMode:NSLineBreakByWordWrapping
                       alignment:self.messageTextAlignment];
    }
}

- (void)presentPointingAtView:(UIView *)targetView inView:(UIView *)containerView animated:(BOOL)animated
{
    if (!self.targetObject)
    {
        self.targetObject = targetView;
    }
    
    // If we want to dismiss the bubble when the user taps anywhere, we need to insert
    // an invisible button over the background.
    if ( self.dismissTapAnywhere )
    {
        self.dismissTarget = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.dismissTarget addTarget:self action:@selector(dismissTapAnywhereFired:) forControlEvents:UIControlEventTouchUpInside];
        [self.dismissTarget setTitle:@"" forState:UIControlStateNormal];
        self.dismissTarget.frame = containerView.bounds;
        [containerView addSubview:self.dismissTarget];
    }
    
    [containerView addSubview:self];
    
    // Size of rounded rect
    CGFloat rectWidth;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // iPad
        if (self.bubbleWidth)
        {
            if (self.bubbleWidth < containerView.frame.size.width)
            {
                rectWidth = self.bubbleWidth;
            }
            else
            {
                rectWidth = containerView.frame.size.width - 20;
            }
        }
        else
        {
            rectWidth = (int)(containerView.frame.size.width/3);
        }
    }
    else
    {
        // iPhone
        if (self.bubbleWidth)
        {
            if (self.bubbleWidth < containerView.frame.size.width)
            {
                rectWidth = self.bubbleWidth;
            }
            else
            {
                rectWidth = containerView.frame.size.width - 10;
            }
        }
        else
        {
            rectWidth = (int)(containerView.frame.size.width*2/3);
        }
        
        
    }
    
    CGSize textSize = CGSizeZero;
    
    if (self.message!=nil)
    {
        textSize= [self.message sizeWithFont:self.messageFont
                           constrainedToSize:CGSizeMake(rectWidth, 99999.0)
                               lineBreakMode:NSLineBreakByWordWrapping];
    }
    if (self.customView != nil)
    {
        textSize = self.customView.frame.size;
    }
    if (self.title != nil)
    {
        textSize.height += [self.title sizeWithFont:self.titleFont
                                  constrainedToSize:CGSizeMake(rectWidth, 99999.0)
                                      lineBreakMode:NSLineBreakByClipping].height;
    }
    
    float textSizeWidth = textSize.width;
    if(textSizeWidth <= 50)
        textSizeWidth = 60;
    
    popupViewSize = CGSizeMake(textSizeWidth + _cornerRadius*2, textSize.height + _cornerRadius*2);
    
    UIView *superview = containerView.superview;
    if ([superview isKindOfClass:[UIWindow class]])
        superview = containerView;
    
    CGPoint targetRelativeOrigin    = [targetView.superview convertPoint:targetView.frame.origin toView:superview];
    CGPoint containerRelativeOrigin = [superview convertPoint:containerView.frame.origin toView:superview];
    
    CGFloat pointerY;	// Y coordinate of pointer target (within containerView)
    
    
    if (targetRelativeOrigin.y+targetView.bounds.size.height < containerRelativeOrigin.y)
    {
        pointerY = 0.0;
        multiplePopuppinDirection = multiplePopupPinDirectionUp;
    }
    else if (targetRelativeOrigin.y > containerRelativeOrigin.y+containerView.bounds.size.height)
    {
        pointerY = containerView.bounds.size.height;
        multiplePopuppinDirection = multiplePopupPinDirectionDown;
    }
    else
    {
        multiplePopuppinDirection = _preferredPinDirection;
        CGPoint targetOriginInContainer = [targetView convertPoint:CGPointMake(0.0, 0.0) toView:containerView];
        CGFloat sizeBelow = containerView.bounds.size.height - targetOriginInContainer.y;
        if (multiplePopuppinDirection == multiplePopupPinDirectionAny)
        {
            if (sizeBelow > targetOriginInContainer.y)
            {
                pointerY = targetOriginInContainer.y + targetView.bounds.size.height;
                multiplePopuppinDirection = multiplePopupPinDirectionUp;
            }
            else
            {
                pointerY = targetOriginInContainer.y;
                multiplePopuppinDirection = multiplePopupPinDirectionDown;
            }
        }
        else
        {
            if (multiplePopuppinDirection == multiplePopupPinDirectionDown)
            {
                pointerY = targetOriginInContainer.y;
            }
            else
            {
                pointerY = targetOriginInContainer.y + targetView.bounds.size.height;
            }
        }
    }
    
    CGFloat W = containerView.bounds.size.width;
    
    CGPoint p = [targetView.superview convertPoint:targetView.center toView:containerView];
    CGFloat x_p = p.x;
    CGFloat x_b = x_p - roundf(popupViewSize.width/2);
    if (x_b < _sidePadding)
    {
        x_b = _sidePadding;
    }
    if (x_b + popupViewSize.width + _sidePadding > W)
    {
        x_b = W - popupViewSize.width - _sidePadding;
    }
    if (x_p - _pointerSize < x_b + _cornerRadius)
    {
        x_p = x_b + _cornerRadius + _pointerSize;
    }
    if (x_p + _pointerSize > x_b + popupViewSize.width - _cornerRadius)
    {
        x_p = x_b + popupViewSize.width - _cornerRadius - _pointerSize;
    }
    
    CGFloat fullHeight = popupViewSize.height + _pointerSize + 10.0;
    CGFloat y_b;
    if (multiplePopuppinDirection == multiplePopupPinDirectionUp)
    {
        y_b = _topMargin + pointerY;
        _targetPoint = CGPointMake(x_p-x_b, 0);
    }
    else
    {
        y_b = pointerY - fullHeight;
        _targetPoint = CGPointMake(x_p-x_b, fullHeight-2.0);
    }
    
    CGRect finalFrame = CGRectMake(x_b-_sidePadding,
                                   y_b,
                                   popupViewSize.width+_sidePadding*2,
                                   fullHeight);
    
   	
    if (animated) {
        if (self.animation == PopTipAnimationSlide)
        {
            self.alpha = 0.0;
            CGRect startFrame = finalFrame;
            startFrame.origin.y += 10;
            self.frame = startFrame;
        }
        else if (self.animation == PopTipAnimationPop)
        {
            self.frame = finalFrame;
            self.alpha = 0.5;
            
            // start a little smaller
            self.transform = CGAffineTransformMakeScale(0.75f, 0.75f);
            
            // animate to a bigger size
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(popAnimationDidStop:finished:context:)];
            [UIView setAnimationDuration:0.15f];
            self.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
            self.alpha = 1.0;
            [UIView commitAnimations];
        }
        
        [self setNeedsDisplay];
        
        if (self.animation == PopTipAnimationSlide)
        {
            [UIView beginAnimations:nil context:nil];
            self.alpha = 1.0;
            self.frame = finalFrame;
            [UIView commitAnimations];
        }
    }
    else
    {
        // Not animated
        [self setNeedsDisplay];
        self.frame = finalFrame;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:containerView.frame];
    
    if (view.frame.origin.x > 300) {
        CGRect frame = view.frame;
        frame.origin.x = 0;
        view.frame = frame;
    }
    
    self.center = CGPointMake(view.center.x, self.center.y);
    
}

- (void)presentPointingAtBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated
{
    UIView *targetView = (UIView *)[barButtonItem performSelector:@selector(view)];
    UIView *targetSuperview = [targetView superview];
    UIView *containerView = nil;
    if ([targetSuperview isKindOfClass:[UINavigationBar class]])
    {
        containerView = [UIApplication sharedApplication].keyWindow;
    }
    else if ([targetSuperview isKindOfClass:[UIToolbar class]])
    {
        containerView = [targetSuperview superview];
    }
    
    if (nil == containerView)
    {
        //NSLog(@"Cannot determine container view from UIBarButtonItem: %@", barButtonItem);
        self.targetObject = nil;
        return;
    }
    
    self.targetObject = barButtonItem;
    
    [self presentPointingAtView:targetView inView:containerView animated:animated];
}

- (void)finaliseDismiss
{
    [self.autoDismissTimer invalidate]; self.autoDismissTimer = nil;
    
    if (self.dismissTarget)
    {
        [self.dismissTarget removeFromSuperview];
        self.dismissTarget = nil;
        [textFeild setUserInteractionEnabled:YES];
    }
    
    [self removeFromSuperview];
    
    isHilight = NO;
    self.targetObject = nil;
    
}

- (void)dismissAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [self finaliseDismiss];
}

- (void)dismissAnimated:(BOOL)animated
{
    
    if (animated)
    {
        CGRect frame = self.frame;
        frame.origin.y += 10.0;
        
        [UIView beginAnimations:nil context:nil];
        self.alpha = 0.0;
        self.frame = frame;
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(dismissAnimationDidStop:finished:context:)];
        [UIView commitAnimations];
    }
    else
    {
        [self finaliseDismiss];
    }
}

- (void)autoDismissAnimatedDidFire:(NSTimer *)theTimer
{
    NSNumber *animated = [[theTimer userInfo] objectForKey:@"animated"];
    [self dismissAnimated:[animated boolValue]];
    [self notifyDelegatePopTipViewWasDismissedByUser];
}

- (void)autoDismissAnimated:(BOOL)animated atTimeInterval:(NSTimeInterval)timeInvertal
{
    NSDictionary * userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:animated] forKey:@"animated"];
    
    self.autoDismissTimer = [NSTimer scheduledTimerWithTimeInterval:timeInvertal
                                                             target:self
                                                           selector:@selector(autoDismissAnimatedDidFire:)
                                                           userInfo:userInfo
                                                            repeats:NO];
}

- (void)notifyDelegatePopTipViewWasDismissedByUser
{
    __strong id<RBAMultiplePopupDelegate> delegate = self.delegate;
    [delegate popTipViewWasDismissedByUser:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.disableTapToDismiss)
    {
        [super touchesBegan:touches withEvent:event];
        return;
    }
    
    [self dismissByUser];
}

- (void)dismissTapAnywhereFired:(UIButton *)button
{
    [self dismissByUser];
}

- (void)dismissByUser
{
    isHilight = YES;
    [self setNeedsDisplay];
    
    [self dismissAnimated:YES];
    
    [self notifyDelegatePopTipViewWasDismissedByUser];
}

- (void)popAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    // at the end set to normal size
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1f];
    self.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        selectedCellsArray = [[NSMutableArray alloc] init];
       // selectedRowsArray =  [[NSMutableArray alloc] init];
        
        // Initialization code
        self.opaque = NO;
        
        _topMargin = 2.0;
        _pointerSize = 12.0;
        _sidePadding = 2.0;
        _borderWidth = 1.0;
        
        self.messageFont = [UIFont boldSystemFontOfSize:14.0];
        self.messageTextColor = [UIColor whiteColor];
        self.messageTextAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor colorWithRed:62.0/255.0 green:60.0/255.0 blue:154.0/255.0 alpha:1.0];
        self.has3DStyle = NO;
        self.borderColor = [UIColor blackColor];
        self.hasShadow = YES;
        self.animation = PopTipAnimationSlide;
        self.dismissTapAnywhere = YES;
        self.preferredPinDirection = multiplePopupPinDirectionAny;
        self.cornerRadius = 3.0;
    }
    return self;
}

- (void)setHasShadow:(BOOL)isHasShadow
{
    if (isHasShadow)
    {
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.layer.shadowRadius = 2.0;
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOpacity = 0.3;
    }
    else
    {
        self.layer.shadowOpacity = 0.0;
    }
}

- (multiplePopupPinDirection) getPinDirection
{
    return multiplePopuppinDirection;
}


- (id)initWithTitle:(NSString *)titleToShow message:(NSString *)messageToShow
{
    CGRect frame = CGRectZero;
    
    if ((self = [self initWithFrame:frame]))
    {
        self.title = titleToShow;
        self.message = messageToShow;
        
        self.titleFont = [UIFont boldSystemFontOfSize:16.0];
        self.titleTextColor = [UIColor whiteColor];
        self.titleTextAlignment = NSTextAlignmentCenter;
        self.messageFont = [UIFont systemFontOfSize:14.0];
        self.messageTextColor = [UIColor whiteColor];
    }
    return self;
}

- (id)initWithTitle:(NSString *)titleToShow message:(NSString *)messageToShow  delegate: (id)delegate titleColor:(UIColor *)titleColor  messageColor:(UIColor *)messageColor  backGroundColor:(UIColor *)backGroundColor borderColor:(UIColor *)borderColor;
{
    
    CGRect frame = CGRectZero;
    self.delegate = delegate;
    if ((self = [self initWithFrame:frame]))
    {
        self.title = titleToShow;
        self.message = messageToShow;
        
        self.titleFont = [UIFont boldSystemFontOfSize:16.0];
        self.messageFont = [UIFont systemFontOfSize:14.0];
        
        self.titleTextAlignment = NSTextAlignmentCenter;
        
        
        //To set Defaul Colors
        if(messageColor == nil && backGroundColor == nil)
        {
            messageColor = [UIColor whiteColor];
            backGroundColor = [UIColor blackColor];
        }
        else if (messageColor != nil && backGroundColor == nil)
        {
            backGroundColor = [self reverseColorOf:messageColor];
        }
        else  if(messageColor == nil && backGroundColor != nil)
        {
            messageColor = [self reverseColorOf:backGroundColor];
        }
        
        if(titleColor == nil)
            titleColor = messageColor;
        if (borderColor == nil)
            borderColor = backGroundColor;
        
        //Set the colors
        self.backgroundColor = backGroundColor;
        self.borderColor = borderColor;
        self.titleTextColor = titleColor;
        self.messageTextColor = messageColor;
    }
    return self;
}

//====== TO GET THE OPPOSIT COLORS =====
-(UIColor *)reverseColorOf :(UIColor *)oldColor
{
    CGColorRef oldCGColor = oldColor.CGColor;
    
    int numberOfComponents = (int)CGColorGetNumberOfComponents(oldCGColor);
    // can not invert - the only component is the alpha
    if (numberOfComponents == 1) {
        return [UIColor colorWithCGColor:oldCGColor];
    }
    
    const CGFloat *oldComponentColors = CGColorGetComponents(oldCGColor);
    CGFloat newComponentColors[numberOfComponents];
    
    int i = numberOfComponents - 1;
    newComponentColors[i] = oldComponentColors[i]; // alpha
    while (--i >= 0) {
        newComponentColors[i] = 1 - oldComponentColors[i];
    }
    
    CGColorRef newCGColor = CGColorCreate(CGColorGetColorSpace(oldCGColor), newComponentColors);
    UIColor *newColor = [UIColor colorWithCGColor:newCGColor];
    CGColorRelease(newCGColor);
    
    //For the gray colors 'Middle level colors'
    CGFloat white = 0;
    [oldColor getWhite:&white alpha:nil];
    
    if(white>0.3 && white < 0.67)
    {
        if(white >= 0.5)
            newColor = [UIColor darkGrayColor];
        else if (white < 0.5)
            newColor = [UIColor blackColor];
    }
    return newColor;
}

- (id)initWithMessage:(NSString *)messageToShow
{
    CGRect frame = CGRectZero;
    
    if ((self = [self initWithFrame:frame]))
    {
        self.message = messageToShow;
    }
    return self;
}

- (id)initWithCustomView:(UIView *)aView
{
    CGRect frame = CGRectZero;
    
    if ((self = [self initWithFrame:frame]))
    {
        self.customView = aView;
        [self addSubview:self.customView];
    }
    for (UIView *view in aView.subviews) {
        if ([view isKindOfClass:[UITableView class]]) {
            _tblView = (TPKeyboardAvoidingTableView *)view;
            _tblView.delegate = self;
            _tblView.dataSource = self;
        }
    }
    return self;
}

#pragma mark - UITableView DataSource and Delegate Methods.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)doneButtonAction:(UIButton *)sender
{
    NSLog(@" selectedRowsArray-----: %@",selectedRowsArray);
    NSDictionary *selectAllDict = [NSDictionary dictionaryWithObjects:@[@"Select All",@0] forKeys:@[@"position_name", @"position_id"]];
    if ([selectedRowsArray containsObject:selectAllDict]){
        [selectedRowsArray removeObject:selectAllDict];
    }
    
    [self endEditing:YES];
        NSMutableArray *selectedDataStrings = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in selectedRowsArray) {
            [selectedDataStrings addObject:[dict valueForKey:key]];
        }
        NSString *selectedCominedString = [selectedDataStrings componentsJoinedByString: @", "];
        if ([textFeild canPerformAction:@selector(setText:) withSender:nil])
        {
            [(UITextField *)textFeild setText:selectedCominedString];
        }
       // [self.delegate selectedMultipleValueData:selectedRowsArray andTypeName:key andIdName:idName andDataType:dataType];
        if ([self.delegate respondsToSelector:@selector(selectedMultipleValueData:withkeyId:andKey:andDataType:)])
            [self.delegate selectedMultipleValueData:selectedRowsArray withkeyId:idName andKey:key andDataType:(PopupType)self.tag];
        [self dismissAnimated:YES];
}

- (BOOL) checkingForMaxSelectionPercentage{
    int total = 0;
    for (NSDictionary *dict in selectedRowsArray) {
        total += [[dict valueForKey:@"TITLE"] intValue];
    }
    
    return total <= contactsArray.count ? YES : NO;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[ReusedMethods setSeperatorProperlyForCell:cell];
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contactsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *commonCell;
//    if ([key isEqualToString:@"TITLE"]) {
//        static NSString *CellIdentifier = @"Cell JobSearchOptionsCell";
//;
//        JobSearchOptionsCell *cell = (JobSearchOptionsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        
//        if (cell == nil)
//        {
//            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SlideBarCell" owner:self options:nil];
//            cell = [nib objectAtIndex:0];
//        }
//        cell.titleLBL.text = [[contactsArray objectAtIndex:indexPath.row] objectForKey:key];
//        
//        cell.sliderBar.tag = indexPath.row;
//        cell.selectionButton.tag = indexPath.row;
//        cell.sliderValueTxtFld.tag = indexPath.row;
//        cell.sliderValueTxtFld.delegate = self;
//        
//        [cell.sliderBar removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
//        [cell.sliderBar addTarget:self action:@selector(setSliderValueWithValue:) forControlEvents:UIControlEventValueChanged];
//        
//        [cell.sliderValueTxtFld removeTarget:nil action:NULL forControlEvents:UIControlEventEditingDidEndOnExit];
//        [cell.sliderValueTxtFld addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventValueChanged];
//        
//        [cell.selectionButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
//        [cell.selectionButton addTarget:self action:@selector(selectonButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        
//        NSDictionary * selectedDict = [self isRowSelected:[contactsArray objectAtIndex:indexPath.row]];
//        if( selectedDict )
//        {
//            cell.accessoryType = UITableViewCellAccessoryNone;//Check Mark
//            [cell.selectionButton setImage:[UIImage imageNamed:@"CheckMark"] forState:UIControlStateNormal];
//         //   [cell.sliderBar setHidden:NO];
//            [cell.sliderValueLBL setHidden:NO];
//            [cell.sliderValueTxtFld setHidden:NO];
//            NSString *sliderValueStr = [selectedDict valueForKey:DB_CN_WORKSITE_MINERAL_PERCENTAGE];
//            
////            [cell.sliderValueLBL setText:[NSString stringWithFormat:@"%@%@",sliderValueStr ? sliderValueStr : @"0",@"%"]];
////            [cell.sliderValueLBL setText:[NSString stringWithFormat:@"%@",sliderValueStr ? sliderValueStr : @"0"]];
////            [cell.sliderBar setValue:[sliderValueStr integerValue]];
////            [cell.sliderValueTxtFld setText:[NSString stringWithFormat:@"%@%@",sliderValueStr ? sliderValueStr : @"0",@"%"]];
//            [cell.sliderValueTxtFld setText:[NSString stringWithFormat:@"%@",sliderValueStr ? sliderValueStr : @""]];
//        }
//        else
//        {
//            cell.accessoryType = UITableViewCellAccessoryNone;
//            [cell.selectionButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//            [cell.sliderBar setHidden:YES];
//            [cell.sliderValueLBL setHidden:YES];
//            [cell.sliderValueTxtFld setHidden:YES];
//           // [cell.sliderBar setValue:0];
//        }
//        commonCell = cell;
//        if ([self.delegate isKindOfClass:[ComplexFilterVC class]])
//        {
//            cell.sliderValueTxtFld.hidden = YES;
//            cell.percentageLbl.hidden = YES;
//        }
//    }
//    else
//    {
        static NSString *CellIdentifier = @"MultipleSelectionOptionsCell";
        MultipleSelectionOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
        if (cell == nil)
        {
            cell = (MultipleSelectionOptionsCell *) [[MultipleSelectionOptionsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier frameWidth:CGRectGetWidth(tableView.frame) andHeight:50] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    
        NSDictionary *dicCellInfo = [contactsArray objectAtIndex:indexPath.row];
        NSString *titleName = [dicCellInfo objectForKey:key];
    
        if ([key isEqualToString:@"state_name"]) {
            titleName = [titleName uppercaseString];
        }
    
        cell.optionLabel.text = titleName;
        [cell.checkBoxButton setUserInteractionEnabled:NO];
    
        if( [selectedRowsArray containsObject:dicCellInfo] )
        {
            //cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [cell.checkBoxButton setImage:[UIImage imageNamed:@"Verify_selected"] forState:UIControlStateNormal];
            [cell.checkBoxButton setImage:[UIImage imageNamed:@"Verify_selected"] forState:UIControlStateFocused];
            [cell.checkBoxButton setImage:[UIImage imageNamed:@"Verify_selected"] forState:UIControlStateHighlighted];
        }
        else
        {
            [cell.checkBoxButton setImage:[UIImage imageNamed:@"Verify"] forState:UIControlStateNormal];
            [cell.checkBoxButton setImage:[UIImage imageNamed:@"Verify"] forState:UIControlStateFocused];
            [cell.checkBoxButton setImage:[UIImage imageNamed:@"Verify"] forState:UIControlStateHighlighted];

            //cell.accessoryType = UITableViewCellAccessoryNone;

        }
//        commonCell = cell;
    //}
    
    return cell;
}

//Apply action select a row in cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *selectedData = [contactsArray objectAtIndex:indexPath.row];
    //if  ([[selectedData allKeys] containsObject:DB_CN_WORKSITE_MINERAL_ID])
    //{
    NSDictionary * selectedDict = [self isRowSelected:selectedData];
    BOOL isSelected = false;
    if( selectedDict )
    {
        //if (![[NSString stringWithFormat:@"%@",[selectedDict objectForKey:@"software_type_id"]] isEqualToString:@"15"]) {
            [selectedRowsArray removeObject:selectedDict];
        //}
        
        isSelected = FALSE;
    }
    else
    {
        [selectedRowsArray addObject:selectedData];
        
        isSelected = TRUE;
    }
    
    if (indexPath.row == 0 && [[selectedData valueForKey:key] isEqualToString:@"Select All"]) {
        [selectedRowsArray removeAllObjects];
        if (!selectedDict) {
            [selectedRowsArray removeAllObjects];
            [selectedRowsArray addObjectsFromArray:contactsArray];
            //[selectedRowsArray removeObject:selectedData];
        }
    }
    
    NSDictionary *selectAllDict = [NSDictionary dictionaryWithObjects:@[@"Select All",@0] forKeys:@[@"position_name", @"position_id"]];
    
    if ((selectedRowsArray.count != contactsArray.count) && [selectedRowsArray containsObject:selectAllDict]){
        [selectedRowsArray removeObject:selectAllDict];
    }else if ((selectedRowsArray.count == contactsArray.count - 1) && ![selectedRowsArray containsObject:selectAllDict]){
        [selectedRowsArray insertObject:selectAllDict atIndex:0];
    }
    
    if ([self.delegate respondsToSelector:@selector(itemSelectedwithData:andDataType:selected:)]) {
       // [self.delegate itemSelectedwithData:selectedData andDataType:(PopupType)self.tag selected:isSelected];
    }
    
    //   }
    //   else
    //   {
    //       if( [selectedRowsArray containsObject:selectedData] )
    //       {
    //           [selectedRowsArray removeObject:selectedData];
    //       }
    //        else
    //        {
    //          [selectedRowsArray addObject:selectedData];
    //       }
    //
    //   }
    //
    
    
    /*
     UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
     //    UIViewController * vc = (UIViewController *)self.delegate;
     //  UITextField *contactTitleField = (UITextField *)[vc.view  viewWithTag:2];
     
     if ([textFeild canPerformAction:@selector(setText:) withSender:nil])
     {
     [(UITextField *)textFeild setText:cell.textLabel.text];
     }
     //[self.delegate selectedValue:[[contactsArray objectAtIndex:indexPath.row] objectForKey:key] withIndex:indexPath.row titleName:key];
     */
    
    [tableView reloadData];
    
    // [self dismissAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return 60;
//    if ([key isEqualToString:DB_CN_WORKSITE_MINERAL_TITLE]) {
//        return 60;
//    }else{
//        return 44;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 0;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    float doneButtonWidth = 50;
//    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tblView.frame), 40)];
//    
//    UISearchBar *searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tblView.frame)-doneButtonWidth, 40)];
//    [searchbar setDelegate:self];
//    [searchView addSubview:searchbar];
//    
//    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    doneButton.frame = CGRectMake(CGRectGetWidth(tblView.frame)-doneButtonWidth, 0, doneButtonWidth, 40);
//    [doneButton setBackgroundImage:[UIImage imageNamed:@"profileimage"] forState:UIControlStateNormal];
//    [doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    [searchView addSubview:doneButton];
//    
////    [tblView setTableHeaderView:searchView];
//    return searchView;
//}

#pragma mark - UISearchBar Delegate Methods

//- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchbar
//{
//    return YES;
//}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchbar
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    searchbar.showsCancelButton=YES;
}


- (void)searchBar:(UISearchBar *)searchbar textDidChange:(NSString *)searchText
{
    //DDLogWarn(@"M: searchBar: textDicChange: %@", searchText);
    [contactsArray removeAllObjects];
    if([searchText length]){
        NSString *predicateString = [NSString stringWithFormat:@"%@ CONTAINS[c] '%@'", key, searchText];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
        [contactsArray addObjectsFromArray:[allData filteredArrayUsingPredicate:predicate]];
    }
    else{
        [contactsArray addObjectsFromArray:allData];
    }
    [_tblView reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchbar
{
    [searchbar resignFirstResponder];
    searchbar.showsCancelButton = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchbar
{
    [searchbar resignFirstResponder];
}

-(void) searchResign
{
    //    [_machineSearchBySerialNumberSearchBar resignFirstResponder];
}

# pragma mark - KEYBOARD NOTIFICATION METHODS.

- (void)keyboardDidShow:(NSNotification *)notification
{
    // Assign new frame to your view
//    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    
//    initialViewRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
//    
//    NSInteger viewHeight = self.frame.size.height;
//    NSInteger viewRelativePosition = self.frame.origin.y;
//    NSInteger viewFrameOffset = viewHeight - viewRelativePosition;
//    NSInteger movement = MAX(0,keyboardSize.height-viewFrameOffset);
//    NSInteger animateY = (self.frame.origin.y-movement) < 0 ? 20 : self.frame.origin.y-movement ;
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.25];
//    self.frame = CGRectMake(self.frame.origin.x,animateY,self.frame.size.width,self.frame.size.height);
//    [UIView commitAnimations];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.25];
//    [self setFrame:CGRectMake(initialViewRect.origin.x, initialViewRect.origin.y, initialViewRect.size.width, initialViewRect.size.height)];
//    [UIView commitAnimations];
//    
//    
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidHideNotification object:nil];
//    
    // initialViewRect = CGRectZero;
    
}

//- (IBAction)setSliderValueWithValue:(UISlider *)sender{
//    SlideBarCell *selectedCell = (SlideBarCell *)[_tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
//    [selectedCell.sliderValueLBL setText:[NSString stringWithFormat:@"%0.0f%@", sender.value,@"%"]];
//    NSString *sliderValue = [NSString stringWithFormat:@"%0.0f", sender.value];
//    [[contactsArray objectAtIndex:sender.tag] setObject:sliderValue forKey:DB_CN_WORKSITE_MINERAL_PERCENTAGE];
//    for (NSMutableDictionary *dict in selectedRowsArray) {
//        if ([[dict valueForKey:key] isEqualToString:selectedCell.titleLBL.text]) {
//            [dict setObject:sliderValue forKey:DB_CN_WORKSITE_MINERAL_PERCENTAGE];
//        }
//    }
//}


-(void)textFieldValueChanged:(UITextField *)sender
{
//    JobSearchOptionsCell *selectedCell = (JobSearchOptionsCell *)[_tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
//    [selectedCell.sliderValueLBL setText:[NSString stringWithFormat:@"%0.0f%@", [sender.text floatValue],@"%"]];
//    NSString *sliderValue = [NSString stringWithFormat:@"%0.0f", [sender.text floatValue]];
//    [[contactsArray objectAtIndex:sender.tag] setObject:sliderValue forKey:DB_CN_WORKSITE_MINERAL_PERCENTAGE];
//    for (NSMutableDictionary *dict in selectedRowsArray) {
//        if ([[dict valueForKey:key] isEqualToString:selectedCell.titleLBL.text]) {
//            [dict setObject:sliderValue forKey:DB_CN_WORKSITE_MINERAL_PERCENTAGE];
//        }
//    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    if  (![SharedClass sharedObject].isPad)
//    {
//        textField.keyboardType = UIKeyboardTypeNumberPad;
//        [self initilizeNumberToolBar];
//        textField.inputAccessoryView = numberToolbar;
//    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length > 0)
    {
        NSString * updatedValue = [textField text];
        if  ([updatedValue intValue] == 0)
        {
            textField.text = string;
            [self textFieldValueChanged:textField];
            return NO;
        }
       updatedValue = [NSString stringWithFormat:@"%@%@",textField.text,string];
        if ([updatedValue floatValue] > 100)
        {
            return NO;
        }
        else
        {
            textField.text = updatedValue;
            [self textFieldValueChanged:textField];
            return NO;
        }
        //return YES;
    }
    NSString *newString = [textField.text substringToIndex:[textField.text length]-1];
    
    textField.text=newString;

    [self textFieldValueChanged:textField];
    return NO;
}
- (IBAction)selectonButtonAction:(UIButton *)sender{
    [self tableView:_tblView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
}


-(NSDictionary * )isRowSelected:(NSDictionary *)cellDict
{
    if (selectedRowsArray.count && [[selectedRowsArray objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
        NSString *strPredicate;
        
        id keyValue = [cellDict objectForKey:idName];
        if ([keyValue isKindOfClass:[NSString class]]) {
            strPredicate = [NSString stringWithFormat:@"%@ like '%@'",idName, keyValue];
        }
        else {
            NSInteger   skillID = [keyValue integerValue];
            strPredicate = [NSString stringWithFormat:@"%@ = %ld",idName, (long)skillID];
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:strPredicate];
        NSArray * array = [selectedRowsArray filteredArrayUsingPredicate:predicate];
        if (array.count) {
            return  [array firstObject];
        }
    }
   
    
//    NSString * wsMineralId = [cellDict objectForKey:DB_CN_WORKSITE_MINERAL_ID];
//    NSString *strPredicate = [NSString stringWithFormat:@"WS_Mi_ID = %@", wsMineralId]; //DB_CN_WORKSITE_MINERAL_ID
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:strPredicate];
//    NSArray * array = [selectedRowsArray filteredArrayUsingPredicate:predicate];
//    if (array.count) {
//        return  [array firstObject];
//    }
    return nil;
}

-(void)initilizeNumberToolBar
{
//    if (numberToolbar ==  nil)
//    {
//        numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
//        numberToolbar.barStyle = UIBarStyleBlackTranslucent;
//        UIBarButtonItem * doneItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)];
//        doneItem.tintColor = [UIColor themNavTitleColor];
//        numberToolbar.items = [NSArray arrayWithObjects:
//                               
//                               [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
//                               doneItem,
//                               nil];
//        [numberToolbar sizeToFit];
//        [numberToolbar setBarTintColor:[UIColor themeNavigationColor]];
//    }

}

-(void)doneWithNumberPad
{
    [self endEditing:YES];
}
@end
