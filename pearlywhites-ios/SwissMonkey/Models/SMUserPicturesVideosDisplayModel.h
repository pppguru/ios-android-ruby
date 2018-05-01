//
//  SMUserPicturesVideosDisplayModel.h
//  SwissMonkey
//
//  Created by Kasturi on 3/1/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMUserPicturesVideosDisplayModelDelegate <NSObject>

- (void) successResponseCall:(WebServiceCalls *) service;
- (void) showErrorMessages:(NSString *) error;
@end
@interface SMUserPicturesVideosDisplayModel : NSObject{
    UIView * expandableView;
    UIImageView * expandableImageView;
    UIButton * leftButton,*rightButton;
    int photoIndex;
}
@property  (nonatomic , retain)  id <SMUserPicturesVideosDisplayModelDelegate> delegate;
@property (nonatomic,  retain)  NSArray * profileImagesArray;
@property (nonatomic,  retain)  NSArray * profileVideosArray;

-(void)createExpandableView;
-(void)addExapandableViewOnView:(UIView *) selfView;
@end
