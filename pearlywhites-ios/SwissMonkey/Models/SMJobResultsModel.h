//
//  SMJobResultsModel.h
//  SwissMonkey
//
//  Created by Kasturi on 24/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMJobResultsModelDelegate<NSObject>

- (void) fullTimeButtonAction:(UIButton *) sender;
- (void) saveButtonAction:(id) jobID;
- (void)mapDirectionButtonAction:(UIButton *)sender;
- (void) viewButtonAction:(NSDictionary *) jobID;
- (void) cancelButtonAction:(UIButton *)sender;
- (BOOL) savedJob:(NSDictionary *)job;

@end
@interface SMJobResultsModel : NSObject

@property  (nonatomic, retain) id<SMJobResultsModelDelegate> delegate;
@property  (nonatomic, strong) NSMutableArray *tableViewArray;
@property  (nonatomic, strong)NSMutableArray *markersArray;
//@property  (nonatomic, strong)NSMutableDictionary *markedJobLocationDict;
@property  (nonatomic, strong)NSMutableArray *markedJobLocationDict;
@property  (nonatomic, strong) UITableView * locationTableView;
@property  (nonatomic, strong) UITableView *selectedTableView;
@property  (nonatomic, strong) UITableView *listTableView;

@property  (nonatomic, assign) UIButton *saveButton;

#pragma mark - TABLE VIEW DELEGATE METHODS

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIView *) setUpPopUpViewWithParameters:(NSMutableArray *) paraetersArray;
- (void) arrangeDisplayLocationPointsOnMapView:(GMSMapView *) mapView;
- (void) arrangeDisplayLocationPointsOnMapView:(GMSMapView *) mapView withJobLocations:(NSMutableArray *)jobLocations;
- (UITableView *) setupSelectedlocationInfoView;
-(void)updateSelectedLocationInfoOfMarker:(GMSMarker *) selectedMarker;
- (void) removePolyLine;
- (void)drawRouteOnView:(GMSMapView *) mapView withButton:(UIButton *)sender;
@end
