//
//  SMHelpVC.h
//  SwissMonkey
//
//  Created by Yadagiri Neeli on 08/03/16.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMHomeVC.h"

@interface SMHelpVC : SMHomeVC

- (IBAction)emailAction:(UIButton *)sender;
- (IBAction)callAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UITextView *txtView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end
