//
//  RBAPopup.m
//  Sample
//
//  Created by Prasad on 11/1/13.
//  Copyright (c) 2013 rapidBizApps. All rights reserved.
//

#import "RBAPopup.h"
#import <QuartzCore/QuartzCore.h>
#import "TPKeyboardAvoidingTableView.h"
#import "JobSearchOptionsCell.h"

@interface RBAPopup ()<UITableViewDelegate, UITableViewDataSource>
{
    CGSize					popupViewSize;
    BOOL					isHilight;
    PinDirection			pinDirection;
    CGFloat				_cornerRadius;
    CGFloat				_pointerSize;
    CGPoint				_targetPoint;
    TPKeyboardAvoidingTableView         *tblView;
    CGRect              initialViewRect;
}

@property (nonatomic, strong, readwrite)	id	targetObject;
@property (nonatomic, strong) NSTimer *autoDismissTimer;
@property (nonatomic, strong) UIButton *dismissTarget;
@end


@implementation RBAPopup
@synthesize contactsArray,textFeild,key, allData, keyId, detailLblArray, allDetailLblData, detailLblkey, selectedRowsArray,isHeaderHaving;
@synthesize selectedCellBtn;

- (CGRect)bubbleFrame
{
    CGRect bubbleFrame;
    if (pinDirection == PinDirectionUp)
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
    
    if (pinDirection == PinDirectionUp)
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
        pinDirection = PinDirectionUp;
    }
    else if (targetRelativeOrigin.y > containerRelativeOrigin.y+containerView.bounds.size.height)
    {
        pointerY = containerView.bounds.size.height;
        pinDirection = PinDirectionDown;
    }
    else
    {
        pinDirection = _preferredPinDirection;
        CGPoint targetOriginInContainer = [targetView convertPoint:CGPointMake(0.0, 0.0) toView:containerView];
        CGFloat sizeBelow = containerView.bounds.size.height - targetOriginInContainer.y;
        if (pinDirection == PinDirectionAny)
        {
            if (sizeBelow > targetOriginInContainer.y)
            {
                pointerY = targetOriginInContainer.y + targetView.bounds.size.height;
                pinDirection = PinDirectionUp;
            }
            else
            {
                pointerY = targetOriginInContainer.y;
                pinDirection = PinDirectionDown;
            }
        }
        else
        {
            if (pinDirection == PinDirectionDown)
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
    if (pinDirection == PinDirectionUp)
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
    [self deleteSuperView:self];
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
    __strong id<RBAPopupDelegate> delegate = self.delegate;
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
        // Initialization code
        self.opaque = NO;
        
        _topMargin = 2.0;
        _pointerSize = 12.0;
        _sidePadding = 2.0;
        _borderWidth = 1.0;
        
        self.messageFont = [UIFont boldSystemFontOfSize:14.0];
        self.messageTextColor = [UIColor whiteColor];
        self.messageTextAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor  appGreenColor];//[UIColor colorWithRed:62.0/255.0 green:60.0/255.0 blue:154.0/255.0 alpha:1.0];
        self.has3DStyle = NO;
        self.borderColor = [UIColor appGreenColor];
        self.hasShadow = YES;
        self.animation = PopTipAnimationSlide;
        self.dismissTapAnywhere = YES;
        self.preferredPinDirection = PinDirectionAny;
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

- (PinDirection) getPinDirection
{
    return pinDirection;
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
    for (UIView *subView in self.customView.subviews) {
        if ([subView isKindOfClass:[UITableView class]]) //&& subView.tag != 120)
        {
            tblView = (TPKeyboardAvoidingTableView *)subView;
            tblView.delegate = self;
            tblView.dataSource = self;
            
            
        }
    }
    return self;
}

#pragma mark - UITableView DataSource and Delegate Methods.

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 2 sections. Secton0 for Business partner or Customer center details. Secton1 for Business partner or Customer center CONTACTS details.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contactsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *  cellIdendifier  =  [NSString  stringWithFormat:@"Cell %@",@"JobSearchOptionsCell"];
    
    JobSearchOptionsCell  *cell =  [tableView dequeueReusableCellWithIdentifier:cellIdendifier];
    if(!cell){
        
        cell  =  [[JobSearchOptionsCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdendifier frameWidth:tableView.frame.size.width andHeight:50];
    }
    if (tableView.tag  == DISPLAY_STATES_TABLEVIEW_TAG) {
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    }else{
        cell.selectionStyle  =  UITableViewCellSelectionStyleDefault;
    }
    
//    if([key  isEqualToString:@"positions"]){
//        cell.optionLabel.text  =  [[contactsArray objectAtIndex:indexPath.row] objectForKey:@"position_name"];
//    }else if([key  isEqualToString:@"jobtype"]){
//        cell.optionLabel.text  =  [[contactsArray objectAtIndex:indexPath.row] objectForKey:@"job_type"];
//    }
//    else if([key  isEqualToString:@"experience"]){
//        cell.optionLabel.text  =  [[contactsArray objectAtIndex:indexPath.row] objectForKey:@"experience_range"];
//    }
    cell.optionLabel.text  =  [[contactsArray objectAtIndex:indexPath.row] objectForKey:key];
    [cell.optionLabel setNumberOfLines:0];
    [cell.optionLabel setLineBreakMode:NSLineBreakByWordWrapping];
    /*
     if (tableView.tag == 786) {
     // View or download parts book Button creation.
     
     UIButton *downloadViewButton = [[UIButton alloc] initWithFrame:CGRectMake(80, 70, 100, 30)];
     [downloadViewButton setTitle:NSLocalizedString([[contactsArray objectAtIndex:indexPath.row] valueForKey:MODE_OF_PARTS_BOOK], nil) forState:UIControlStateNormal];
     [downloadViewButton addTarget:self action:@selector(viewOrDownloadPartsBook:) forControlEvents:UIControlEventTouchUpInside];
     
     // View or Download Parts book button Title font family and tag.
     downloadViewButton.titleLabel.font = [UIFont mediumBoldFontInFleetSync];
     downloadViewButton.backgroundColor  = [UIColor themeSelectionColor];
     downloadViewButton.tag = indexPath.row;
     
     [cell.contentView addSubview:downloadViewButton];
     
     // View or Download Parts book data Dictionary.
     NSMutableDictionary *viewOfDownloadPartsBookDictionalry = [contactsArray objectAtIndex:indexPath.row];
     
     // To add file size beside file name
     long actualFileSize = [[viewOfDownloadPartsBookDictionalry valueForKey:FILE_SIZE] longLongValue];
     float fileSize;
     
     // if size is less than 1MB then show size in KB
     if (actualFileSize < 1024*1024)
     {
     fileSize = (float)[[viewOfDownloadPartsBookDictionalry valueForKey:FILE_SIZE] longLongValue]/1024;
     }
     // else show in MB
     else
     {
     fileSize = (float)[[viewOfDownloadPartsBookDictionalry valueForKey:FILE_SIZE] longLongValue]/(1024*1024);
     }
     
     // Parts Book file name showing.
     //NSString *fileNameString = [NSString stringWithFormat:@"%@   %@ MB",[[partsBookPopoverArray objectAtIndex:indexPath.row] valueForKey:FILE_NAME],  [NSString stringWithFormat:@"%.2f", fileSize]];
     NSString *fileName = [[contactsArray objectAtIndex:indexPath.row] valueForKey:FILE_NAME];
     NSArray *array = [fileName componentsSeparatedByString:@"."];
     
     if(array.count > 1){
     fileName = [fileName stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@", [array lastObject]] withString:@""];
     }
     
     cell.textLabel.text = fileName;
     [cell.textLabel setNumberOfLines:2];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     }else{
     if (tableView.tag != 108) {
     [cell.textLabel setFont:[UIFont ThemeHeaderFont]];
     cell.textLabel.text = [[contactsArray objectAtIndex:indexPath.row] objectForKey:key];
     if ([key isEqualToString:DB_CN_BUSINESS_CONTACT_FIRSTNAME]&& [self.delegate isKindOfClass:[AddContactVC class]])
     {
     // Contact name preparing.
     NSMutableString *contactNameString = [[NSMutableString alloc] init];
     
     [contactNameString appendFormat:@"%@ %@", [[contactsArray objectAtIndex:indexPath.row] valueForKey:key], [[contactsArray objectAtIndex:indexPath.row] valueForKey:DB_CN_BUSINESS_CONTACT_LASTNAME]];
     
     // Configure the cell...
     cell.textLabel.text = NSLocalizedString(contactNameString, nil);
     }
     
     }else{
     // Cell text label configuration.
     [cell.textLabel setFont:[UIFont ThemeBoldHeaderFont]];
     
     // Cell Detail label configuration.
     [cell.detailTextLabel setFont:[UIFont ThemeHeaderFont]];
     
     if ([key isEqualToString:DB_CN_BUSINESS_CONTACT_FIRSTNAME])
     {
     // Contact name preparing.
     NSMutableString *contactNameString = [[NSMutableString alloc] init];
     
     [contactNameString appendFormat:@"%@ %@", [[contactsArray objectAtIndex:indexPath.row] valueForKey:key], [[contactsArray objectAtIndex:indexPath.row] valueForKey:DB_CN_BUSINESS_CONTACT_LASTNAME]];
     
     // Configure the cell...
     cell.textLabel.text = NSLocalizedString(contactNameString, nil);
     }
     else
     {
     // Configure the cell...
     cell.textLabel.text = NSLocalizedString([[contactsArray objectAtIndex:indexPath.row] valueForKey:key], nil);
     }
     
     if (detailLblkey)// Mails displaying in Business Contacts.
     {
     cell.detailTextLabel.text = NSLocalizedString([[contactsArray objectAtIndex:indexPath.row] valueForKey:detailLblkey], nil);
     }
     //        // Checkmark Enabiling and disabiling.
     //        for (int i =0 ; i < [groupingPreviousAndNowSelectedDataArray count]; i++)
     //        {
     //            if ([[contactsArray objectAtIndex:indexPath.row] isEqualToDictionary:[groupingPreviousAndNowSelectedDataArray objectAtIndex:i]])
     //            {
     //                cell.accessoryType = UITableViewCellAccessoryCheckmark;
     //            }
     //            else
     //            {
     //                cell.accessoryType = UITableViewCellAccessoryNone;
     //            }
     //        }
     
     }
     
     }
     if (tableView.tag != 108) {
     if( [selectedRowsArray containsObject:[contactsArray objectAtIndex:indexPath.row]] )
     {
     cell.accessoryType = UITableViewCellAccessoryCheckmark;
     }
     else
     {
     cell.accessoryType = UITableViewCellAccessoryNone;
     }
     }else{
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
     }*/
    
    return cell;
    
}

//Apply action select a row in cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobSearchOptionsCell *cell = (JobSearchOptionsCell *)[tableView cellForRowAtIndexPath:indexPath];
    //    UIViewController * vc = (UIViewController *)self.delegate;
    //  UITextField *contactTitleField = (UITextField *)[vc.view  viewWithTag:2];
    
    if ([textFeild canPerformAction:@selector(setText:) withSender:nil])
    {
        [(UITextField *)textFeild setText:cell.optionLabel.text];
    }
    //  if  ([self.delegate isKindOfClass:[MachineSearchVC class]] || [self.delegate isKindOfClass:[EditMachineOtherInfoVC class]])
//   if(tableView.tag != 786)
//    {
//        id object = [contactsArray objectAtIndex:indexPath.row];
//        int index = (int) [allData indexOfObject:object];
//        [self.delegate selectedValue:[contactsArray objectAtIndex:indexPath.row] withIndex:index titleName:@"Key" andSubTitle:@"dummy text" selectedCell:cell];
    [self.delegate selectedValue:[[contactsArray objectAtIndex:indexPath.row] objectForKey:keyId] withKeyId:keyId titleName:[[contactsArray objectAtIndex:indexPath.row] objectForKey:key] withKey:key selectedCell:cell withType:self.tag];
    //}
    
    /*if(tableView.tag != 786)
     {
     [self.delegate selectedValue:[[contactsArray objectAtIndex:indexPath.row] objectForKey:key] withIndex:indexPath.row titleName:key andSubTitle:cell.detailTextLabel.text selectedCell:cell];
     }*/
    
//    if (tableView.tag != 108) {
//        [self dismissAnimated:YES];
//    }
    [self dismissAnimated:YES];
    
}

#pragma mark - DELEGATE METHODS
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *string = [[contactsArray objectAtIndex:indexPath.row] objectForKey:key];
//    CGRect viewFrame = tableView.frame;
//    CGSize sizeOfText = [string boundingRectWithSize: CGSizeMake(CGRectGetWidth(viewFrame) - 52, 200)
//                                             options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
//                                          attributes: [NSDictionary dictionaryWithObject:[UIFont ThemeHeaderFont]                                                                                       forKey:NSFontAttributeName]
//                                             context: nil].size;
//    if (tableView.tag == 786) {
//        return 100;
//    }else if (tableView.tag == 108) {
//        return 50;
//    }else
//        if (sizeOfText.height < 22){
//            return 44;
//        }else{
//            return sizeOfText.height + 5;
//        }
    
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    if(tableView.tag == 108 && isHeaderHaving)
//    {
//        // Header view with header Title .
//        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, HEADER_HEIGHT)];
//        
//        headerView.backgroundColor = [UIColor headerBackgroundColor];
//        
//        UIButton *headerbutton = [UIButton buttonWithType:UIButtonTypeCustom];
//        
//        [headerbutton setExclusiveTouch:YES];
//        
//        [headerbutton setBackgroundColor:[UIColor clearColor]];
//        
//        headerbutton.frame = headerView.frame;
//        
//        [headerbutton addTarget:self action:@selector(showAllMachines:) forControlEvents:UIControlEventTouchUpInside];
//        
//        
//        UILabel *headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, tableView.frame.size.width, 35)];
//        
//        [headerTitleLabel setText:NSLocalizedString(@"Detail View", nil)];
//        
//        // Color.
//        headerTitleLabel.backgroundColor = [UIColor headerBackgroundColor];
//        
//        headerTitleLabel.font = [UIFont bigBoldFontInFleetSync];
//        headerTitleLabel.textColor = [UIColor editableTextColor];
//        headerTitleLabel.textAlignment = NSTextAlignmentCenter;
//        [headerView addSubview:headerTitleLabel];
//        
//        [headerView addSubview:headerbutton];
//        
//        // Header Label title, font and title color.
//        // Add button for Business partner.
//        
//        
//        //UIImage *disclosureImage = [UIImage imageNamed:@"request-selected.png"];
//        //Backgroud_ColorForButton *addButton = [[Backgroud_ColorForButton alloc] initWithFrame:CGRectMake(250, 7, 30, 30) andBackgroundImageName:@"Left_arrow-1.png" andHighlightedImageName:@"" andTitle:@" " andTarget:self selector:@selector(showAllMachines:)];
//        
//        // sendMail button background images for Normal and Highlighted state.
//        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [addButton  setFrame:CGRectMake(headerbutton.frame.size.width - 30, 8, 15, 20)];
//        [addButton setExclusiveTouch:YES];
//        // Button background images for Normal and Highlighted state.
//        [addButton setBackgroundImage:[UIImage imageNamed:@"next_arrow"] forState:UIControlStateNormal];
//        
//        [addButton addTarget:self action:@selector(showAllMachines:) forControlEvents:UIControlEventTouchUpInside ];
//        [addButton setTitleColor:[UIColor highlightedBackgroundColor] forState:UIControlStateNormal];
//        
//        // Button background color and gradiant layer.
//        //[CommonMethodClass applyGradiantAndBackgroundColorToButton:addButton andCornerRadius:DEFAULT_CORNER_RADIUS];
//        
//        //[addButton setBackgroundColor:[UIColor redColor]];
//        // add button to cell.
//        [headerView addSubview:addButton];
//        
//        //[headerView setBackgroundColor:[UIColor greenColor]];
//        return headerView;
//    }else if (tableView.tag == 786){
//        // Header view.
//        UIView *headerView = [CommonMethodClass tableViewHeaderViewWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 35)];
//        
//        // Header title lable.
//        UILabel *headerTitleLabel = [CommonMethodClass headerLabelWithFrame:CGRectMake(5, 0, tableView.frame.size.width, 35)];
//        
//        // table view header title.
//        headerTitleLabel.text = NSLocalizedString(@"Parts Book Files", nil);
//        [headerView addSubview:headerTitleLabel];
//        return headerView;
//    }
    return nil;
}

//-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if((tableView.tag == 108 && isHeaderHaving) || tableView.tag == 786)
//    {
//        return 35;
//    }
//    else
//        return 0;
//}

- (IBAction)showAllMachines:(id)sender{
//    if ([self.parentVCDelegate respondsToSelector:@selector(showMachinesList:)])
//    {
//        [self.parentVCDelegate showMachinesList:contactsArray];
//    }
}

- (void) showMachinesList:(NSMutableArray *) popOverData{
    
}

#pragma mark - UISearchBar Delegate Methods

//- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchbar
//{
//    return YES;
//}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchbar
{
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];

    
    searchbar.showsCancelButton=YES;
}


- (void)searchBar:(UISearchBar *)searchbar textDidChange:(NSString *)searchText
{
    [contactsArray removeAllObjects];
    if([searchText length]){
       // NSString *predicateString = [NSString stringWithFormat:@"SELF contains '%@'", searchText];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF[%@] contains[cd] %@",key, searchText];
        [contactsArray addObjectsFromArray:[allData filteredArrayUsingPredicate:predicate]];
        NSLog(@"predicate  %@" ,  predicate);
    }
    else{
        [contactsArray addObjectsFromArray:allData];
    }
    [tblView reloadData];
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
   // [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchbar
{
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
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
  /*  CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    initialViewRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    
    NSInteger viewHeight = self.frame.size.height;
    NSInteger viewRelativePosition = self.frame.origin.y;
    NSInteger viewFrameOffset = viewHeight - viewRelativePosition;
    NSInteger movement = MAX(0,keyboardSize.height-viewFrameOffset);
    NSInteger animateY = (self.frame.origin.y-movement) < 0 ? 20 : self.frame.origin.y-movement ;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.frame = CGRectMake(self.frame.origin.x,animateY,self.frame.size.width,self.frame.size.height);
    [UIView commitAnimations];*/
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    
  /*  [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [self setFrame:CGRectMake(initialViewRect.origin.x, initialViewRect.origin.y, initialViewRect.size.width, initialViewRect.size.height)];
    [UIView commitAnimations];
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    // initialViewRect = CGRectZero;
    */
}

# pragma mark - PARTS BOOK VIEW OR DOWNLOADING

//- (void) viewOrDownloadPartsBook:(Backgroud_ColorForButton*)sender
//{
//    
//    selectedCellBtn = (UIButton *)sender;
//    NSString *fileMode = [sender titleForState:UIControlStateNormal];
//    
//    // View or Download Parts book data Dictionary.
//    NSMutableDictionary *viewOfDownloadPartsBookDictionalry = [contactsArray objectAtIndex:sender.tag];
//    
//    // Parts book file name.
//    NSString *partsBookFileName = [CommonMethodClass fileNameFormingUsingFileDataDictionary:viewOfDownloadPartsBookDictionalry];
//    
//    // To add file size beside file name
//    long actualFileSize = [[[contactsArray objectAtIndex:sender.tag] valueForKey:FILE_SIZE] longLongValue];
//    
//    float fileSize;
//    
//    // if size is less than 1MB then show size in KB
//    if (actualFileSize < 1024*1024)
//    {
//        fileSize = (float)[[[contactsArray objectAtIndex:sender.tag] valueForKey:FILE_SIZE] longLongValue]/1024;
//    }
//    // else show in MB
//    else
//    {
//        fileSize = (float)[[[contactsArray objectAtIndex:sender.tag] valueForKey:FILE_SIZE] longLongValue]/(1024*1024);
//    }
//    
//    BOOL isDownloadOnWifi;
//    
//    // If file size >= 25 MB, show alert to download the file on wifi
//    if (actualFileSize >= 25*1024*1024)
//    {
//        isDownloadOnWifi = YES;
//    }
//    else
//    {
//        isDownloadOnWifi = NO;
//    }
//    
//    [self.parentVCDelegate hidePartsBookPopoverOfMode:fileMode andName:partsBookFileName andFileId:[viewOfDownloadPartsBookDictionalry valueForKey:DB_CN_FILE_ID] andFileGroup:PARTS_BOOK_GROUP_ID  onWifiNetwork:isDownloadOnWifi];
//    
//    //    NSString *recordInstance = [viewOfDownloadPartsBookDictionalry objectForKey:DB_CN_RECORD_INSTANCE];
//    //    NSString *partsBookfileId = [viewOfDownloadPartsBookDictionalry objectForKey:DB_CN_FILE_ID];
//    //    NSString *machineSerialNumber = [viewOfDownloadPartsBookDictionalry objectForKey:DB_CN_MACHINE_SERIAL];
//    // Parts book file name.
//    //    NSString *fileName = [NSString stringWithFormat:@"%@_%@%@%@.pdf", machineSerialNumber, partsBookfileId, FILE_NAME_FORMAT, recordInstance];
//}
//
-(void) hidePartsBookPopoverOfMode:(NSString *)fileMode andName:(NSString*)fileName andFileId:(NSString*)fileId andFileGroup:(int)groupId  onWifiNetwork:(BOOL)isDownloadOnWifi
{
    
}
-(void)deleteSuperView:(RBAPopup*)popup
{
    if  (self.annDelegate)
    {
        [self.annDelegate deleteSuperView:popup];
    }
}


@end
