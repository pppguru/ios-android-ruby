//
//  SMJobResultsVC.m
//  SwissMonkey
//
//  Created by Kasturi on 24/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import "SMJobResultsVC.h"
#import "SMJobProfileDescriptionVC.h"

@implementation SMJobResultsVC{
    
    SMJobResultsModel *  smJobResultsModel;
    UIView *  workDayPreferencesView;
    BOOL  isListTableViewHidden;
    //GMSMapView * gmsmapView;
    
    BOOL readyForLoad;
    
}

@synthesize mapViewButton, listViewButton, listTableView, viewTitleString,jobLocatonsArray;

- (void)viewDidLayoutSubviews{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Load data
    if (self.typeResults == 1)
//        [self updateBottomButtonsStatusWithTitle:@"Jobs For You" method:METHOD_JOBS];
        [self  updateBottomButtonsStatusWithTitle:@"Job History" method:METHOD_HISTORY];
    else if (self.typeResults == 2)
        [self updateBottomButtonsStatusWithTitle:@"Saved Jobs" method:METHOD_SAVEDJOBS];
    else if (self.typeResults == 3)
        [self updateBottomButtonsStatusWithTitle:@"Application Status" method:METHOD_APPLICATIONS];
    else{
        readyForLoad = YES;
        
        // set  up  navigation  view  on the  view
        [ReusedMethods setNavigationViewOnView:self.view WithTitle:viewTitleString andBackgroundColor:[UIColor whiteColor]];
        [ReusedMethods setUpLeftButton:self withImageName:@"back"];
        
        [self reloadAllContent];
    }
    
    //Customize the tabbar buttons
    [self initializeTabButtons];
    
    //Remove the separator line from the tableview
    [self.listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(readyForLoad) {
    
        [self refreshViews];
    }
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark - Update

- (void)refreshViews {
    [smJobResultsModel.tableViewArray removeAllObjects];
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"updated_at" ascending:NO];
    NSArray *descriptors=[NSArray arrayWithObject: descriptor];
    NSArray *reverseOrder=[self.arrayJobs sortedArrayUsingDescriptors:descriptors];
    [smJobResultsModel.tableViewArray addObjectsFromArray:reverseOrder];
    self.arrayJobs = [NSMutableArray arrayWithArray:smJobResultsModel.tableViewArray];
    //  [smJobResultsModel arrangeDisplayLocationPointsOnMapView:mapView];
    
    NSLog(@"listTableView : %@", listTableView);
    [self.view addSubview:[smJobResultsModel setupSelectedlocationInfoView]];
    
    
    // temprory comment
    //Get the arroy companies which are having location / coordinates
    jobLocatonsArray = [self arrayOfJobLocatons];
    //Display locations on map
    //[smJobResultsModel arrangeDisplayLocationPointsOnMapView:mapView withJobLocations:jobLocatonsArray];
    
    //    NSLog(@"%@", viewTitleString);
    
    
    /*
    if([smJobResultsModel.tableViewArray count] == 0){
        NSString *message = @"No jobs found with this search criteria, please try with another search criteria";
        NSString *title = @"No Jobs Found";
        if(![viewTitleString isEqualToString:@"Job Results"]){
            message = nil;
            //            title = [NSString stringWithFormat:@"No job found under %@", viewTitleString];
        }
        
        [[[RBACustomAlert alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
    */
    
    [listTableView reloadData];
    
    
    if(isListTableViewHidden == NO){
        [self listViewButtonAction:listViewButton];
    }
}

- (void)reloadAllContent {
    
    /////////////
    smJobResultsModel =  [[SMJobResultsModel  alloc]  init];
    smJobResultsModel.delegate  = self;
    smJobResultsModel.listTableView = self.listTableView;
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"updated_at" ascending:NO];
    NSArray *descriptors=[NSArray arrayWithObject: descriptor];
    NSArray *reverseOrder=[self.arrayJobs sortedArrayUsingDescriptors:descriptors];
    [smJobResultsModel.tableViewArray addObjectsFromArray:reverseOrder];
    self.arrayJobs = [NSMutableArray arrayWithArray:smJobResultsModel.tableViewArray];
    
    NSLog(@"listTableView : %@", listTableView);
    [self.view addSubview:[smJobResultsModel setupSelectedlocationInfoView]];
    
    
    // temprory comment
    //Get the arroy companies which are having location / coordinates
    jobLocatonsArray = [[NSMutableArray alloc] init];
    jobLocatonsArray = [self arrayOfJobLocatons];
    
    
    [self refreshViews];
}

- (void)  updateBottomButtonsStatusWithTitle:(NSString *)titleString method:(NSString *)methodName{
    if(![ReusedMethods isZipCodeAvailable])
    {
        RBACustomAlert *alert = [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"We recommend to update your profile for better search result." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert setTag:12];
        [alert show];
        return;
    }
    
    _titleString = titleString;
    
    // set  up  navigation  view  on the  view
    [ReusedMethods setNavigationViewOnView:self.view WithTitle:_titleString andBackgroundColor:[UIColor whiteColor]];
    [ReusedMethods setUpLeftButton:self withImageName:@"nav_menu_toggle"];

    APIObject * reqObject = [[APIObject alloc] initWithMethodName:methodName ModuleName:MODULE_JOBS MethodType:METHOD_TYPE_POST Parameters:nil SuccessCallBack:@selector(apiCallSuccess:) AndFailureCallBack:@selector(apiCallFailed:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
    [service makeWebServiceCall];
}

#pragma mark - Reload

- (void) reloadResults:(NSArray*) jobs {
    self.viewTitleString  =  _titleString;
    self.arrayJobs = _jobs;
    self.savedJobs = jobs;
    
    readyForLoad = YES;
    [self reloadAllContent];
}

#pragma mark - API response
- (void) apiCallSuccess:(WebServiceCalls *)server{
    _jobs = [server.responseData objectForKey:@"jobs"];
    APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_SAVEDJOBS ModuleName:MODULE_JOBS MethodType:METHOD_TYPE_POST Parameters:nil SuccessCallBack:@selector(apiSavedCallSuccess:) AndFailureCallBack:@selector(apiSavedCallFailed:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
    // [service makeWebServiceCall];
    
    [self reloadResults:[server.responseData objectForKey:@"jobs"]];
}

- (void) apiCallFailed:(WebServiceCalls *)server{
    
}

- (void) apiSavedCallSuccess:(WebServiceCalls *)server{
    [self reloadResults:[server.responseData objectForKey:@"jobs"]];
    
}
- (void) apiSavedCallFailed:(WebServiceCalls *)server{
    
}

#pragma mark - Other


-(NSMutableArray *)arrayOfJobLocatons
{
    NSMutableArray *arrayOfJobLocatons = [[NSMutableArray alloc] init];
    
    NSMutableArray * latLongArray = [[NSMutableArray alloc] init];
    
    //Listing the Lat Long values...
    //for (NSMutableDictionary *jobsDict in self.arrayJobs)
    for (NSMutableDictionary *jobsDict in smJobResultsModel.tableViewArray)
    {
        if ([[jobsDict allKeys] containsObject:@"company_lat"])
        {
            NSString * lat = [jobsDict objectForKey:@"company_lat"];
            NSString * longitude = [jobsDict objectForKey:@"company_long"];
            
            NSString *predicateString = [NSString stringWithFormat:@"company_lat = %@ && company_long = %@",lat,longitude];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
            NSArray *array = [latLongArray filteredArrayUsingPredicate:predicate];
          
            if (array.count == 0)
            {
                NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:lat,@"company_lat",longitude,@"company_long", nil];
                [latLongArray addObject:dict];
            }
   
            
          //  [arrayOfJobLocatons addObject:jobsDict];
        }
    }
    NSLog(@"LAT LONG ARRAY %@",latLongArray);
    
    //Separating list of jobs with lat and long values...
    for (NSDictionary * dict  in latLongArray)
    {
        NSString * lat = [dict objectForKey:@"company_lat"];
        NSString * longitude = [dict objectForKey:@"company_long"];
        NSString *predicateString = [NSString stringWithFormat:@"company_lat = %@ && company_long = %@",lat,longitude];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
        NSArray *array = [smJobResultsModel.tableViewArray filteredArrayUsingPredicate:predicate];
        
        NSMutableDictionary * resultDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
        [resultDict setObject:array forKey:@"jobs"];
        [arrayOfJobLocatons addObject:resultDict];
    }
    NSLog(@"RESULTS %@",arrayOfJobLocatons);
    return arrayOfJobLocatons;
    
}

//  place  under development for  map view
//
//- (void)placeUnderDevelopmentlabel{
//    
//    UILabel * underConstruction  = [[UILabel alloc] initWithFrame:CGRectMake(20 ,40 ,CGRectGetWidth(self.view.frame) - (2 * 20),25)];
//    underConstruction.lineBreakMode = NSLineBreakByWordWrapping;
//    underConstruction.numberOfLines = 0;
//    underConstruction.font = [UIFont appNormalTextFont];
//    underConstruction.backgroundColor = [UIColor clearColor];
//    underConstruction.textColor = [UIColor appGrayColor];
//    underConstruction.text  = @"UnderConstruction";
//    underConstruction.textAlignment = NSTextAlignmentCenter;
//    [mapView addSubview:underConstruction];
// 
//}



#pragma mark - UI Tab Button Customization

- (void) initializeTabButtons {
    //Customize the List View Button
    [listViewButton setTitleColor:[UIColor appCustomMediumPurpleColor] forState:UIControlStateNormal];
    [listViewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [listViewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    //Customize the Map View Button
    [mapViewButton setTitleColor:[UIColor appCustomMediumBlueColor] forState:UIControlStateNormal];
    [mapViewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [mapViewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    //Set default selected state to List View Button
    [self tabButtonSelected:listViewButton];
    [self tabButtonDeselected:mapViewButton];
}

- (void)tabButtonSelected:(UIButton*)tabButton {
    [tabButton setSelected:YES];
    
    if (tabButton == listViewButton)
        [tabButton setBackgroundColor:[UIColor appCustomPurpleColor]];
    else if (tabButton == mapViewButton)
        [tabButton setBackgroundColor:[UIColor appCustomMediumBlueColor]];
    
    [ReusedMethods applyBottomBorderIndicator:tabButton];
}

- (void)tabButtonDeselected:(UIButton*)tabButton {
    [tabButton setSelected:NO];
    
    if (tabButton == mapViewButton)
        [tabButton setBackgroundColor:[UIColor appCustomLightBlueColor]];
    else if (tabButton == listViewButton)
        [tabButton setBackgroundColor:[UIColor appCustomLightPurpleColor]];
    
    [ReusedMethods removeBottomBorder:tabButton];
}

- (void) setUpAdvancedSearchButton{
    UIButton * advancedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [advancedButton setFrame :CGRectMake(CGRectGetWidth(self.view.frame) - 145, 35, 130, 25)];
    [advancedButton setBackgroundColor: [UIColor clearColor]];
    [advancedButton  setTitle:@"ADVANCED SEARCH" forState:UIControlStateNormal];
    [advancedButton setTitleColor:[UIColor colorWithRed:40/255.0 green:41/255.0 blue:41/255.0 alpha:1.0] forState:UIControlStateNormal];
    [[advancedButton  layer] setCornerRadius:5.0f];
    [[advancedButton layer]  setBorderWidth:1.0f];
    [[advancedButton layer]  setBorderColor:[UIColor appLightGrayColor].CGColor];
    [[advancedButton layer]  setMasksToBounds:YES];
    [[advancedButton titleLabel] setFont:[UIFont appLatoBlackFont10]];
    [advancedButton addTarget:self action:@selector(navViewRightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:advancedButton];
}

- (void) updateUIBasedOnSender:(id) sender{
    
    BOOL hiddenStatus =  ([sender tag] ==  JOB_RESULTS_LISTBUTTON_TAG)  ?  NO : YES ;
    [listTableView  setHidden:hiddenStatus];
    isListTableViewHidden  =  hiddenStatus;
    if(!hiddenStatus){
        
        [_mapView clear];
        [_mapView removeFromSuperview];
//        _mapView.delegate = nil;
        _mapView = nil;
        [listTableView reloadData];
     
        [self.view sendSubviewToBack:smJobResultsModel.locationTableView];
        
        [self.view bringSubviewToFront:listTableView];
    }
    else{
        
        _mapView = [[GMSMapView alloc] initWithFrame:listTableView.frame];
//        _mapView.delegate =  self;
        [self.view addSubview:_mapView];
        
        
        [self.view bringSubviewToFront:smJobResultsModel.locationTableView];
        [smJobResultsModel removePolyLine];
        //Display locations on map
        jobLocatonsArray = [self arrayOfJobLocatons];
        [smJobResultsModel arrangeDisplayLocationPointsOnMapView:_mapView withJobLocations:jobLocatonsArray];
        
    }
}

#pragma mark - BUTTON ACTIONS

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController  popViewControllerAnimated:YES];
}

#pragma mark - User Interaction - Tabbar Button

- (IBAction)mapViewButttonAction:(id)sender {
    [_mapView clear];
    
    [self tabButtonSelected:mapViewButton];
    [self tabButtonDeselected:listViewButton];
    
    [self  updateUIBasedOnSender:sender];
    
    smJobResultsModel.selectedTableView = smJobResultsModel.locationTableView;
}

- (IBAction)listViewButtonAction:(id)sender {
    
    [self tabButtonSelected:listViewButton];
    [self tabButtonDeselected:mapViewButton];
    
    [self  updateUIBasedOnSender:sender];
    
    smJobResultsModel.locationTableView.alpha = 0;
    smJobResultsModel.selectedTableView.tag = 0;
}

- (IBAction)cancelButtonAction:(id)sender {
    
    [workDayPreferencesView removeFromSuperview];
}

- (IBAction)navViewLeftButtonAction:(id)sender{
    isListTableViewHidden = NO;
    
    if (self.typeResults > 0)
        [[SlideNavigationController sharedInstance] toggleLeftMenu];
    else
        [self.navigationController  popViewControllerAnimated:YES];
}

- (IBAction)navViewRightButtonAction:(id)sender{
    
   // [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isAdvancedSearch"];
    
    

   // SMSearchVC * searchVC  =  [self.storyboard instantiateViewControllerWithIdentifier:SM_SEARCH_VC];
    //[searchVC advancedSearchButtonAction:sender];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isAdvancedSearch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [ReusedMethods checkAppFlow];
}

#pragma mark - SMJOBRESULTSMODEL DELEGATE METHODS

- (BOOL) savedJob:(NSDictionary *)job{
//    NSLog(@"%@", self.viewTitleString);
    NSString *predicateString = [NSString stringWithFormat:@"job_id = %@", [job objectForKey:@"job_id"]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    NSArray *array = [_savedJobs filteredArrayUsingPredicate:predicate];
    
    return array.count;
}

- (IBAction)saveButtonAction:(id)jobID {
    
}

- (void)viewButtonAction:(NSDictionary *) jobDetails{
    SMJobProfileDescriptionVC * smJobProfileDescVC  =  [self.storyboard instantiateViewControllerWithIdentifier:SM_JOB_PROFILE_DESC_VC];
    [smJobProfileDescVC setJobDetails:jobDetails];
    [self.navigationController pushViewController:smJobProfileDescVC animated:YES];
}

- (IBAction)fullTimeButtonAction:(UIButton *)sender {
    NSDictionary *job = [_arrayJobs objectAtIndex:sender.tag];
    NSLog(@"Shifts : %@", [job objectForKey:@"shifts"]);
//    NSLog(@"%ld", sender.tag);
    [self setUpPopUpViewWithParameters:[job objectForKey:@"shifts"]];
}

- (void)mapDirectionButtonAction:(UIButton *)sender{
    
    [smJobResultsModel drawRouteOnView:_mapView withButton:sender];
}



#pragma mark - TABLE VIEW DELEGATE METHODS

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [smJobResultsModel tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [smJobResultsModel  tableView:tableView numberOfRowsInSection:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [smJobResultsModel  tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [smJobResultsModel  tableView:tableView heightForRowAtIndexPath:indexPath];
//    if([viewTitleString.uppercaseString isEqualToString:@"Application Status".uppercaseString])
//        return 170.0;
//    else
//        return 155.0;
}

#pragma  mark - MAP VIEW DELEGATE METHODS 
- (BOOL) mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    [smJobResultsModel removePolyLine];
    [smJobResultsModel updateSelectedLocationInfoOfMarker:marker];
    return YES;
}
- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    
    
}

//#pragma mark  ----  SEARCH POPUP DELEGATE METHODS   -------
//
//- (void) selectedValue:(NSString *)title withIndex:(NSInteger) index titleName:(NSString *)titleName andSubTitle:(NSString *)subTitle selectedCell:(UITableViewCell *)selectedCell{
//    
//}
//
//- (void)popTipViewWasDismissedByUser:(RBAPopup *)popTipView{
//    
//}
# pragma mark - SET UP  POP FOR  JOBTYPE

- (void) setUpPopUpViewWithParameters:(NSMutableArray *) parametersArray{
    workDayPreferencesView = [smJobResultsModel  setUpPopUpViewWithParameters:parametersArray];
    [workDayPreferencesView setCenter:self.view.center];
    [self.view addSubview:workDayPreferencesView];
}


#pragma mark - Slide Menu Display
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}


@end
