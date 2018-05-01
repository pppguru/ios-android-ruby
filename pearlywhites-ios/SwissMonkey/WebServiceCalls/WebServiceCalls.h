//
//  WebServiceCalls.h
//  SwissMonkey
//
//  Created by Kasturi on 23/12/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

#define MODULE_JOBS @"job"
#define MODULE_PEOPLE @"people"
#define MODULE_USER @"user"
#define MODULE_DROPDOWN @"dropdown"
#define MODULE_PROFILE @"profile"
#define MODULE_SETTINGS @"settings"

#define METHOD_SAVE @"save"
#define METHOD_UPDATE @"update"
#define METHOD_DELETE @"delete"

#define METHOD_LOGIN @"login"
#define METHOD_LOGOUT @"logout"
#define METHOD_SIGNUP @"signup"
#define METHOD_FORGOT @"forgot"

#define METHOD_INFO @"info"
#define METHOD_SEARCH @"search"
#define METHOD_DETAILS @"details"
#define METHOD_SAVEDJOBS @"savedjobs"
#define METHOD_APPLICATIONS @"applications"
#define METHOD_JOBS @"jobs"
#define METHOD_HISTORY @"history"
#define METHOD_APPLY @"apply"
#define METHOD_UPLOAD @"upload"
#define METHOD_DOWNLOAD @"download"

#define METHOD_DROPDOWNDATA @"data"
#define METHOD_NOTIFICATIONS @"apinotifications"
#define METHOD_VIEWED_NOTIFICATIONS @"viewed"
#define METHOD_DEVICE_REGISTRATION @"deviceregistration"
#define METHOD_ACTIVATE @"activate"
#define METHOD_DEACTIVATE @"deactivate"
#define METHOD_RESET @"reset"
#define METHOD_ACCEPT_TandC @"accept_privacy_policy"
#define METHOD_GET_TandC_STATUS @"privacy_policy_status"


#define METHOD_TYPE_GET @"GET"
#define METHOD_TYPE_POST @"POST"
#define METHOD_TYPE_PUT @"PUT"

#define k_IMG_FILES_KEY @"imgFiles"
#define k_VDI_FILES_KEY @"videoFiles"
#define k_PCT_FILES_KEY @"profile"
#define k_RSM_FILES_KEY @"resume"
#define k_RL_FILES_KEY  @"recommendationletters"
#define K_VIDEOTHUMBNAIL_FILES_KEY @"videoThumbnail"

typedef enum{
    imageType = 5,
    videoType,
    pictureType,
    recommendationType,
    resumeType,
    videoThumbnailType
}MediaType;


#define k_NONEEDAUTHKEY( methodName ) ( [ methodName isEqualToString:METHOD_LOGIN ] || [ methodName isEqualToString:METHOD_SIGNUP ] || [ methodName isEqualToString:METHOD_FORGOT ] )


@protocol WebServiceDelegate

@end

@interface APIObject : NSObject
{

}

-(id)initWithMethodName:(NSString *)_methodName ModuleName:(NSString *)_moduleName MethodType:(NSString *)_methodType Parameters:(NSMutableDictionary *)_parameters SuccessCallBack:(SEL)success AndFailureCallBack:(SEL)failure;
@property (strong,nonatomic) NSString * methodName, * moduleName, * methodType;
@property (strong,nonatomic) NSMutableDictionary * parameters;
@property (assign) SEL success, failure;

@end

@interface WebServiceCalls : NSObject

@property (strong,nonatomic) APIObject * requestObject;
@property (strong,nonatomic) id <WebServiceDelegate> delegate;
@property (strong,nonatomic) id  responseData;
@property (strong,nonatomic) NSError * responseError;
@property (nonatomic, readwrite) MediaType mediaType;
@property (nonatomic, strong) NSString *strFileName;
@property (nonatomic, strong) NSData *content;
@property  (nonatomic,assign) BOOL isLoaderHidden, noLoader;

//@property (nonatomic, strong) NSMutableArray *arrayTempFiles;

- (id) initWebServiceCallWithAPIRequest:(APIObject *)apiObject withDelegate:(id)delegateObj;
- (void) makeWebServiceCall;
- (void) sendAPICall;
- (void) makeServerCallForFiles:(id <ASIHTTPRequestDelegate>) requestDelegate;
- (void) downloadFileFromURL:(NSString *) url;
@end
