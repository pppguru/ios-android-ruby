//
//  UIColor+CustomColor.h
//  SwissMonkey
//
//  Created by Kasturi on 23/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CustomColor)
+  (UIColor *)  appLightGrayColor;
+  (UIColor *)  appGrayColor;
+  (UIColor *)  appHeadingGrayColor;
+  (UIColor *)  appPinkColor;
+  (UIColor *)  appLightPinkColor;
+  (UIColor *)  appGreenColor;
+  (UIColor *)  appBlueColor;
+  (UIColor *)  appBrightNavColor;
+  (UIColor *) applightNavColor;
+  (UIColor *) appWhiteColor;

+ (UIColor *)  appBrightTextColor;
+ (UIColor *) appLightTextColor;

#pragma mark - New Custom Color

+ (UIColor *) appCustomPurpleColor;
+ (UIColor *) appCustomMediumPurpleColor;
+ (UIColor *) appCustomLightPurpleColor;

+ (UIColor *) appCustomLightGreenColor;
+ (UIColor *) appCustomDarkGreenColor;

+ (UIColor *) appCustomLightBlueColor;
+ (UIColor *) appCustomMediumBlueColor;
+ (UIColor *) appCustomBrightBlueColor;


@end
