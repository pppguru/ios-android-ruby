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

@implementation CircleLoaderView

static CircleLoaderView *clView;


+ (CircleLoaderView *) circleView{
    if(!clView){
        clView = [[CircleLoaderView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [clView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.3]];
        
        float width = 40;
        
        UIView *arcBlackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width + 10, width + 10)];
        [arcBlackView setBackgroundColor:[UIColor redColor]];
        [clView addSubview:arcBlackView];
        [arcBlackView.layer setCornerRadius:width / 2];
        arcBlackView.center = clView.center;
//
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath addArcWithCenter:CGPointMake((width / 2) + 1, (width / 2) + 1) radius:(width / 2) + 1 startAngle:DEG2RAD(-90) endAngle:DEG2RAD(0) clockwise:YES];
        [bezierPath bezierPathWithRoundedRect];
        
        CAShapeLayer *progressLayer = [[CAShapeLayer alloc] init];
        [progressLayer setPath:bezierPath.CGPath];
        [progressLayer setStrokeColor:[UIColor blackColor].CGColor];
        [progressLayer setFillColor:[UIColor clearColor].CGColor];
        [progressLayer setLineWidth:2];
        [arcBlackView.layer addSublayer:progressLayer];
//
        
        UIView *arcView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [clView addSubview:arcView];
//        [arcView setBackgroundColor:[UIColor greenColor]];
        arcView.center = clView.center;
        
//        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        bezierPath = [UIBezierPath bezierPath];
//        [bezierPath addArcWithCenter:CGPointMake(width/2, width/2) radius:width-2 startAngle:DEG2RAD(7) endAngle:DEG2RAD(-8) clockwise:YES];
        [bezierPath addArcWithCenter:CGPointMake(width/2, width/2) radius:(width / 2) - 1 startAngle:DEG2RAD(-97) endAngle:DEG2RAD(-82) clockwise:NO];
        
//        CAShapeLayer *progressLayer = [[CAShapeLayer alloc] init];
        progressLayer = [[CAShapeLayer alloc] init];
        [progressLayer setPath:bezierPath.CGPath];
        [progressLayer setStrokeColor:[UIColor whiteColor].CGColor];
        [progressLayer setFillColor:[UIColor clearColor].CGColor];
        [progressLayer setLineWidth:2];
        [arcView.layer addSublayer:progressLayer];
        
//        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//        pathAnimation.duration = 1.0;
//        pathAnimation.fromValue = @(0.0f);
//        pathAnimation.toValue = @(1.0f);
//        [progressLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
//
//        CABasicAnimation *morph = [CABasicAnimation animationWithKeyPath:@"path"];
//        morph.duration = 1;
//        morph.toValue = @(1.0f);
//        [progressLayer addAnimation:morph forKey:nil];
//
//        UIView *_sliceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//        [clView addSubview:_sliceView];
//        _sliceView.center = clView.center;
//        [_sliceView setBackgroundColor:[UIColor whiteColor]];
//        
//        UIBezierPath *_sliceBezierPath = [UIBezierPath bezierPath];
//        [_sliceBezierPath addArcWithCenter:CGPointMake(100, 100) radius:98 startAngle:DEG2RAD(-90) endAngle:DEG2RAD(-90) clockwise:YES];
//        
//        CAShapeLayer *_sliceProgressLayer = [[CAShapeLayer alloc] init];
//        [_sliceProgressLayer setPath:_sliceBezierPath.CGPath];
//        [_sliceProgressLayer setStrokeColor:[UIColor colorWithWhite:1.0 alpha:0.75].CGColor];
//        [_sliceProgressLayer setFillColor:[UIColor clearColor].CGColor];
//        [_sliceProgressLayer setLineWidth:5];
//        [_sliceView.layer addSublayer:_sliceProgressLayer];
        
//        sleep(60);
    }
    
    return clView;
}

+ (void) addToWindow{
    AppDelegate *aDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [aDelegate.window addSubview:[self circleView]];
}

+ (void) removeFromWindow{
    [clView removeFromSuperview];
}


@end
