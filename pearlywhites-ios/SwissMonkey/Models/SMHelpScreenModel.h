//
//  SMHelpScreenModel.h
//  SwissMonkey
//
//  Created by Kasturi on 07/01/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMHelpScreenModelDelegate<NSObject>

@end


@interface SMHelpScreenModel : NSObject

@property  (nonatomic, retain) id<SMHelpScreenModelDelegate> delegate;
@property  (nonatomic , retain)  NSMutableArray *  helpScreensArray;

- (void)  addSwipeGesturesOnView:(UIView *) view onTargetVC:(id) vc;
- (void)swipeAnimationExpandableImageView:(NSString *)leftRight forLayer:(CALayer *) layer;
- (UIImage *) getImageForIndex:(int) photoIndex;



@end
