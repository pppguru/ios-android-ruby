//
//  customScrollView.m
//  SwissMonkey
//
//  Created by Kasturi on 1/28/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "customScrollView.h"

@implementation customScrollView

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    if (aTouch.tapCount == 1)
    {
       // CGPoint p = [aTouch locationInView:self];
        for (UIView *aView in self.subviews) {
            if (([aView isKindOfClass:[UIView class]]) && ([aView tag] == HOME_NOTIFICATIONVIEW_TAG )) //&&(!CGRectContainsPoint(aView.frame, p)))
            {
                [aView removeFromSuperview];
            }
            
        }
    }
}

@end
