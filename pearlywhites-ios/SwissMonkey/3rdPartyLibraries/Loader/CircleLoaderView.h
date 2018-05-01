//
//  CircleLoaderView.h
//  SwissMonkey
//
//  Created by Yadagiri Neeli on 20/01/16.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleLoaderView : UIView

//+ (CircleLoaderView *) circleView;
//+ (CircleLoaderView *) circleViewWithWidth:(float) width;
//+ (CircleLoaderView *) circleViewWithWidth:(float) width borderColor:(UIColor *)border lineColor:(UIColor *)line;
+ (UIView *) window;
+ (void) addToWindow;
+ (void) addToWindowWithWidth:(float) width;
+ (void) addToWindowWithWidth:(float) width circleColor:(UIColor *)circleColor arcColor:(UIColor *)arcColor;
+ (void) addToWindowWithCircleColor:(UIColor *)circleColor arcColor:(UIColor *)arcColor;
+ (void) removeFromWindow;

@end
