//
//  SMUserPicturesVideosDisplayVC.h
//  SwissMonkey
//
//  Created by Kasturi on 3/1/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMUserPicturesVideosDisplayVC : UIViewController<UIWebViewDelegate>
{
     UIWebView *  videoWebView;
}
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, retain) NSString *  selectedVideoString;

@end
