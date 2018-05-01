//
//  CircleLoaderView.h
//  SwissMonkey
//
//  Created by Yadagiri Neeli on 20/01/16.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleLoaderView : UIView

+ (CircleLoaderView *) circleView;
+ (void) addToWindow;
+ (void) removeFromWindow;

@end
