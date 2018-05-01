//
//  SMHelpScreenModel.m
//  SwissMonkey
//
//  Created by Kasturi on 07/01/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "SMHelpScreenModel.h"

@implementation SMHelpScreenModel
@synthesize helpScreensArray;

- (id) init{
    
    if(self){
        
        self  =  [super init];
        helpScreensArray  =  [[NSMutableArray  alloc]  initWithObjects:[UIImage imageNamed:@"splashscreen1"],[UIImage imageNamed:@"splashscreen1"],[UIImage imageNamed:@"splashscreen1"], nil];
    }
    return self;
}

- (void)  addSwipeGesturesOnView:(UIView *) view onTargetVC:(id) vc{
    
    UISwipeGestureRecognizer *swipeLeftToRight = [[UISwipeGestureRecognizer alloc] initWithTarget:vc action:@selector(swipePreviousAction:)];
    [swipeLeftToRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [view addGestureRecognizer:swipeLeftToRight];
    UISwipeGestureRecognizer *swipeRightToLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:vc action:@selector(swipeNextAction:)];
    [swipeRightToLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [view addGestureRecognizer:swipeRightToLeft];

}


-(void)swipeAnimationExpandableImageView:(NSString *)leftRight forLayer:(CALayer *) layer
{
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self.delegate];
    [animation setDuration:0.5f];
    [animation setType:kCATransitionPush];
    animation.subtype = leftRight;
    [layer addAnimation:animation forKey:NULL];
}


- (UIImage *)  getImageForIndex:(int) photoIndex{
    
    return [helpScreensArray  objectAtIndex:photoIndex];
}



@end
