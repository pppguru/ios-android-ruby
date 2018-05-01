//
//  SMHomeBottomVC.h
//  SwissMonkey
//
//  Created by Kasturi on 06/01/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSearchModel.h"
#import "SMProfileVC.h"

@interface SMHomeBottomVC : UIViewController


@property (weak, nonatomic) IBOutlet UIButton *jobsForYouButton;
@property (weak, nonatomic) IBOutlet UIButton *applicationStatusButton;
@property (weak, nonatomic) IBOutlet UIButton *jobHistoryButton;
@property (weak, nonatomic) IBOutlet UIButton *savedJobsButton;

- (IBAction)jobsForYouButtonAction:(id)sender;
- (IBAction)applicationStatusButtonAction:(id)sender;
- (IBAction)jobHistoryButtonAction:(id)sender;
- (IBAction)savedJobsButtonAction:(id)sender;
- (IBAction)closeAction:(UIButton *)sender;

@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSArray *jobs;
@property (nonatomic, retain) SMSearchModel *smSearchModel;

@end
