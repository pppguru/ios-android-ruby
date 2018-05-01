//
//  CircleLoaderView.m
//  SwissMonkey
//
//  Created by Yadagiri Neeli on 20/01/16.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import "CircleLoaderView.h"

//#define DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)
#define DEG2RAD(angle) angle*M_PI/180.0
#define DEFAULT_WIDTH 40.0f
#define LINE_WIDTH 2.0f

@interface CircleLoaderView(){
}

@property (nonatomic, strong) UIView *arcView;
@property (nonatomic, readwrite) BOOL animating;

@end

@implementation CircleLoaderView

static CircleLoaderView *clView;

+ (CircleLoaderView *) circleViewWithWidth:(float) width circleColor:(UIColor *)circleColor arcColor:(UIColor *)arcColor{
    
    if(!clView){
        clView = [[CircleLoaderView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [clView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.3]];
        
//        float width = 40;
        float half = width / 2.0;
        
        UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [blackView setBackgroundColor:[UIColor clearColor]];
        [clView addSubview:blackView];
        blackView.center = clView.center;
        
        UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width + 80, width + 40)];
        [grayView setCenter:clView.center];
        [grayView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.25f]];
        [[grayView layer] setCornerRadius:10.0f];
        [clView addSubview:grayView];
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:blackView.bounds];
        
        CAShapeLayer *progressLayer = [[CAShapeLayer alloc] init];
//        [progressLayer setPath:bezierPath.CGPath];
//        [progressLayer setStrokeColor:border.CGColor];
//        [progressLayer setFillColor:[UIColor clearColor].CGColor];
//        [progressLayer setLineWidth:3];
//        [blackView.layer addSublayer:progressLayer];
//        
//        
//        bezierPath = [UIBezierPath bezierPathWithOvalInRect:blackView.bounds];
        
//        progressLayer = [[CAShapeLayer alloc] init];
        [progressLayer setPath:bezierPath.CGPath];
        [progressLayer setStrokeColor:circleColor.CGColor];
        [progressLayer setFillColor:[UIColor clearColor].CGColor];
        [progressLayer setLineWidth:LINE_WIDTH + 0.5];
        [blackView.layer addSublayer:progressLayer];
        
//        [brushPattern setStroke];
//        [bezierPath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
        
        clView.arcView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [clView.arcView setBackgroundColor:[UIColor clearColor]];
        [clView addSubview:clView.arcView];
        clView.arcView.center = clView.center;
        
        bezierPath = [UIBezierPath bezierPath];
        [bezierPath addArcWithCenter:CGPointMake(half, half) radius:half startAngle:DEG2RAD(-105) endAngle:DEG2RAD(-80) clockwise:YES];
        
        progressLayer = [[CAShapeLayer alloc] init];
        [progressLayer setPath:bezierPath.CGPath];
        [progressLayer setStrokeColor:arcColor.CGColor];
        [progressLayer setFillColor:[UIColor clearColor].CGColor];
        [progressLayer setLineWidth:LINE_WIDTH];
        [clView.arcView.layer addSublayer:progressLayer];
    }
    
    return clView;
}

+ (void) spinWithOptions: (UIViewAnimationOptions) options {
    // this spin completes 360 degrees every 2 seconds
    [UIView animateWithDuration: 0.35f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         clView.arcView.transform = CGAffineTransformRotate(clView.arcView.transform, M_PI_2);
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             if (clView.animating) {
                                 // if flag still set, keep spinning with constant speed
                                 [self spinWithOptions: UIViewAnimationOptionCurveLinear];
                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
                                 // one last spin, with deceleration
                                 [self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
                             }
                         }
                     }];
}

+ (void) startSpin {
    if (!clView.animating) {
        clView.animating = YES;
        [self spinWithOptions: UIViewAnimationOptionCurveEaseIn];
    }
}

+ (void) stopSpin {
    // set the flag to stop spinning after one last 90 degree increment
    clView.animating = NO;
}

+ (UIView *) window{
    AppDelegate *aDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return aDelegate.window;
}

+ (void) addToWindow{
    [self addToWindowWithWidth:DEFAULT_WIDTH];
    [self startSpin];
}

+ (void) addToWindowWithWidth:(float) width{
    [self addToWindowWithWidth:width circleColor:[UIColor blackColor] arcColor:[UIColor whiteColor]];
    [self startSpin];
}

+ (void) addToWindowWithWidth:(float) width circleColor:(UIColor *)circleColor arcColor:(UIColor *)arcColor{
    CircleLoaderView *loader = [self circleViewWithWidth:width circleColor:circleColor arcColor:arcColor];
    UIView *window = [self window];
    [window addSubview:loader];
    [window bringSubviewToFront:loader];
    [self startSpin];
}

+ (void) addToWindowWithCircleColor:(UIColor *)circleColor arcColor:(UIColor *)arcColor{
    [self addToWindowWithWidth:DEFAULT_WIDTH circleColor:circleColor arcColor:arcColor];
    [self startSpin];
}

+ (void) removeFromWindow{
    if([[SMSharedFilesClass sharedFileObject] dowloadImagesCount] == 0){
        [self stopSpin];
        [clView removeFromSuperview];
    }
}


@end
