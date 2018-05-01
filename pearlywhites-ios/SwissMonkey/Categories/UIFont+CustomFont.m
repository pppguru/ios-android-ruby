//
//  UIFont+CustomFont.m
//  SwissMonkey
//
//  Created by Kasturi on 23/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import "UIFont+CustomFont.h"

@implementation UIFont (CustomFont)

+ (UIFont *) appNormalTextFont{
    return [self appLatoLightFont12];
}

+ (UIFont *) appLatoLightFont10{
    return   [UIFont fontWithName:@"Lato-Light" size:10.0f];
}

+ (UIFont *) appLatoLightFont12{
    return   [UIFont fontWithName:@"Lato-Light" size:12.0f];
}

+ (UIFont *) appLatoLightFont14{
    return   [UIFont fontWithName:@"Lato-Light" size:14.0f];
}

+ (UIFont *) appLatoLightFont15{
    return   [UIFont fontWithName:@"Lato-Light" size:15.0f];
}

+ (UIFont *) appLatoLightFont18{
    return   [UIFont fontWithName:@"Lato-Light" size:18.0f];
}

+ (UIFont *) appLatoBlackFont10{
    return   [UIFont fontWithName:@"Lato-Black" size:10.0f];
}

+ (UIFont *) appLatoBlackFont12{
    return [UIFont fontWithName:@"Lato-Black" size:12.0f];
}

+ (UIFont *) appLatoBlackFont14{
    return   [UIFont fontWithName:@"Lato-Black" size:14.0f];
}

+ (UIFont *) appLatoBlackFont18{
    return   [UIFont fontWithName:@"Lato-Black" size:18.0f];
}

+ (UIFont *) appLatoBlackFont20{
    return   [UIFont fontWithName:@"Lato-Black" size:20.0f];
}

+ (UIFont *) appLatoBlackFont24{
    return   [UIFont fontWithName:@"Lato-Black" size:24.0f];
}
@end
