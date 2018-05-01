//
//  WebServiceCalls.m
//  SwissMonkey
//
//  Created by Kasturi on 23/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import "WebServiceCalls.h"
#import "CircleLoaderView.h"
#import "ASIFormDataRequest.h"
#import "AFHTTPClient.h"
#import <AFNetworking/AFNetworking.h>

@implementation APIObject

@synthesize methodName, methodType,parameters,moduleName;

-(id)initWithMethodName:(NSString *)_methodName ModuleName:(NSString *)_moduleName MethodType:(NSString *)_methodType Parameters:(NSMutableDictionary *)_parameters SuccessCallBack:(SEL)success AndFailureCallBack:(SEL)failure
{
    if (self == nil)
    {
        self = [[APIObject alloc] init];
    }
    self.methodName = _methodName;
    self.moduleName = _moduleName;
    self.methodType = _methodType;
    self.parameters = _parameters;
    self.success = success;
    self.failure = failure;
    return self;
}

@end

@implementation WebServiceCalls
@synthesize requestObject;
@synthesize delegate,responseData,responseError,isLoaderHidden, noLoader;
//-(void)stest
//{
//    [(id)self.delegate performSelector:requestObject.success withObject:self];
//}

-(id)initWebServiceCallWithAPIRequest:(APIObject *)apiObject withDelegate:(id)delegateObj
{
    if (self == nil)
    {
        self = [[WebServiceCalls alloc] init];
    }
    self.requestObject = apiObject;
    self.delegate = delegateObj;
    return self;
}

-(void)makeWebServiceCall
{
    if (!isLoaderHidden) {
        if(![requestObject.methodName isEqualToString:METHOD_DEVICE_REGISTRATION])
            if(!noLoader)
                [CircleLoaderView addToWindowWithCircleColor:[UIColor appGreenColor] arcColor:[UIColor appWhiteColor]];
    }
    [self performSelector:@selector(sendAPICall) withObject:nil afterDelay:k_SERVER_CALL_DELAY];
}

- (void) sendAPICall{
    
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
    if(reachability.currentReachabilityStatus != NotReachable){
        
        NSMutableURLRequest * urlRequest = [self prepareURLRequestObject];
        urlRequest.timeoutInterval = 300;
        [NSURLConnection sendAsynchronousRequest:urlRequest
                                           queue:[ NSOperationQueue mainQueue ]
                               completionHandler:^( NSURLResponse *response, NSData *data, NSError *connectionError ) {
                                   NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                   //if(!([requestObject.methodName isEqualToString:METHOD_DEVICE_REGISTRATION] || [requestObject.methodName isEqualToString:METHOD_UPLOAD] || (self.mediaType == pictureType && [requestObject.methodName isEqualToString:METHOD_DELETE] )))
                                   //    [CircleLoaderView removeFromWindow];
                                   
                                   if(!([requestObject.methodName isEqualToString:METHOD_DEVICE_REGISTRATION]
                                        || [requestObject.methodName isEqualToString:METHOD_UPLOAD]
                                        || (self.mediaType == pictureType && [requestObject.methodName isEqualToString:METHOD_DELETE] )
                                        || [requestObject.methodName isEqualToString:METHOD_GET_TandC_STATUS]))
                                       [self removeLoader];
//                                       [self performSelector:@selector(removeLoader) withObject:nil afterDelay:3];
                                   
                                   NSLog(@"Response Status Code : %ld: %@", (long)httpResponse.statusCode,connectionError.localizedDescription);
                                   if(httpResponse.statusCode == 0 || httpResponse.statusCode == 404){
                                       [[[RBACustomAlert alloc] initWithTitle:@"Unable to connect to Server" message:@"Do you want to try again?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Try again", nil] show];
                                   }
                                   else if(httpResponse.statusCode == 500){
                                       [[[RBACustomAlert alloc] initWithTitle:@"Swiss Monkey" message:[NSString stringWithFormat:@"Error occured while connecting to the server \nstatus code : %ld", httpResponse.statusCode] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                                   }
                                   else if(httpResponse.statusCode == 501){
                                       RBACustomAlert *updateAlert = [[RBACustomAlert alloc] initWithTitle:@"Swiss Monkey" message:[NSString stringWithFormat:@"A required update is available in the App Store. Please update from the App Store to continue using the application with improved features."] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                       [updateAlert setTag:VERSION_UPDATE_ALERT_TAG];
                                       [updateAlert show];
                                   }
                                   else if(httpResponse.statusCode == 502){
                                       self.responseData = [ReusedMethods cleanJsonToObject:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]];
                                       
                                       NSLog(@"MediaType : %u\nResponse Body : %@", self.mediaType, self.responseData);
                                       NSString * blockString  =  @"Your account has been blocked by super admin";
                                       if([self.responseData isKindOfClass:[NSDictionary class]] && [[self.responseData objectForKey:@"success"] isEqualToString:blockString]){
                                           BOOL isAlertPresent = NO;
                                           UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
                                           for (UIAlertView *alertV in [window subviews]) {
                                               if ([alertV isKindOfClass:[RBACustomAlert class]]) {
                                                   if (alertV.tag == USER_BLOCKED) {
                                                       isAlertPresent = YES;
                                                   }
                                               }
                                           }
                                           if (isAlertPresent == NO) {
                                               RBACustomAlert * alert =[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"Your account has been blocked by admin" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                               [alert setTag:USER_BLOCKED];
                                               [alert show];
                                           }
                                       }
                                   }
                                   //                                   else if (httpResponse.statusCode == 400)
                                   //                                   {
                                   //                                       self.responseError =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   //                                       NSLog(@"Response Body : %@", self.responseData);
                                   //                                       [(id)self.delegate performSelectorOnMainThread:requestObject.failure withObject:self waitUntilDone:YES];
                                   //                                   }
                                   else if (connectionError || httpResponse.statusCode != 200)
                                   {
                                       self.responseError = connectionError;
                                       // self.responseData = [ReusedMethods removeNullsInDict:[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]] ];
                                       self.responseData = [ReusedMethods cleanJsonToObject:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]];
                                       
                                       NSLog(@"Response Error : %@", self.responseError);
                                       NSLog(@"Response Body : %@", self.responseData);
                                       [(id)self.delegate performSelectorOnMainThread:requestObject.failure withObject:self waitUntilDone:YES];
                                   }
                                   else
                                   {
                                       
                                       NSDictionary  *  dict  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                       //                                       self.responseData = [ReusedMethods removeNullsInDict:[[NSMutableDictionary alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]] ];
                                       self.responseData = [ReusedMethods cleanJsonToObject:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]];
                                       
                                       NSLog(@"MediaType : %u\nResponse Body : %@", self.mediaType, self.responseData);
                                       NSString * blockString  =  @"User Blocked";
                                       if([self.responseData isKindOfClass:[NSDictionary class]] && [[self.responseData objectForKey:@"UserBlockedStatus"] isEqualToString:blockString]){
                                           BOOL isAlertPresent = NO;
                                           UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
                                           for (UIAlertView *alertV in [window subviews]) {
                                               if ([alertV isKindOfClass:[RBACustomAlert class]]) {
                                                   if (alertV.tag == USER_BLOCKED) {
                                                       isAlertPresent = YES;
                                                   }
                                               }
                                           }
                                           if (isAlertPresent == NO) {
                                               RBACustomAlert * alert =[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"Your account has been blocked by admin" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                               [alert setTag:USER_BLOCKED];
                                               [alert show];
                                           }
                                       }
                                       if(self.mediaType){
                                           //                                           UIImage *image = [UIImage imageWithData:data];
                                           //                                           if([image isKindOfClass:[UIImage class]])
                                           //                                           self.content = data;
                                           //                                           NSLog(@"%@", [image class]);
                                           // [self downloadFileFromURL:[self.responseData objectForKey:@"url"]];
                                       }
                                       else
                                       {
                                           [(id)self.delegate performSelectorOnMainThread:requestObject.success withObject:self waitUntilDone:YES];
                                       }
                                   }
                                   
                               }];
    }
    else{
        [self removeLoader];
        if(![ReusedMethods sharedObject].noInternetAlert){
            [ReusedMethods sharedObject].noInternetAlert = [[RBACustomAlert alloc] initWithTitle:@"No Internet" message:@"Please check your internet connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [ReusedMethods sharedObject].noInternetAlert.tag  = NOINTERNET_CONNECTION_ALERT_TAG;
        }
        [[ReusedMethods sharedObject].noInternetAlert show];
        //[[[RBACustomAlert alloc] initWithTitle:@"No Internet" message:@"Please check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    }
}

- (void) downloadFileFromURL:(NSString *) url{
    // Start the activity indicator before moving off the main thread
    //    [self.activityIndicator startAnimating];
    // Move off the main thread to start our blocking tasks.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Create the image URL from a known string.
        NSURL *imageURL = [NSURL URLWithString:url];
        
        NSError *downloadError = nil;
        // Create an NSData object from the contents of the given URL.
        self.content = [NSData dataWithContentsOfURL:imageURL options:kNilOptions error:&downloadError];
        // ALWAYS utilize the error parameter!
        if (downloadError) {
            // Something went wrong downloading the image. Figure out what went wrong and handle the error.
            // Don't forget to return to the main thread if you plan on doing UI updates here as well.
            dispatch_async(dispatch_get_main_queue(), ^{
                //                [self.activityIndicator stopAnimating];
                NSLog(@"%@",[downloadError localizedDescription]);
            });
        } else {
            [(id)self.delegate performSelectorOnMainThread:requestObject.success withObject:self waitUntilDone:YES];
        }
    });
}

- (void) addAuthTokenIfItsRequired
{
    if(!(k_NONEEDAUTHKEY(requestObject.methodName) || [requestObject.methodType isEqual:METHOD_TYPE_GET])){
        if(!requestObject.parameters)
            requestObject.parameters = [[NSMutableDictionary alloc] init];
        
        //        NSString *authToken = [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULTS_AUTHTKEN];
        //        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *authToken = [ReusedMethods authToken];
        
        if(authToken)
            [requestObject.parameters setObject:authToken forKey:USER_DEFAULTS_AUTHTKEN];
        else{
            NSLog(@"ERROR : Auth Token is Missing");
            [[[RBACustomAlert alloc] initWithTitle:@"Auth Token is Missed" message:@"Do you want to try again?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Try again", nil] show];
            return;
        }
    }
    
}

-(NSMutableURLRequest *)prepareURLRequestObject
{
    NSURL *url = [NSURL URLWithString:[self prepareURLString]];
    
    [self addAuthTokenIfItsRequired];
    
    // NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    //NSString * build = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:requestObject.methodType];
    //    [request addValue:@"username" forHTTPHeaderField:@"X-Parse-Application-Id"];
    //    [request addValue:@"password" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request addValue:@"4.0" forHTTPHeaderField:@"version"];
    //    [request addValue:version forHTTPHeaderField:@"version"];
    
    NSError * error ;
    NSData * postDictData;
    
    if(requestObject.parameters){
        postDictData = [NSJSONSerialization dataWithJSONObject:requestObject.parameters options:NSJSONWritingPrettyPrinted error:&error];
        NSLog(@"Request Body : %@", requestObject.parameters);
    }
    
    if ([requestObject.methodType isEqualToString:METHOD_TYPE_POST] || [requestObject.methodType isEqualToString:METHOD_TYPE_PUT])
    {
        [request setHTTPBody:postDictData];
    }
    return request;
}

-(NSString *)prepareURLString
{
    NSString * urlString = [NSString stringWithFormat:@"%@/%@/%@",BASEURL,requestObject.moduleName,requestObject.methodName];
    NSLog(@"Request URL : %@", urlString);
    return urlString;
}

- (void) alertView:(RBACustomAlert *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex  ==  [alertView cancelButtonIndex] && alertView.tag == USER_BLOCKED) {
        [ReusedMethods logout];
    }
    if(buttonIndex == 1){
        [self makeWebServiceCall];
    }
    if(alertView.tag  == NOINTERNET_CONNECTION_ALERT_TAG){
        [ReusedMethods sharedObject].noInternetAlert  = nil;
    }
    if (alertView.tag == VERSION_UPDATE_ALERT_TAG && buttonIndex  ==  [alertView cancelButtonIndex]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/swiss-monkey/id1089425152?ls=1&mt=8"]];
    }
    
}

- (NSString *) prepareProfileSavingURLString
{
    NSString * urlString = [NSString stringWithFormat:@"%@/%@/%@",BASEURL, MODULE_PROFILE, METHOD_UPLOAD];
    return urlString;
}

- (NSString *) prepareProfileSavingURLStringWithoutUpload
{
    NSString * urlString = [NSString stringWithFormat:@"%@/%@/",BASEURL, MODULE_PROFILE];
    return urlString;
}

//+ (void) saveProfileFiles{
//    WebServiceCalls *serverCall = [[WebServiceCalls alloc] init];
//    [serverCall makeServerCallForFiles];
//}

- (void) makeServerCallForFiles:(id <ASIHTTPRequestDelegate>) requestDelegate{
    //    NSString *authToken = [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULTS_AUTHTKEN];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *authToken = [ReusedMethods authToken];
    //[self addLoader];
    if(authToken)
        [requestObject.parameters setObject:authToken forKey:USER_DEFAULTS_AUTHTKEN];
    else{
        NSLog(@"ERROR : Auth Token is Missing");
        [[[RBACustomAlert alloc] initWithTitle:@"Auth Token is Missed" message:@"Do you want to try again?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Try again", nil] show];
        return;
    }
    
    NSString * urlString = [self prepareProfileSavingURLString];
    NSLog(@"Request URL %@", urlString);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setDelegate:requestDelegate];
    
    [request addRequestHeader:USER_DEFAULTS_AUTHTKEN value:authToken];
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request setPostValue:authToken forKey:USER_DEFAULTS_AUTHTKEN];
    NSString *keyType = [SMSharedFilesClass keyForMedia:_mediaType];
    [request addPostValue:keyType forKey:@"type"];
    //    NSMutableArray *arrayImages = [ReusedMethods profileImages];
    NSString *tempPathFiles = [SMSharedFilesClass tempPathForKey:_mediaType];
    
    NSArray *arrayImages = [SMSharedFilesClass allFilesAtPath: tempPathFiles];
    NSMutableArray *arrayKeys = [[NSMutableArray alloc] init];
    
    for (NSString *path in arrayImages) {
        NSString *key = [NSString stringWithFormat:@"datakey%02ld", (unsigned long)[arrayImages indexOfObject:path]];
        [arrayKeys addObject:key];
        NSString *tempPath = [tempPathFiles stringByAppendingPathComponent:path];
        if(_mediaType  == videoType){
            [request addFile:tempPath withFileName:path andContentType:@"multipart/form-data" forKey:@"videoFiles"];
            // [request addPostValue:@"video" forKey:@"key"];
            
        }else{
            [request addFile:tempPath forKey:key];
        }
        
        if(_mediaType  == videoType){
            NSString *tempPathFiles = [SMSharedFilesClass tempPathForKey:videoThumbnailType];
            NSArray *thumbNailArrayImages = [SMSharedFilesClass allFilesAtPath: tempPathFiles];
            //NSString *thumbNailkey = [NSString stringWithFormat:@"datakey%02ld", (unsigned long)[arrayImages indexOfObject:path]];
            [arrayKeys addObject:key];
            NSString *tempPath = [tempPathFiles stringByAppendingPathComponent:[thumbNailArrayImages objectAtIndex:[arrayImages indexOfObject:path]]];
            //[request addFile:tempPath forKey:key];
            //[request addFile:tempPath withFileName:[thumbNailArrayImages objectAtIndex:[arrayImages indexOfObject:path]] andContentType:@"multipart/form-data" forKey:@"thumbnail"];
            NSString *  file = [thumbNailArrayImages objectAtIndex:[arrayImages indexOfObject:path]];
            [request addFile:tempPath withFileName:file andContentType:@"multipart/form-data" forKey:@"thumbnail"];
            
        }
    }
    
    NSLog(@"Key Type : %@", keyType);
    NSLog(@"Keys : %@", arrayKeys);
    NSLog(@"Files : %@", request);
    [request addPostValue:arrayKeys forKey:@"keys"];
    [request startAsynchronous];
}

- (void) addLoader{
    [CircleLoaderView addToWindow];
}

- (void) removeLoader{
    [CircleLoaderView removeFromWindow];
}


@end
