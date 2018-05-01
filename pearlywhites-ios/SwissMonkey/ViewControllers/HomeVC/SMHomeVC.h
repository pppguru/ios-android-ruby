//
//  SMHomeVC.h
//  SwissMonkey
//
//  Created by Kasturi on 24/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMHomeModel.h"

@interface SMHomeVC : UIViewController<SMHomeModelDelegate, SlideNavigationControllerDelegate>

@property (nonatomic, retain) SMHomeModel *smHomeModel;
@property (weak, nonatomic)  UIButton *menuButton;
@property (weak , nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) NSArray *jobs, *savedJobs;

@property (weak, nonatomic)  IBOutlet UIButton *searchButton;
@property (weak, nonatomic)  IBOutlet UIButton *jobsForYouButton;
@property (weak, nonatomic)  IBOutlet UIButton *applicationStatusButton;
@property (weak, nonatomic)  IBOutlet UIButton *jobHistoryButton;
@property (weak, nonatomic)  IBOutlet UIButton *savedJobsButton;

- (IBAction)searchButtonAction:(id)sender;
- (IBAction)jobsForYouButtonAction:(id)sender;
- (IBAction)applicationStatusButtonAction:(id)sender;
- (IBAction)jobHistoryButtonAction:(id)sender;
- (IBAction)savedJobsButtonAction:(id)sender;

@property (nonatomic, strong) NSString *titleString;

@end
