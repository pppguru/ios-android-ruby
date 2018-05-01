//
//  LabelButton.m
//  SwissMonkey
//
//  Created by Kareem on 2016-07-14.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import "LabelButton.h"

@implementation LabelButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.txtLbl = [[UILabel alloc] initWithFrame:self.bounds];
    self.txtLbl.backgroundColor = [UIColor clearColor];
    self.txtLbl.numberOfLines = 0;
    self.txtLbl.lineBreakMode = NSLineBreakByCharWrapping;
    [self addSubview:self.txtLbl];
}

-(void)addTxtLabel
{
    if (_txtLbl == nil)
    {
        self.txtLbl = [[UILabel alloc] initWithFrame:self.bounds];
        self.txtLbl.backgroundColor = [UIColor clearColor];
        self.txtLbl.numberOfLines = 0;
        self.txtLbl.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:self.txtLbl];
    }
}

-(void)resizeButtonFrame
{
    [self.txtLbl resizeToFit];
    
    CGRect frame = self.frame;
    frame.size.height = CGRectGetHeight(self.txtLbl.frame);
    self.frame = frame;
}
@end
