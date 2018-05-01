//
//  SMSettingsVC.h
//  SwissMonkey
//
//  Created by Kasturi on 31/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import "SMHomeVC.h"
#import "SMSettingsModel.h"


@interface SMSettingsVC : SMHomeVC<UITextFieldDelegate,UIAlertViewDelegate,SMSettingsModelDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UIButton *accountStatus;

- (IBAction)resetPasswordButtonAction:(id)sender;
- (IBAction)deactivateYourAccountAction:(id)sender;

@end
