//
//  SMProfileVC.h
//  SwissMonkey
//
//  Created by Kasturi on 31/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import "SMHomeVC.h"
#import "SMProfileModel.h"

@interface SMProfileVC : SMHomeVC<SMProfileModelDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailLabel;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (nonatomic, strong) SMProfileModel *profileModel;
@property (weak, nonatomic) IBOutlet TYMProgressBarView *progressView;

- (IBAction)completeProfileButtonAction:(id)sender;

@end
