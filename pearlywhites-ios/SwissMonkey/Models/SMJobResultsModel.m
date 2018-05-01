//
//  SMJobResultsModel.m
//  SwissMonkey
//
//  Created by Kasturi on 24/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import "SMJobResultsModel.h"
#import "SMJobResultsVC.h"
#import "JobResultsListTableViewCell.h"
#import "LocationTableViewCell.h"
#import "LocationTblCell.h"
#import "CircleLoaderView.h"

#import <CoreLocation/CoreLocation.h>

@implementation SMJobResultsModel{
    JobResultsListTableViewCell  *jobResultListCell;
    LocationTableViewCell * locationTableViewCell;
    GMSMarker * marker;
    NSMutableArray * polyLinesArray ;
    NSString * mapPoints;
    NSMutableDictionary *  currentSavedJob;

    
}
@synthesize locationTableView;

- (id)  init{
    
    if(self){
        self  =  [super init];
        _tableViewArray  =  [[NSMutableArray alloc] init];
        _markersArray  =  [[NSMutableArray alloc] init];
        polyLinesArray = [[NSMutableArray alloc] init];
        currentSavedJob  = [[NSMutableDictionary alloc] init];
    }
    return self;
}

//- (void) setTableViewArray:(NSArray *)tableViewArray{
//    _tableViewArray = tableViewArray;
//}



#pragma mark  -  TABLE VIEW DELEGATE METHODS

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [ReusedMethods setSeperatorProperlyForCell:cell];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return (tableView.tag == JOB_RESULTS_LOCATIONTABLEVIEW_TAG ) ? self.markedJobLocationDict.count : _tableViewArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag  ==  JOB_RESULTS_LOCATIONTABLEVIEW_TAG) {
        
        /*
        NSString *  cellIdendifier  =  [NSString  stringWithFormat:@"LocationTblCell%ld",indexPath.row];
        
        LocationTblCell *        locTblCell =  [tableView dequeueReusableCellWithIdentifier:cellIdendifier];
        if(!locTblCell){
            //            [tableView  registerNib:[UINib nibWithNibName:@"LocationTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdendifier];
            //            locationTableViewCell =  [tableView dequeueReusableCellWithIdentifier:cellIdendifier];
            locTblCell = [[LocationTblCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdendifier frameWidth:tableView.frame.size.width];
        }
        
        //NSDictionary *job = [_tableViewArray objectAtIndex:indexPath.row];
        
        NSMutableDictionary *job = [[NSMutableDictionary alloc] init];
        job = [self.markedJobLocationDict objectAtIndex:indexPath.row];
        BOOL saved =  [[job objectForKey:SAVED_STATUS] boolValue];//[_delegate savedJob:job];
        
        locTblCell.selectionStyle  =  UITableViewCellSelectionStyleNone;
        [locTblCell  setUpCellData:job];
        
        [locTblCell.fullTimeButton setTag:indexPath.row];
        [locTblCell.saveButton setTag:indexPath.row];
        [locTblCell.viewButton setTag:indexPath.row];
        [locTblCell.mapDirectionButton setTag:indexPath.row];
        
        [locTblCell.fullTimeButton  addTarget:self.delegate action:@selector(fullTimeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [locTblCell.saveButton  addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [locTblCell.viewButton  addTarget:self action:@selector(viewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [locTblCell.mapDirectionButton addTarget:self action:@selector(mapDirectionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [locTblCell.saveButton setHidden:saved];
        
        return locTblCell;
         
         */
        
        NSString *  cellIdendifier  = @"JobResultsListTableViewCell";// [NSString  stringWithFormat:@"JobResultsListTableViewCell%ld",indexPath.row];
        
        JobResultsListTableViewCell *jResultListCell =  [self.listTableView dequeueReusableCellWithIdentifier:cellIdendifier];
        if(!jResultListCell){
            jResultListCell = [[JobResultsListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdendifier frameWidth:tableView.frame.size.width];
        }
        NSDictionary *job = [self.markedJobLocationDict objectAtIndex:indexPath.row];
        BOOL savedJob = [[job objectForKey:SAVED_STATUS] boolValue] ;//[_delegate savedJob:job];
        NSLog(@"Saved : %i", savedJob);
        
        jResultListCell.selectionStyle  =  UITableViewCellSelectionStyleNone;
        [jResultListCell  setUpCellData:job];
        
       
        if (savedJob) {
            [jResultListCell.saveButton setUserInteractionEnabled:NO];
        }
        else {
            [jResultListCell.saveButton setUserInteractionEnabled:YES];
        }
        
        [jResultListCell.fullTimeButton setTag:indexPath.row];
        [jResultListCell.saveButton setTag:indexPath.row];
        [jResultListCell.viewButton setTag:indexPath.row];
//        [jResultListCell.mapDirectionButton setTag:indexPath.row];
        
        [jResultListCell.fullTimeButton  addTarget:self.delegate action:@selector(fullTimeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [jResultListCell.saveButton  addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [jResultListCell.viewButton  addTarget:self action:@selector(viewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [jResultListCell.mapDirectionButton addTarget:self action:@selector(mapDirectionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        return jResultListCell;
    }
    
    else{
        
        NSString *  cellIdendifier  = @"JobResultsListTableViewCell";// [NSString  stringWithFormat:@"JobResultsListTableViewCell%ld",indexPath.row];
        
        JobResultsListTableViewCell *        jResultListCell =  [tableView dequeueReusableCellWithIdentifier:cellIdendifier];
        if(!jResultListCell){
            jResultListCell = [[JobResultsListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdendifier frameWidth:tableView.frame.size.width];
        }
        NSDictionary *job = [_tableViewArray objectAtIndex:indexPath.row];
        BOOL savedJob = [[job objectForKey:SAVED_STATUS] boolValue] ;//[_delegate savedJob:job];
        NSLog(@"Saved : %i", savedJob);
        
        jResultListCell.selectionStyle  =  UITableViewCellSelectionStyleNone;
        [jResultListCell  setUpCellData:job];
        
        if (savedJob) {
            [jResultListCell.saveButton setUserInteractionEnabled:NO];
        }
        else {
            [jResultListCell.saveButton setUserInteractionEnabled:YES];
        }
        
        [jResultListCell.fullTimeButton setTag:indexPath.row];
        [jResultListCell.saveButton setTag:indexPath.row];
        [jResultListCell.viewButton setTag:indexPath.row];
        
        [jResultListCell.fullTimeButton  addTarget:self.delegate action:@selector(fullTimeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [jResultListCell.saveButton  addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [jResultListCell.viewButton  addTarget:self action:@selector(viewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        return jResultListCell;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}


#pragma  mark  - MAPVIEW RELATED IMPLEMENTATIONS



- (void) arrangeDisplayLocationPointsOnMapView:(GMSMapView *) mapView withJobLocations:(NSMutableArray *)jobLocations
{
    if(jobLocations.count == 0){
        NSDictionary *curentLocationInfoDict  =  [[NSUserDefaults standardUserDefaults] objectForKey:@"userLocation"];
        if (curentLocationInfoDict) {
            float centerLat = [[curentLocationInfoDict objectForKey:@"lat"] floatValue];
            float centerLng = [[curentLocationInfoDict objectForKey:@"long"] floatValue];
            
            GMSCameraPosition * camera =  [GMSCameraPosition cameraWithLatitude:centerLat
                                                                      longitude:centerLng
                                                                           zoom:11];
            mapView.myLocationEnabled = YES;
            mapView.camera  =  camera;
        }
    
//        [[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"No Locations Found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        return;
    }
    
    mapView.mapType  =  kGMSTypeNormal;
    
    //Set the user's location or search zip code location as a camera center
    float centerLat = -1, centerLng = -1;
    
    NSString *searchZipcodeString = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchZipCode"];
    if (searchZipcodeString && searchZipcodeString.length > 0
        && [(SMJobResultsVC*)_delegate typeResults] == 0) {  //Just for search
        
        /*
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:searchZipcodeString
                     completionHandler:^(NSArray* placemarks, NSError* error){
                         
                         if (!error && placemarks.count > 0) {
                             CLPlacemark* aPlacemark = [placemarks firstObject];
                             float centerLat = aPlacemark.location.coordinate.latitude;
                             float centerLng = aPlacemark.location.coordinate.longitude;
                             
                             GMSCameraPosition * camera =  [GMSCameraPosition cameraWithLatitude:centerLat
                                                                                       longitude:centerLng
                                                                                            zoom:11];
                             mapView.myLocationEnabled = YES;
                             mapView.camera  =  camera;

                         }
                     }
         ];
         
         */
        
        //Start loading
        [CircleLoaderView addToWindow];
        
        GMSPlacesClient *placesClient = [GMSPlacesClient sharedClient];
        GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
        filter.type = kGMSPlacesAutocompleteTypeFilterRegion;
        
        [placesClient autocompleteQuery:searchZipcodeString
                                  bounds:nil
                                  filter:filter
                                callback:^(NSArray *results, NSError *error) {
                                    if (error != nil) {
                                        NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                        [CircleLoaderView removeFromWindow];
                                        return;
                                    }
                                    
//                                    for (GMSAutocompletePrediction* result in results) {
//                                        NSLog(@"Result '%@' with placeID %@", result.attributedFullText.string, result.placeID);
//                                    }
                                    
                                    GMSAutocompletePrediction* firstResult = [results firstObject];
                                    
                                    [placesClient lookUpPlaceID:firstResult.placeID callback:^(GMSPlace * result, NSError * error) {
                                        if (error != nil) {
                                            NSLog(@"lookUpPlaceID error %@", [error localizedDescription]);
                                            [CircleLoaderView removeFromWindow];
                                            return;
                                        }
                                        
                                        float centerLat = result.coordinate.latitude;
                                        float centerLng = result.coordinate.longitude;
                                        GMSCameraPosition * camera =  [GMSCameraPosition cameraWithLatitude:centerLat
                                                                                                  longitude:centerLng
                                                                                                       zoom:11];
                                        mapView.myLocationEnabled = YES;
                                        mapView.camera  =  camera;
                                        
                                        [CircleLoaderView removeFromWindow];
                                    }];
                                    
                                }];
        
    }
    else {
        NSDictionary *curentLocationInfoDict  =  [[NSUserDefaults standardUserDefaults] objectForKey:@"userLocation"];
        if (curentLocationInfoDict) {
            centerLat = [[curentLocationInfoDict objectForKey:@"lat"] floatValue];
            centerLng = [[curentLocationInfoDict objectForKey:@"long"] floatValue];
        }
    }
    
    if (centerLat == -1) {
        NSDictionary *locationsDict = [jobLocations firstObject];
        centerLat  =   [[locationsDict objectForKey:@"company_lat"] floatValue];
        centerLng  =   [[locationsDict objectForKey:@"company_long"] floatValue];
    }
    
    GMSCameraPosition * camera =  [GMSCameraPosition cameraWithLatitude:centerLat
                                                              longitude:centerLng
                                                                   zoom:11];
    mapView.myLocationEnabled = YES;
    mapView.camera  =  camera;
    
    
    
    // creating markers
    GMSCoordinateBounds * bounds  =  [[GMSCoordinateBounds alloc] init];
    
    //Get the coordinates from jos locations dict
    for ( NSMutableDictionary *locationsDict in  jobLocations)
    {
        CLLocationCoordinate2D theCoordinate1;
        theCoordinate1.latitude  =   [[locationsDict objectForKey:@"company_lat"] floatValue];
        theCoordinate1.longitude  =   [[locationsDict objectForKey:@"company_long"] floatValue];
        marker  =  [GMSMarker markerWithPosition:theCoordinate1];
        marker.icon = [UIImage imageNamed:@"location"];
        marker.map = mapView;
        marker.userData = @"This is my first map view ";
        [_markersArray  addObject:marker];
        bounds = [bounds includingCoordinate:theCoordinate1];
        
         marker.userData = [locationsDict objectForKey:@"jobs"];
        
//        GMSCameraPosition * camera =  [GMSCameraPosition cameraWithLatitude:theCoordinate1.latitude longitude:theCoordinate1.longitude zoom:15];
//        mapView.myLocationEnabled = YES;
//        mapView.camera  =  camera;
    }
    
    
    mapView.delegate  = (SMJobResultsVC *)self.delegate;
}


- (void) updateSelectionForMarker:(GMSMarker *) selectedMarker{
    
    //marker.icon=[UIImage imageNamed:@"location"];//selected marker
    
    for (GMSMarker *markers in _markersArray )
    {
        
         markers.icon=[UIImage imageNamed:@"location"];//selected marker
        selectedMarker.icon=[UIImage imageNamed:@"Location_selected"];
        
        //GMSMarker *selectedMarker= _markersArray[i];
        //check selected marker and unselected marker position
//        if(selectedMarker.position.latitude==marker.position.latitude &&    selectedMarker.position.longitude==marker.position.longitude)
//        {
//            selectedMarker.icon=[UIImage imageNamed:@"mapdescription"];
//        }else
//        {
//            selectedMarker.icon=[UIImage imageNamed:@"location"];
//        }
    }
}

#pragma mark - SETUP TABLE VIEW FOR SELECTED LOCATION

- (UITableView *) setupSelectedlocationInfoView{
//    CGRect sizeRect = [UIScreen mainScreen].bounds;
    CGRect sizeRect = [(UIViewController*)self.delegate view].bounds;
    float width = sizeRect.size.width;
    float height = sizeRect.size.height;
    CGFloat tableViewHeight  = 200;
    
    locationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, height - tableViewHeight , width, tableViewHeight)];
    locationTableView.delegate  =  (SMJobResultsVC *)self.delegate;
    locationTableView.dataSource  =  (SMJobResultsVC *)self.delegate;
    locationTableView.tag  =  JOB_RESULTS_LOCATIONTABLEVIEW_TAG;
    locationTableView.backgroundColor  =  [UIColor clearColor];
    locationTableView.alpha  =  0;
    [locationTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];


    return locationTableView;
}

-(void)updateSelectedLocationInfoOfMarker:(GMSMarker *) selectedMarker{
    
    self.markedJobLocationDict = [[NSMutableArray alloc] init];
    self.markedJobLocationDict = (NSMutableArray *)selectedMarker.userData;
//    CGRect sizeRect = [UIScreen mainScreen].bounds;
    CGRect sizeRect = [(UIViewController*)self.delegate view].bounds;
    float width = sizeRect.size.width;
    float height = sizeRect.size.height;
    if (self.markedJobLocationDict.count == 1) {
        CGFloat tableViewHeight  = 170;
        [locationTableView setFrame:CGRectMake(0, height - tableViewHeight , width, tableViewHeight)];
    }else if(self.markedJobLocationDict.count > 1){
        CGFloat tableViewHeight  = 200;
        [locationTableView setFrame:CGRectMake(0, height - tableViewHeight , width, tableViewHeight)];
    }
    
    locationTableView.tag = JOB_RESULTS_LOCATIONTABLEVIEW_TAG;
    
    [locationTableView setAlpha:1];
    [locationTableView reloadData];
    [locationTableView layoutIfNeeded];
    
    [locationTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
    [self updateSelectionForMarker:selectedMarker];
}


- (UIView *) setUpPopUpViewWithParameters:(NSMutableArray *) parametersArray{
    
    float  width  =  [[UIScreen mainScreen] bounds].size.width ;
    float  height =  [[UIScreen  mainScreen]  bounds].size.height;
    float  yPos  =  10;
    float  xPos  =  10;
    float  cancelButtonWidth  =  30 ;
    float  dayLabelWidth  =  65; //  morn , even , afternoon  labels  width
    float  daylabelHeight  = 30;
    float  verticalGap  =  10;
    float  horizantalGap =  10;
    
//    NSMutableArray *  daysInfoArray  =  [[NSMutableArray alloc] initWithObjects:kMORNING,kAFTERNOON,kEVENING, nil];
    NSMutableArray *  daysInfoArray  =  [[ReusedMethods sharedObject].dropDownListDict objectForKey:@"shifts"];
    
    
    NSArray *  weekDayLabelArray  =  @[@"M", @"T", @"W", @"T", @"F", @"S",@"S"];
//    (NSArray *)kDAYSARRAY;
    
    UIView *  transperentView  =  [[UIView alloc]  initWithFrame:CGRectMake(0, 0, width, height)];
    [transperentView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    
    UIView *  BgView  =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(transperentView.frame), 280)];
    [BgView setBackgroundColor:[UIColor appWhiteColor]];
    [BgView setCenter:transperentView.center];
    
    //  prepare cancel  button
    
    UIButton * cancelButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton  setFrame:CGRectMake(width  -  cancelButtonWidth, yPos, cancelButtonWidth, cancelButtonWidth)];
    [cancelButton setBackgroundColor:[UIColor clearColor]];
    [cancelButton setImage:[UIImage  imageNamed:@"cross grey"] forState:UIControlStateNormal];
    [cancelButton addTarget:self.delegate action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [BgView addSubview:cancelButton];
    
    //  prepare  work day  preference  label
    
    UILabel  *  workDayPreferLabel  =  [[UILabel alloc]  initWithFrame:CGRectMake(xPos, CGRectGetMaxY(cancelButton.frame), width - (2 *  xPos) , 20 )];
    [workDayPreferLabel setFont: [UIFont appNormalTextFont]];
    workDayPreferLabel.textAlignment = NSTextAlignmentLeft;
    workDayPreferLabel.textColor = [UIColor appGrayColor];
    workDayPreferLabel.text  =  @"WORK  DAY  PREFERENCES";
    [BgView addSubview:workDayPreferLabel];
    
    // week days labels  (mon  to  sat)
    
    yPos  =  CGRectGetMaxY(workDayPreferLabel.frame) +  verticalGap;
    xPos  =  85;
    float  gap  =  (horizantalGap * 6); //  no  of weeks  menctioned  6  the gaps  are  5
    float  weekDayLabelWidth  = ( width - xPos - gap ) / 8;
    
    for (int  i  =  1  ; i < 8; i ++) {
        
        UILabel  *  dayLabel  =  [[UILabel alloc]  initWithFrame:CGRectMake(xPos, yPos, weekDayLabelWidth   , weekDayLabelWidth)];
        [dayLabel setFont: [UIFont appNormalTextFont]];
        dayLabel.backgroundColor  =  [UIColor clearColor];
        dayLabel.textAlignment = NSTextAlignmentLeft;
        dayLabel.textColor = [UIColor appGrayColor];
        dayLabel.text  =  [weekDayLabelArray objectAtIndex:(i - 1)];
        dayLabel.textColor  =  (i  ==  7) ? [UIColor appPinkColor] :[UIColor appGrayColor];
        dayLabel.textAlignment  =  NSTextAlignmentCenter;
        [BgView addSubview:dayLabel];
        
        xPos  += (weekDayLabelWidth + horizantalGap );
        
    }
    
    //  day  timings  labels  ( morning  to  evening)
    
    yPos  +=   weekDayLabelWidth + verticalGap;
    float daylabelYPos  =  yPos;
    
    
    for (NSDictionary *shift in daysInfoArray) {
        
        UILabel  *  dayLabel  =  [[UILabel alloc]  initWithFrame:CGRectMake(horizantalGap * 2, daylabelYPos, dayLabelWidth   , daylabelHeight)];
        [dayLabel setFont: [UIFont appLatoLightFont10]];
        dayLabel.textAlignment = NSTextAlignmentLeft;
        dayLabel.textColor = [UIColor appGrayColor];
        dayLabel.text  =  [NSString stringWithFormat:@"%@ \n(%@)", [shift objectForKey:@"Shift_name"], [shift objectForKey:@"shift_timings"]].uppercaseString;
        dayLabel.numberOfLines  =  0;
        dayLabel.lineBreakMode  =  NSLineBreakByWordWrapping;
        
        [BgView addSubview:dayLabel];
        
        daylabelYPos  +=   daylabelHeight + (verticalGap * 2)  ;
        
    }
    
    //  working day preferences  button
    
    
    
//    NSArray *  arr = @[@11,@12, @13, @14, @15, @16, @21,@22, @23,@24,@31,@36,@33];// @25, @26, @31,@32,@33, @34, @35, @36];
//    
//    [parametersArray addObjectsFromArray: arr]; //  this  is  temporaray  purpose
//    //  buttons
//    
    xPos  =  85;
    
    weekDayLabelArray  =  KWEEKDAYSARRAY;
    
    for (NSDictionary *shift in daysInfoArray) {
        NSInteger index = [daysInfoArray indexOfObject:shift] + 1;
        NSString *predicateString = [NSString stringWithFormat:@"shiftID = %@", [shift objectForKey:@"shift_id"]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
        NSArray *array = [parametersArray filteredArrayUsingPredicate:predicate];
        
        NSDictionary *dictSh = [array firstObject];
        NSArray *days = [dictSh objectForKey:@"days"];
        
        for (NSString *string in weekDayLabelArray) {
            
//            NSString *tagString  = [NSString stringWithFormat:@"%d%d",i,j];
//            NSInteger  tagInteger  =  [tagString  integerValue];
            
            UIButton *  workDayButton  =  [UIButton buttonWithType:UIButtonTypeCustom];
            [workDayButton  setFrame:CGRectMake(xPos, yPos, weekDayLabelWidth, weekDayLabelWidth)];
            [workDayButton setImage:[UIImage  imageNamed:@"unsel"] forState:UIControlStateNormal];
//            [workDayButton  setTag:tagInteger];
            [workDayButton  setUserInteractionEnabled:NO];
            [BgView addSubview:workDayButton];
            
            xPos  += (weekDayLabelWidth + horizantalGap );
            if([days containsObject: string]){
                
//            }
//            if([parametersArray  containsObject:[NSNumber numberWithInteger:tagInteger]]){
            
                
                switch (index) {
                    case 1:
                        
                        [workDayButton setImage:[UIImage imageNamed:@"sel1"] forState:UIControlStateNormal];
                        break;
                        
                    case 2:
                        
                        [workDayButton setImage:[UIImage imageNamed:@"sel2"] forState:UIControlStateNormal];
                        break;
                        
                    case 3:
                        
                        [workDayButton setImage:[UIImage imageNamed:@"sel3"] forState:UIControlStateNormal];
                        break;
                        
                    default:
                        break;
                }
            
            }
            else{
                [workDayButton setImage:[UIImage  imageNamed:@"unsel"] forState:UIControlStateNormal];
            }
        }
        xPos  =  85;
        yPos  +=   daylabelHeight + (verticalGap * 2)  ;
    }
//
    [transperentView addSubview:BgView];
    
    return transperentView;
}

- (void) saveButtonAction:(UIButton *)sender{
    _saveButton = sender;
    NSDictionary *dictJob;
    if (_selectedTableView.tag == JOB_RESULTS_LOCATIONTABLEVIEW_TAG) {
        dictJob = [self.markedJobLocationDict objectAtIndex:sender.tag];
    }else{
        dictJob = [_tableViewArray objectAtIndex:sender.tag];
    }
//    [self.delegate saveButtonAction:[dictJob objectForKey:@"job_id"]];
    currentSavedJob  = [dictJob mutableCopy];
    
    APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_SAVE ModuleName:MODULE_JOBS MethodType:METHOD_TYPE_POST Parameters:[NSMutableDictionary dictionaryWithObject:[dictJob objectForKey:@"job_id"] forKey:@"jobID"] SuccessCallBack:@selector(saveApiCallSuccess:) AndFailureCallBack:@selector(saveApiCallFailed:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
    [service makeWebServiceCall];
}

- (void)viewButtonAction:(UIButton *)sender{
    if (_selectedTableView.tag == JOB_RESULTS_LOCATIONTABLEVIEW_TAG) {
        NSDictionary *dictJob = [self.markedJobLocationDict objectAtIndex:sender.tag];
        [self getJobDetails:[dictJob objectForKey:@"job_id"]];
    }else{
        NSDictionary *dictJob = [_tableViewArray objectAtIndex:sender.tag];
        [self getJobDetails:[dictJob objectForKey:@"job_id"]];
    }
//    [[ReusedMethods sharedObject] setJobID:(NSInteger)[dictJob objectForKey:@"job_id"]];
}

- (void)mapDirectionButtonAction:(UIButton *)sender{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
    if(reachability.currentReachabilityStatus != NotReachable){
        [self.delegate mapDirectionButtonAction:sender];
    }
    else{
        [[[RBACustomAlert alloc] initWithTitle:@"No Internet" message:@"Please check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    }
}

- (void) saveApiCallSuccess:(WebServiceCalls *)server{
    if([[server.responseData objectForKey:@"success"] isEqualToString:UNSAVED_MESSAGE_FLAG]){
        [_saveButton setUserInteractionEnabled:YES];
        [_saveButton setSelected:NO];
    }else{
        [_saveButton setUserInteractionEnabled:NO];
        [_saveButton setSelected:YES];
        [self updateSaveStatusInObjectsArrayForJob];
    }
    [[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:[server.responseData objectForKey:@"success"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

- (void) saveApiCallFailed:(WebServiceCalls *)server{
    
    [[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:[server.responseData objectForKey:@"error"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

- (void) updateSaveStatusInObjectsArrayForJob{
    [currentSavedJob setObject:[NSNumber numberWithBool:1] forKey:SAVED_STATUS];
    NSNumber *  jobID  =  [currentSavedJob objectForKey:@"job_id"];
    NSPredicate * predicate  =  [NSPredicate predicateWithFormat:@("job_id == %@"),jobID];
    NSDictionary *  dict  = [[_tableViewArray filteredArrayUsingPredicate:predicate] firstObject];
    NSInteger  index  =   [_tableViewArray indexOfObject:dict];
    [_tableViewArray replaceObjectAtIndex:index withObject:currentSavedJob];
    
    
}

#pragma mark - Getting Job Details

- (void) getJobDetails:(id) jobID{
    APIObject * reqObject = [[APIObject alloc] initWithMethodName:[NSString stringWithFormat:@"%@/%@", METHOD_DETAILS, jobID] ModuleName:MODULE_JOBS MethodType:METHOD_TYPE_POST Parameters:nil SuccessCallBack:@selector(apiCallSuccess:) AndFailureCallBack:@selector(apiCallFailed:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
    [service makeWebServiceCall];
}

- (void) apiCallSuccess:(WebServiceCalls *) service{
    NSDictionary *jobDetails = nil;
    if([service.responseData isKindOfClass:[NSArray class]])
        jobDetails = [service.responseData firstObject];
    else
        jobDetails = service.responseData;
    //    NSDictionary *jobDict = service.responseData;
//    [self.delegate updateUI];
    [self.delegate viewButtonAction:jobDetails];
    //    NSLog(@"Response Data : %@", service.responseData);
}

- (void) apiCallFailed:(WebServiceCalls *) service{
    
}

#pragma - path display 

- (void)drawRouteOnView:(GMSMapView *) mapView withButton:(UIButton *)sender
{
    NSDictionary  * selectedobjectDict =  [self.markedJobLocationDict objectAtIndex:sender.tag];
    
    CLLocationCoordinate2D destinationCoordinate, sourceCoordinate;
    destinationCoordinate.latitude  =   [[selectedobjectDict objectForKey:@"company_lat"] floatValue];
    destinationCoordinate.longitude  =   [[selectedobjectDict objectForKey:@"company_long"] floatValue];
    NSDictionary *  curentLocationInfoDict  =  [[NSUserDefaults standardUserDefaults] objectForKey:@"userLocation"];
    sourceCoordinate.latitude  =  [[curentLocationInfoDict objectForKey:@"lat"] floatValue] ;
    sourceCoordinate.longitude = [[curentLocationInfoDict objectForKey:@"long"] floatValue] ;
    
    GMSCameraPosition * camera =  [GMSCameraPosition cameraWithLatitude:destinationCoordinate.latitude longitude:destinationCoordinate.longitude zoom:15];
    mapView.myLocationEnabled = YES;
    mapView.camera  =  camera;
    
    [self fetchPolylineWithOrigin:sourceCoordinate destination:destinationCoordinate forMapViw:mapView completionHandler:^(GMSPolyline *polyline)
     {
         if(polyline)
             polyline.map = mapView;
     }];
}


- (void)fetchPolylineWithOrigin:(CLLocationCoordinate2D)origin destination:(CLLocationCoordinate2D)destination forMapViw:(GMSMapView *)mapView completionHandler:(void (^)(GMSPolyline *))completionHandler
{
    NSString *originString = [NSString stringWithFormat:@"%f,%f", origin.latitude, origin.longitude];
    NSString *destinationString = [NSString stringWithFormat:@"%f,%f", destination.latitude, destination.longitude];
    NSString *directionsAPI = @"https://maps.googleapis.com/maps/api/directions/json?";
    NSString *directionsUrlString = [NSString stringWithFormat:@"%@&origin=%@&destination=%@&mode=driving", directionsAPI, originString, destinationString];
    NSURL *directionsUrl = [NSURL URLWithString:directionsUrlString];
    
    
    NSURLSessionDataTask *fetchDirectionsTask = [[NSURLSession sharedSession] dataTaskWithURL:directionsUrl completionHandler:
                                                 ^(NSData *data, NSURLResponse *response, NSError *error)
                                                 {
                                                     NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                     if(error)
                                                     {
                                                         if(completionHandler)
                                                             completionHandler(nil);
                                                         return;
                                                     }
                                                     
                                                     NSArray *routesArray = [json objectForKey:@"routes"];
                                                     
                                                     GMSPolyline *polyline = nil;
                                                     if ([routesArray count] > 0)
                                                     {
                                                         NSDictionary *routeDict = [routesArray objectAtIndex:0];
                                                         NSDictionary *routeOverviewPolyline = [routeDict objectForKey:@"overview_polyline"];
                                                         NSString *points = [routeOverviewPolyline objectForKey:@"points"];
                                                         mapPoints  = points;
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             //[self performSegueWithIdentifier:@"loadMap" sender:self];
                                                             
                                                             [self performSelector:@selector(loadMapView:) withObject:mapView];
                                                         });
                                                         
                                                         
                                                         
                                                     }
                                                     
                                                     if(completionHandler)
                                                         completionHandler(polyline);
                                                 }];
    [fetchDirectionsTask resume];
}

- (void) loadMapView:(GMSMapView *) mapView{
    GMSPolyline * polyline;
    GMSPath *path = [GMSPath pathFromEncodedPath:mapPoints];
    polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeColor = [UIColor appGrayColor];
    polyline.strokeWidth = 2.0f;
    [polyLinesArray addObject:polyline];
    polyline.map = mapView;
}
- (void) removePolyLine{
    
    
    for (GMSPolyline *  polyLine  in  polyLinesArray) {
        polyLine.map = nil;
    }
    
    //[mapView clear];
    
}

- (void)  updateLocationTableViewHeightWithContent:(float)  actualHeight{
    
    CGRect sizeRect = [UIScreen mainScreen].bounds;
    float width = sizeRect.size.width;
    float height = sizeRect.size.height;
    
    [locationTableView setFrame:CGRectMake(0, height - actualHeight , width, actualHeight)];
    [locationTableView setContentInset:UIEdgeInsetsZero];
}


@end
