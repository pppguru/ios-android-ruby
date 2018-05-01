//
//  UIColor+CustomColor.m
//  SwissMonkey
//
//  Created by Kasturi on 23/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import "UIColor+CustomColor.h"

@implementation UIColor (CustomColor)

+  (UIColor *)  appLightGrayColor{
    
    return [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1];
}

+  (UIColor *)  appHeadingGrayColor{
    
    return [UIColor colorWithRed:142/255.0 green:142/255.0 blue:146/255.0 alpha:1];
}

+  (UIColor *)  appGrayColor{
    
    return [UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1];
}

+  (UIColor *)  appPinkColor{
    
    return [UIColor colorWithRed:71/255.0 green:40/255.0 blue:101/255.0 alpha:1];
}
+  (UIColor *)  appLightPinkColor{
    
    return [UIColor colorWithRed:124/255.0 green:109/255.0 blue:160/255.0 alpha:1];
}


+  (UIColor *)  appGreenColor{
    
    return [UIColor colorWithRed:59/255.0 green:141/255.0 blue:155/255.0 alpha:1];
}

+  (UIColor *)  appBlueColor{
    
    return [UIColor colorWithRed:124/255.0 green:109/255.0 blue:160/255.0 alpha:1];
}

+  (UIColor *)  appBrightNavColor{
    
    return [UIColor colorWithRed:226/255.0 green:230/255.0 blue:232/255.0 alpha:1];
}

+ (UIColor *) applightNavColor{
    
    return [UIColor lightTextColor];//[UIColor colorWithRed:251/255.0 green:251/255.0 blue:251/255.0 alpha:1];
}

+ (UIColor *) appWhiteColor{
    
    return [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
}

+ (UIColor *)  appBrightTextColor{
    return [UIColor blackColor];
}

+(UIColor *) appLightTextColor{
    return [UIColor colorWithRed:147/255.0 green:147/255.0 blue:147/255.0 alpha:1];
    
}


#pragma mark - New Color Theme
+ (UIColor *) appCustomPurpleColor {
    return [UIColor colorWithRed:125./255.0 green:40./255.0 blue:125./255.0 alpha:1];
}

+ (UIColor *) appCustomMediumPurpleColor {
    return [UIColor colorWithRed:209./255.0 green:179./255.0 blue:209./255.0 alpha:1];
}

+ (UIColor *) appCustomLightPurpleColor {
    return [UIColor colorWithRed:242./255.0 green:233./255.0 blue:242./255.0 alpha:1];
}

+ (UIColor *) appCustomLightGreenColor {
    return [UIColor colorWithRed:24./255.0 green:217./255.0 blue:143./255.0 alpha:1];
}

+ (UIColor *) appCustomDarkGreenColor {
    return [UIColor colorWithRed:0/255.0 green:142./255.0 blue:0./255.0 alpha:1];
}

+ (UIColor *) appCustomLightBlueColor {
    return [UIColor colorWithRed:209./255.0 green:231./255.0 blue:234./255.0 alpha:1];
}
+ (UIColor *) appCustomMediumBlueColor {
//    return [UIColor colorWithRed:118./255.0 green:182./255.0 blue:191./255.0 alpha:1];
    return [UIColor colorWithRed:72./255.0 green:158./255.0 blue:171./255.0 alpha:1];
}

+ (UIColor *) appCustomBrightBlueColor {
    return [UIColor colorWithRed:0./255.0 green:213./255.0 blue:247./255.0 alpha:1];
}


@end
