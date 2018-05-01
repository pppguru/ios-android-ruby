//
//  NotificationView.m
//  SwissMonkey
//
//  Created by Yadagiri Neeli on 11/03/16.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import "NotificationView.h"

@implementation NotificationView

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
