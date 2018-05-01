//
//  LabelButton.h
//  SwissMonkey
//
//  Created by Kareem on 2016-07-14.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelButton : UIButton

@property (strong,nonatomic) UILabel * txtLbl;
-(void)resizeButtonFrame;
-(void)addTxtLabel;
@end
