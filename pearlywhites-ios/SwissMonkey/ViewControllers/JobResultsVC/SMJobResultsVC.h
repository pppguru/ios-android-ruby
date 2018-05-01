//
//  SMJobResultsVC.h
//  SwissMonkey
//
//  Created by Kasturi on 24/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMJobResultsModel.h"


@interface SMJobResultsVC : UIViewController<SMJobResultsModelDelegate,GMSMapViewDelegate,UITableViewDataSource,UITableViewDelegate>

- (IBAction)mapViewButttonAction:(id)sender;
- (IBAction)listViewButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *mapViewButton;
@property (weak, nonatomic) IBOutlet UIButton *listViewButton;
@property (strong, nonatomic) GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (nonatomic, strong) NSArray *arrayJobs, *savedJobs;
@property  (weak , nonatomic)  NSString *  viewTitleString;
@property (nonatomic, strong) NSMutableArray *jobLocatonsArray;

@property int           typeResults;

@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSArray *jobs;

@end
