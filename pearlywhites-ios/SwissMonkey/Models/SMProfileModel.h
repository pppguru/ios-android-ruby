//
//  SMProfileModel.h
//  SwissMonkey
//
//  Created by Kasturi on 05/01/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMProfileModelDelegate <NSObject>

@optional
- (void) showErrorMessages:(NSString *) error;
- (void) successResponseCall:(NSDictionary *)profileInfo;

- (void)deleteSelectedImage;
- (void)displaySelectedVideo:(id) selectedVideo;
- (void)deleteSelectedVideo;

@end

@interface SMProfileModel : NSObject

@property  (nonatomic, retain)  id<SMProfileModelDelegate> delegate;
@property  (nonatomic, retain)  NSArray *  profileImagesArray , * profileVideosArray;
@property  (nonatomic, retain) NSIndexPath * selectedDeleteObjectIndexPath;

-(void) callProfileDataAPICall;

- (TYMProgressBarView *) getProgressbarViewwithFrame;

#pragma mark  -  THUMBNAILS DISPLAY METHODS

- (void)setUPThumbNailsOnView:(UIView *)bgView ofCount:(int) count;
- (void) displayThumbNailsImagesOnView:(UIView *) BGView;
- (void) createExpandableView;

@end
