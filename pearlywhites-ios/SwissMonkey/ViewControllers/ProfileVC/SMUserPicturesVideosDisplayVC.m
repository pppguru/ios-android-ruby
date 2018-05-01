//
//  SMUserPicturesVideosDisplayVC.m
//  SwissMonkey
//
//  Created by Kasturi on 3/1/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "SMUserPicturesVideosDisplayVC.h"

@interface SMUserPicturesVideosDisplayVC ()

@end

@implementation SMUserPicturesVideosDisplayVC

- (void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // set  up navigation  view
    
    [ReusedMethods setNavigationViewOnView:self.view WithTitle:@"Videos" andBackgroundColor:[UIColor whiteColor]];
    [ReusedMethods setUpLeftButton:self withImageName:@"back"];
   // [ReusedMethods setUpRightButton:self withImageName:@"ProfileEdit" withNotificationsCount:0];
    [self setUpWebViewForDisplayingVideosonView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  - BUTTON ACTIONS 

- (IBAction)navViewRightButtonAction:(id)sender{
    
  //  edit  functionality.
    
}
- (IBAction)navViewLeftButtonAction:(id)sender{
   
    // dissmiss
    [self  dismissViewControllerAnimated:YES completion:nil];
}

#pragma  mark  -  DISPLAYING VIDEOS RELATED METHODS

- (void) setUpWebViewForDisplayingVideosonView:(UIView *) selfView{
    
    NSArray *arrayVedios = [SMSharedFilesClass allFilesAtPath:[SMSharedFilesClass profileVideosPath]];
    if(![arrayVedios count])
        arrayVedios = [SMSharedFilesClass allFilesAtPath:[SMSharedFilesClass profileTempVideosPath]];
    
    
    NSString * path = [SMSharedFilesClass profileVideosPath];
    NSArray * objects = [SMSharedFilesClass allFilesAtPath:path];
    if(![objects count]){
        path = [SMSharedFilesClass profileTempVideosPath];
        objects = [SMSharedFilesClass allFilesAtPath:path];
    }
    
    NSString * filepath = [path stringByAppendingPathComponent:self.selectedVideoString];
//    NSURL * url  =  [NSURL fileURLWithPath:filepath];

    //Playing the video from the URL..
    NSURL * url  =  [NSURL URLWithString:self.selectedVideoString];
    
//    UIWebView *  webView  =  [[UIWebView alloc]  initWithFrame:CGRectMake(0, NAVIGATION_HEIGHT, CGRectGetWidth(selfView.frame), CGRectGetHeight(selfView.frame)  -  (2 * NAVIGATION_HEIGHT))];
//    webView.delegate  =  self;
//    [webView loadRequest:[NSURLRequest requestWithURL:url]];
//    [selfView addSubview:webView];
    
    float navHeight  =  NAVIGATION_HEIGHT;
    float  xPos  =  0;
    float  yPos  =  navHeight;
    
    float  width  =   CGRectGetWidth(self.view.frame);
    float height  =  CGRectGetHeight(self.view.frame) - navHeight;
    
    videoWebView  =   [[UIWebView alloc]initWithFrame:CGRectMake(xPos, yPos, width, height)];
    videoWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [videoWebView  setDelegate:self];
    [selfView addSubview:videoWebView];
   
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
    if(reachability.currentReachabilityStatus != NotReachable){
        [videoWebView loadRequest:[NSURLRequest requestWithURL:url]];
    }else{
        if(![ReusedMethods sharedObject].noInternetAlert){
            [ReusedMethods sharedObject].noInternetAlert = [[RBACustomAlert alloc] initWithTitle:@"No Internet" message:@"Please check your internet connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [ReusedMethods sharedObject].noInternetAlert.tag  = NOINTERNET_CONNECTION_ALERT_TAG;
        }
        [[ReusedMethods sharedObject].noInternetAlert show];
        //[[[RBACustomAlert alloc] initWithTitle:@"No Internet" message:@"Please check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    }

}

- (void) alertView:(RBACustomAlert *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag  == NOINTERNET_CONNECTION_ALERT_TAG){
        [ReusedMethods sharedObject].noInternetAlert  = nil;
    }
    
}



#pragma  mark  - WEB VIEW DELEGATE METHODS
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if(error.code != 204){
        RBACustomAlert * alert =  [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"Something went wrong" delegate:nil cancelButtonTitle:@"Ok "otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark -  IMAGES DISPLAY METHODS




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
