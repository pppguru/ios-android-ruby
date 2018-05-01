//
//  SMSharedFilesClass.m
//  SwissMonkey
//
//  Created by Yadagiri Neeli on 24/02/16.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import "SMSharedFilesClass.h"
#import "CircleLoaderView.h"

@implementation SMSharedFilesClass

static SMSharedFilesClass *sharedFileObject;
static UIView *filesDownloadingView;

+ (SMSharedFilesClass *) sharedFileObject{
    if(!sharedFileObject){
        sharedFileObject = [[SMSharedFilesClass alloc] init];
        sharedFileObject.dowloadImagesCount = 0;
        sharedFileObject.uploadingCount = 0;
    }
    return sharedFileObject;
}

+ (void) addFilesDownloadingLabel
{
    UIView *view = [CircleLoaderView window];
    if(!filesDownloadingView)
    {
        filesDownloadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 50)];
        [filesDownloadingView setBackgroundColor:[UIColor colorWithWhite:0 alpha:.5]];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:filesDownloadingView.bounds];
        [lbl setText:@"Please wait...\nFiles are downloading..."];
        [lbl setNumberOfLines:0];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setTextColor:[UIColor whiteColor]];
        [lbl setFont:[UIFont appLatoLightFont10]];
        [filesDownloadingView addSubview: lbl];
        
        
        CGPoint center = view.center;
        center.y += 80;
        [filesDownloadingView setCenter:center];
        [[filesDownloadingView layer] setCornerRadius:5.0f];
    }
    [view addSubview:filesDownloadingView];
}

+ (void) removeFilesDownloadingLabel{
    [filesDownloadingView removeFromSuperview];
}

#pragma mark - Documentory Path

+ (NSString *) documentDirectoryPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}


#pragma mark - Profile Images Documentory Path

+ (NSString *) profileImagesPath{
    NSString *documentsDirectory = [self documentDirectoryPath];
    return [documentsDirectory stringByAppendingPathComponent:@"profile/images/"];
}

+ (NSString *) profileTempImagesPath{
    NSString *documentsDirectory = [self profileImagesPath];
    return [documentsDirectory stringByAppendingPathComponent:@"temp/"];
}

#pragma mark - Profile Video Documentory Path

+ (NSString *) profileVideosPath{
    NSString *documentsDirectory = [self documentDirectoryPath];
    return [documentsDirectory stringByAppendingPathComponent:@"profile/video/"];
}

+ (NSString *) profileTempVideosPath{
    NSString *documentsDirectory = [self profileVideosPath];
    return [documentsDirectory stringByAppendingPathComponent:@"temp/"];
}

#pragma mark - Profile Picture Documentory Path

+ (NSString *) profilePicturePath{
    NSString *documentsDirectory = [self documentDirectoryPath];
    return [documentsDirectory stringByAppendingPathComponent:@"profile/picture/"];
}

+ (NSString *) profileTempPicturePath{
    NSString *documentsDirectory = [self profilePicturePath];
    return [documentsDirectory stringByAppendingPathComponent:@"temp/"];
}

#pragma mark - Profile Resume Documentory Path

+ (NSString *) profileResumePath{
    NSString *documentsDirectory = [self documentDirectoryPath];
    return [documentsDirectory stringByAppendingPathComponent:@"profile/resume/"];
}

+ (NSString *) profileTempResumePath{
    NSString *documentsDirectory = [self profileResumePath];
    return [documentsDirectory stringByAppendingPathComponent:@"temp/"];
}

#pragma mark - Profile RecommendationLetters Documentory Path

+ (NSString *) profilePRecommendationLettersPath{
    NSString *documentsDirectory = [self documentDirectoryPath];
    return [documentsDirectory stringByAppendingPathComponent:@"profile/recommendationletters/"];
}

+ (NSString *) profileTempRecommendationLettersPath{
    NSString *documentsDirectory = [self profilePRecommendationLettersPath];
    return [documentsDirectory stringByAppendingPathComponent:@"temp/"];
}

#pragma mark - Profile VideoThumbNail Documentory Path

+ (NSString *) profileVideoThumbNailPath{
    NSString *documentsDirectory = [self documentDirectoryPath];
    return [documentsDirectory stringByAppendingPathComponent:@"profile/videoThumbnails/"];
}

+ (NSString *) profileTempVideoThumbNailPath{
    NSString *documentsDirectory = [self profileVideoThumbNailPath];
    return [documentsDirectory stringByAppendingPathComponent:@"temp/"];
}

#pragma mark - Savigin in Documentory File

+ (NSString *) saveImageAtDocumentoryPath:(id) content withName:(NSString *)name needExtension:(BOOL) need mediaType:(MediaType)mediaType{
    
    
    NSString *savedImagePath = [self tempPathForKey:mediaType];//mediaType == imageType ? [self profileTempImagesPath] : [self profileTempVideosPath];
    
    int random = rand() % 10000;
    
    NSError *error = nil;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:savedImagePath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:savedImagePath withIntermediateDirectories:YES attributes:nil error:&error]; //Create folder
        [self addSkipBackupAttributeToItemAtPath:savedImagePath];
//        [self addSkipBackupAttributeToItemAtPath:[self profileImagesPath]];
    }
    NSData *contentData = nil;
    
    if([content isKindOfClass:[UIImage class]]){
        UIImage *image = (UIImage *)content;
        savedImagePath = [savedImagePath stringByAppendingPathComponent:name ? name : [NSString stringWithFormat:@"image%i", random]];
        
        contentData = UIImageJPEGRepresentation(image, 0.7);
        if(!contentData){
            contentData = UIImagePNGRepresentation(image);
            if(need)
                savedImagePath = [savedImagePath stringByAppendingString:@".PNG"];
        }
        else if(need){
            savedImagePath = [savedImagePath stringByAppendingString:@".JPG"];
        }
        NSLog(@"savedImagePath : %@", savedImagePath);
    }
    else{
        savedImagePath = [savedImagePath stringByAppendingPathComponent:name];
        contentData = (NSData *) content;
    }
    //    NSData *imageData = UIImagePNGRepresentation(image);
    [contentData writeToFile:savedImagePath atomically:NO];
    
    return savedImagePath;
}

#pragma mark - Action sheet based on device

+ (UIActionSheet *) actionSheetWithDelegate:(id) actDelegate{
    UIActionSheet *popup = nil;
    if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]){
        popup = [[UIActionSheet alloc] initWithTitle:@"Select your option:" delegate:actDelegate cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Album", @"Camera", nil];
    }
    else{
        popup = [[UIActionSheet alloc] initWithTitle:@"Select your option:" delegate:actDelegate cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Album", nil];
    }
    return popup;
}


+ (NSString *) keyForMedia:(MediaType) type{
    
    NSString *key = nil;
    switch (type) {
        case imageType:
            key = k_IMG_FILES_KEY;
            break;
        case videoType:
            key = k_VDI_FILES_KEY;
            break;
        case pictureType:
            key = k_PCT_FILES_KEY;
            break;
        case resumeType:
            key = k_RSM_FILES_KEY;
            break;
        case videoThumbnailType:
            key = K_VIDEOTHUMBNAIL_FILES_KEY;
            break;
        default:
            key = k_RL_FILES_KEY;
            break;
    }
    return key;
}

+ (NSString *) tempPathForKey:(MediaType)mediaType{
    NSString *tempPathFiles = nil;
    
    switch (mediaType) {
        case imageType:
            tempPathFiles = [self profileTempImagesPath];
            break;
        case videoType:
            tempPathFiles = [self profileTempVideosPath];
            break;
        case pictureType:
            tempPathFiles = [self profileTempPicturePath];
            break;
        case resumeType:
            tempPathFiles = [self profileTempResumePath];
            break;
        case videoThumbnailType:
            tempPathFiles = [self profileTempVideoThumbNailPath];
            break;
        default:
            tempPathFiles = [self profileTempRecommendationLettersPath];
            break;
    }
    
    return tempPathFiles;
}

+ (NSString *) filesPathForKey:(MediaType)mediaType{
    NSString *filesPathFiles = nil;
    
    switch (mediaType) {
        case imageType:
            filesPathFiles = [self profileImagesPath];
            break;
        case videoType:
            filesPathFiles = [self profileVideosPath];
            break;
        case pictureType:
            filesPathFiles = [self profilePicturePath];
            break;
        case resumeType:
            filesPathFiles = [self profileResumePath];
            break;
        case videoThumbnailType:
            filesPathFiles = [self profileVideoThumbNailPath];
            break;

        default:
            filesPathFiles = [self profilePRecommendationLettersPath];
            break;
    }
    
    return filesPathFiles;
}

#pragma mark - Skipping the Cloud sync at path

+ (BOOL) addSkipBackupAttributeToItemAtPath:(NSString *) filePathString
{
    NSURL* URL= [NSURL fileURLWithPath: filePathString];
    // assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        
    }
    return success;
}

#pragma mark - Files At Path

+ (NSArray *) allFilesAtPath:(NSString *) path{//exclude subDirectaries
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    NSMutableArray *filesOnly = [NSMutableArray new];
    for (NSString *string in directoryContent) {
        if(k_FILEONLY(string)){
            
//            NSString *username = [ReusedMethods username];
//            if(username && [string hasPrefix:username])
                [filesOnly addObject:string];
        }
    }
    
    return filesOnly;
}

+ (NSArray *) allSubDirectoriesAtPath:(NSString *) path{
    NSArray *directoryContent = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:path error:NULL];
    return directoryContent;
}

+ (NSInteger)listFileAtPath:(NSString *)path
{
    NSInteger atServer = [[self allFilesAtPath:path] count];
    NSInteger atLocal = [[self allFilesAtPath:[path stringByAppendingPathComponent:@"temp/"]] count];
    return atServer + atLocal;// - subDirectories;
}

+ (NSInteger) allProfileImages{
    return [self listFileAtPath:[self profileImagesPath]] + [self listFileAtPath:[self profileTempImagesPath]];
}

+ (NSInteger) filesCountAtPath:(NSString *)path{
    return [[self allFilesAtPath:path] count];
}

#pragma mark - Upload Local Files

//+ (void) uploadAllLocalImagesToServer:(id) delegate{
//    WebServiceCalls *serverCall = [[WebServiceCalls alloc] init];
//    serverCall.mediaType = imageType;
//    [serverCall performSelector:@selector(makeServerCallForFiles:) withObject:delegate afterDelay:1.0];
//}
//
//#pragma mark - Upload Local Videos
//
//+ (void) uploadAllLocalVideosToServer:(id) delegate{
//    WebServiceCalls *serverCall = [[WebServiceCalls alloc] init];
//    serverCall.mediaType = videoType;
//    [serverCall performSelector:@selector(makeServerCallForFiles:) withObject:delegate afterDelay:1.0];
//}
//
//
//#pragma mark - Upload Local Profile Picture
//
//+ (void) uploadAllLocalPPictureToServer:(id) delegate{
//    WebServiceCalls *serverCall = [[WebServiceCalls alloc] init];
//    serverCall.mediaType = pictureType;
//    [serverCall performSelector:@selector(makeServerCallForFiles:) withObject:delegate afterDelay:1.0];
//}

+ (void) uploadAllLocalFilesToServer:(id) delegate andMediaType:(MediaType) mediaType{
    WebServiceCalls *serverCall = [[WebServiceCalls alloc] init];
    serverCall.mediaType = mediaType;
    //[serverCall performSelector:@selector(makeServerCallForFiles:) withObject:delegate afterDelay:k_SERVER_CALL_DELAY];
    [CircleLoaderView addToWindow];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

    [serverCall makeServerCallForFiles:delegate];
    });
}

#pragma mark - Download images

+ (BOOL) need2DownloadFile:(NSString *)filePath
{
//    NSString *filePath = [path stringByAppendingPathComponent:name];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    return !fileExists;
    
//    if(!fileExists)
//    {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            // Create the image URL from a known string.
//            NSURL *imageURL = [NSURL URLWithString:imageStrURL];
//            
//            NSError *downloadError = nil;
//            // Create an NSData object from the contents of the given URL.
//            NSData *imageData = [NSData dataWithContentsOfURL:imageURL options:kNilOptions error:&downloadError];
//            // ALWAYS utilize the error parameter!
//            if (downloadError)
//            {
//                // Something went wrong downloading the image. Figure out what went wrong and handle the error.
//                // Don't forget to return to the main thread if you plan on doing UI updates here as well.
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    //                [self.activityIndicator stopAnimating];
//                    NSLog(@"%@",[downloadError localizedDescription]);
//                });
//            } else
//            {
//                [self saveImageAtDocumentoryPath:[UIImage imageWithData:imageData] withName:[imageStrURL lastPathComponent] needExtension:NO mediaType:imageType];
//            }
//        });
//    }
//    else{
//        NSLog(@"File already exstist at path : %@", filePath);
//    }
}

+ (void) downloadAllImagesAndVideos
{
    NSDictionary *profileInfo = [ReusedMethods userProfile];
    for (NSString *string in [profileInfo objectForKey:@"image"])
    {
        [self downloadFile:[string lastPathComponent] type:imageType];
    }
    for (NSString *string in [profileInfo objectForKey:@"video"])
    {
        [self downloadFile:[string lastPathComponent] type:videoType];
    }
    for (NSString *string in [profileInfo objectForKey:@"recomendationLettrs"])
    {
        [self downloadFile:[string lastPathComponent] type:recommendationType];
    }
//        NSString *file = [[profileInfo objectForKey:@"resume"] lastPathComponent];
//     
//     if(file)
//     [self downloadFile:file type:resumeType]; //=====UPLOAD5RESUMES===
//     
//    
    for (NSString *string in [profileInfo objectForKey:@"resume"])
    {
        [self downloadFile:[string lastPathComponent] type:resumeType];
    }
    

    
   NSString *file = [[profileInfo objectForKey:@"profile"] lastPathComponent];
    
    if(file)
        [self downloadFile:[file lastPathComponent] type:pictureType];
    
//    WebServiceCalls *service = [[WebServiceCalls alloc]init];
//    
//    for (NSString *string in [profileInfo objectForKey:@"image_url"])
//    {
//        [service setStrFileName:@"name"];
//        [service setMediaType:imageType];
//        APIObject * reqObject = [[APIObject alloc] init];
//        reqObject.success = @selector(apiCallSuccess:);
//        [service setDelegate:[self sharedFileObject]];
//        [service performSelectorInBackground:@selector(downloadFileFromURL:) withObject:string];
////        [service downloadFileFromURL:string];
////        [self downloadFile:[string lastPathComponent] type:imageType];
//    }

}

+ (void) downloadFile:(NSString *)name type:(MediaType)type
{
//    [[self profileVideosPath] stringByAppendingPathComponent:name];
//    NSString *imgName = [name lastPathComponent];
    //        [self downloadImage:[BASEURL stringByAppendingPathComponent:string]];
    
    NSString *path = [self filesPathForKey:type];
    if([self need2DownloadFile:[path stringByAppendingPathComponent:name]])
    {
        [CircleLoaderView addToWindow];
        [self addFilesDownloadingLabel];
        
        sharedFileObject.dowloadImagesCount += 1;
        NSLog(@"Download images Count : %ld", sharedFileObject.dowloadImagesCount);
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:[self keyForMedia:type] forKey:@"type"];
        [params setObject:name forKey:@"file"];
        
        APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_DOWNLOAD ModuleName:MODULE_PROFILE MethodType:METHOD_TYPE_POST Parameters:params SuccessCallBack:@selector(apiCallSuccess:) AndFailureCallBack:@selector(apiCallFailed:)];
        
        WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:[self sharedFileObject]];
        [service setStrFileName:name];
        [service setMediaType:type];
        [service performSelectorInBackground:@selector(sendAPICall) withObject:nil];
    }
}

- (void) apiCallSuccess:(WebServiceCalls *)server{
    
    [SMSharedFilesClass saveFileAtPath:[SMSharedFilesClass filesPathForKey:server.mediaType] name:server.strFileName withData:server.content];
    NSLog(@"%@", server.responseData);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"profileImageUpdateNotification" object:nil];

    
    [self checkAboutLoaderRemove];
//    NSLog(@"\nimage Name : %@\nKey Name : %i", server.strFileName, server.mediaType);
}

- (void) checkAboutLoaderRemove{
    sharedFileObject.dowloadImagesCount -= 1;
    NSLog(@"Download images Count : %ld", sharedFileObject.dowloadImagesCount);
    
    [CircleLoaderView removeFromWindow];
    if(sharedFileObject.dowloadImagesCount == 0)
    {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate refreshTopViewAfterDownloadingAllFiles];
        [SMSharedFilesClass removeFilesDownloadingLabel];
    }
}

- (void) apiCallFailed:(WebServiceCalls *) server{
    NSLog(@"\n\nserver.responseError : %@\nserver.responseData : %@", server.responseError, server.responseData);
    [self checkAboutLoaderRemove];
}

+ (void) saveFileAtPath:(NSString *) path name:(NSString *)name withData:(NSData *) content{
    
    NSError *error = nil;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]; //Create folder
        [self addSkipBackupAttributeToItemAtPath:path];
//        [self addSkipBackupAttributeToItemAtPath:[self profileImagesPath]];
    }
    
//    NSData *contentData = nil;
//    
//    if([content isKindOfClass:[UIImage class]]){
//        UIImage *image = (UIImage *)content;
//        savedImagePath = [savedImagePath stringByAppendingPathComponent:name ? name : [NSString stringWithFormat:@"image%i", random]];
//        
//        contentData = UIImageJPEGRepresentation(image, 0.7);
//        if(!contentData){
//            contentData = UIImagePNGRepresentation(image);
//            if(need)
//                savedImagePath = [savedImagePath stringByAppendingString:@".PNG"];
//        }
//        else if(need){
//            savedImagePath = [savedImagePath stringByAppendingString:@".JPG"];
//        }
//        NSLog(@"savedImagePath : %@", savedImagePath);
//    }
//    else{
//        savedImagePath = [savedImagePath stringByAppendingPathComponent:name];
//        contentData = (NSData *) content;
//    }
    //    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSString *filePath = [path stringByAppendingPathComponent:name];
    if([content writeToFile:filePath atomically:NO]){
        NSLog(@"File Saved At Path : %@", filePath);
    }
    else{
        NSLog(@"Could not saved file Path : %@", filePath);
    }
}

+ (void) setProfilePicture2Button:(id) profileButton
{
    @try {
//        NSString *profile = [[ReusedMethods userProfile] objectForKey:@"profile"];
//        NSString *path = [self profileTempPicturePath];
//        
//            if(!(profile && profile.length)){
//                return;
//            }
//        
//        NSArray *images = [self allFilesAtPath:path];
//        if(![images containsObject:profile])
//        {
//            path = [self profilePicturePath];
//            images = [self allFilesAtPath:path];
//        }
//        
//        if([images containsObject:profile])
//        {
//            
//            NSString *filePath = [path stringByAppendingPathComponent:profile];
//            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
            if([profileButton isKindOfClass:[UIButton class]])
            {
                NSString *imageURL = [[ReusedMethods userProfile] valueForKey:@"profile_url"];
                [[[SDWebImageManager sharedManager] imageCache] setMaxCacheAge:30*60];
                [(UIButton *)profileButton setImage:nil forState:UIControlStateNormal];
                [(UIButton *)profileButton sd_setBackgroundImageWithURL:[NSURL URLWithString:imageURL] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"empty_profile_photo"] options:SDWebImageCacheMemoryOnly];
                
            }
            else{
                NSString *imageURL = [[ReusedMethods userProfile] valueForKey:@"profile_url"];
                [[[SDWebImageManager sharedManager] imageCache] setMaxCacheAge:30*60];
                [(UIImageView *)profileButton sd_setImageWithURL:[NSURL URLWithString:imageURL]
                                             placeholderImage:[UIImage imageNamed:@"empty_profile_photo"]
                                                      options:SDWebImageRefreshCached];
//                [(UIImageView *)profileButton setImage:image];
            }
//        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
 
    
//    NSString *path = [self profilePicturePath];
}


// display  profile image (upload  photos)
+ (void) setProfileImagesOnView:(id) profileImageView atIndexPath:(NSIndexPath *) indexpath{
    
//    NSString *path = [self profileTempImagesPath];
//
//    NSArray *images = [self allFilesAtPath:path];
//    if(![images count]){
//        path = [self profileImagesPath];
//        images = [self allFilesAtPath:path];
//    }
    NSLog(@"Tag : %ld", (long)[(UIButton *)profileImageView tag]);
    NSLog(@"Indexpath Row : %ld and section %ld", (long)indexpath.row, (long)indexpath.section);
//    NSMutableArray *images = [self getProfileImagesArray];
    NSMutableArray *images = [[ReusedMethods userProfile] objectForKey:@"image_url"];
    if([images count]){
//        NSString *filePath = [path stringByAppendingPathComponent:[images objectAtIndex:indexpath.row]];
//        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
//        if(!image){
//            path = [self profileImagesPath];
//            filePath = [path stringByAppendingPathComponent:[images objectAtIndex:indexpath.row]];
//            image = [UIImage imageWithContentsOfFile:filePath];
//        }
        NSString *imageURL = [images objectAtIndex:indexpath.row];
        [[[SDWebImageManager sharedManager] imageCache] setMaxCacheAge:30*60];
        if([profileImageView isKindOfClass:[UIButton class]]){
//            [[profileImageView imageView] sd_setImageWithURL:[NSURL URLWithString:imageURL]
//                                            placeholderImage:nil
//                                                     options:SDWebImageCacheMemoryOnly];
            //[(UIButton *)profileImageView setBackgroundImage:image forState:UIControlStateNormal];
            
            [(UIButton *)profileImageView  sd_setImageWithURL:[NSURL URLWithString:imageURL] forState:UIControlStateNormal placeholderImage:nil options:SDWebImageCacheMemoryOnly ];
        }
        else{
            [(UIImageView *)profileImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]
                                            placeholderImage:nil
                                                     options:SDWebImageCacheMemoryOnly];
//            [(UIImageView *)profileImageView setImage:image];
        }
    }
}

+ (void) setResumeImagesOnView:(id) profileImageView atIndexPath:(NSIndexPath *) indexpath{
    
//    NSString *path = [self profileTempResumePath];
//     NSMutableArray *images = [[self getProfileResumesArray] mutableCopy];

    NSMutableArray *images = [[ReusedMethods userProfile] objectForKey:@"resume_url"];
    
    if([images count]){
//        NSString *filePath = [path stringByAppendingPathComponent:[images objectAtIndex:indexpath.row]];
//        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
//        if(!image){
//            path = [self profileResumePath];
//            filePath = [path stringByAppendingPathComponent:[images objectAtIndex:indexpath.row]];
//            image = [UIImage imageWithContentsOfFile:filePath];
//        }
        
        NSString *imageURL = [images objectAtIndex:indexpath.row];
        [[[SDWebImageManager sharedManager] imageCache] setMaxCacheAge:30*60];
        if([profileImageView isKindOfClass:[UIButton class]]){
//            [[profileImageView imageView] sd_setImageWithURL:[NSURL URLWithString:imageURL]
//                                            placeholderImage:nil
//                                                     options:SDWebImageCacheMemoryOnly];
            //[(UIButton *)profileImageView setBackgroundImage:image forState:UIControlStateNormal];
            [(UIButton *)profileImageView  sd_setImageWithURL:[NSURL URLWithString:imageURL] forState:UIControlStateNormal placeholderImage:nil options:SDWebImageCacheMemoryOnly ];

        }
        else{
            [(UIImageView *)profileImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]
                                               placeholderImage:nil
                                                        options:SDWebImageCacheMemoryOnly];
            //            [(UIImageView *)profileImageView setImage:image];
        }
    }
}

+ (void) setLetterOfRecommendationImagesOnView:(id) profileImageView atIndexPath:(NSIndexPath *) indexpath{
    
//    NSString *path = [self profileTempRecommendationLettersPath];
    NSMutableArray *images = [[ReusedMethods userProfile] objectForKey:@"recomendationLettrs_url"];
    
    if([images count]){
//        NSString *filePath = [path stringByAppendingPathComponent:[images objectAtIndex:indexpath.row]];
//        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
//        if(!image){
//            path = [self profilePRecommendationLettersPath];
//            filePath = [path stringByAppendingPathComponent:[images objectAtIndex:indexpath.row]];
//            image = [UIImage imageWithContentsOfFile:filePath];
//        }
        
        NSString *imageURL = [images objectAtIndex:indexpath.row];
        [[[SDWebImageManager sharedManager] imageCache] setMaxCacheAge:30*60];

        if([profileImageView isKindOfClass:[UIButton class]]){
//            [[profileImageView imageView] sd_setImageWithURL:[NSURL URLWithString:imageURL]
//                                            placeholderImage:nil
//                                                     options:SDWebImageCacheMemoryOnly];
//            [(UIButton *)profileImageView setBackgroundImage:image forState:UIControlStateNormal];
//            [(UIButton *)profileImageView setImage:nil forState:UIControlStateNormal];
            
            [(UIButton *)profileImageView  sd_setImageWithURL:[NSURL URLWithString:imageURL] forState:UIControlStateNormal placeholderImage:nil options:SDWebImageCacheMemoryOnly ];

        }
        else{
            [(UIImageView *)profileImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]
                                               placeholderImage:nil
                                                        options:SDWebImageCacheMemoryOnly];
//            [(UIImageView *)profileImageView setImage:image];
        }
    }
}


+ (void) setVideoImagesOnView:(id) profileImageView atIndexpath:(NSIndexPath *) indexPath
{
//    NSString *path = [self profileTempVideosPath];
//
//    NSArray *videos = [self allFilesAtPath:path];
//    if(![videos count])
//    {
//        path = [self profileVideosPath];
//        videos = [self allFilesAtPath:path];
//    }
//    NSArray *videos = [self getProfileVideosArray];
    NSArray *videos = [[ReusedMethods userProfile] objectForKey:@"video_url"];
    
    if([videos count])
    {
//        NSString *filePath = [path stringByAppendingPathComponent:[videos objectAtIndex:indexPath.row]];
//        UIImage *image = [ReusedMethods  generateThumbImage:filePath];
//        if(!image){
//            filePath = [[self profileVideosPath] stringByAppendingPathComponent:[videos objectAtIndex:indexPath.row]];
//            image = [ReusedMethods  generateThumbImage:filePath];
//        }
        NSString *filePath = [videos objectAtIndex:indexPath.row];
       // [ReusedMethods  generateThumbImage:filePath withImageView:profileImageView];
//        if(!image){
//            filePath = [[self profileVideosPath] stringByAppendingPathComponent:[videos objectAtIndex:indexPath.row]];
//            image = [ReusedMethods  generateThumbImage:filePath];
//        }
        
//        if([profileImageView isKindOfClass:[UIButton class]])
//            [(UIButton *)profileImageView setImage:image forState:UIControlStateNormal];
//        else
//            [(UIImageView *)profileImageView setImage:image];
    }
    
        NSString *path = [self profileTempRecommendationLettersPath];
    
    
    
    // if  images  are  existed  with thumbnails  urls
    
    NSMutableArray *images = [[ReusedMethods userProfile] objectForKey:@"videoThumbnail"];
    if([images count]){
        NSString *imageURL = [images objectAtIndex:indexPath.row];
        [[[SDWebImageManager sharedManager] imageCache] setMaxCacheAge:30*60];
        
        if ([imageURL isKindOfClass:[NSString class]]) {
            if([profileImageView isKindOfClass:[UIButton class]]){
                [(UIButton *)profileImageView  sd_setImageWithURL:[NSURL URLWithString:imageURL] forState:UIControlStateNormal placeholderImage:nil options:SDWebImageCacheMemoryOnly ];
            }
            else{
                [(UIImageView *)profileImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]
                                                   placeholderImage:nil
                                                            options:SDWebImageCacheMemoryOnly];
            }
        }
    }

    
}

+ (void) setCorrespondingImagesOnView:(id) profileImageView atIndexPath:(NSIndexPath *) indexPath mediaType:(MediaType) mediaType{
    
    NSMutableDictionary  * arrayObjectsDict  =  [self getFilesArrayWithMediaType:mediaType];
    NSString * path  = [arrayObjectsDict objectForKey:@"objectsPath"];
    NSArray * objectsArray = [arrayObjectsDict objectForKey:@"objects"];
    
    if([objectsArray count])
    {
        NSString *filePath = [path stringByAppendingPathComponent:[objectsArray objectAtIndex:indexPath.row]];
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        if([profileImageView isKindOfClass:[UIButton class]])
            [(UIButton *)profileImageView setImage:image forState:UIControlStateNormal];
        else
            [(UIImageView *)profileImageView setImage:image];
    }
}

+ (NSMutableDictionary *) getFilesArrayWithMediaType:(MediaType) mediaType{
    
    NSString * path;
    NSArray * arrayObjects;
    switch (mediaType) {
        case resumeType:
            path = [self profileTempResumePath];
            arrayObjects = [self allFilesAtPath:path];
            if(![arrayObjects count]){
                path =  [self profileResumePath];
                arrayObjects = [self allFilesAtPath:path];
            }
            break;
        case recommendationType:
            path = [self profilePRecommendationLettersPath];
            arrayObjects = [self allFilesAtPath:path];
            if(![arrayObjects count]){
                path =  [self profileTempRecommendationLettersPath];
                arrayObjects = [self allFilesAtPath:path];
            }
            break;
            
        default:
            break;
    }
    
    NSMutableDictionary *  dict  =  [[NSMutableDictionary alloc] init];
    [dict setObject:path forKey:@"objectsPath"];
    [dict setObject:arrayObjects forKey:@"objects"];
    
    return dict;
 
}


+ (void) removeAllObjectAtPath:(NSArray *)images type:(MediaType)mediaType{
    NSString *rootPath = [self filesPathForKey:mediaType];
    for (NSString *name in images) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePath = [rootPath stringByAppendingPathComponent:name];
        NSError *error = nil;
        if([fileManager fileExistsAtPath:filePath])
            [fileManager removeItemAtPath:filePath error:&error];
        if(error){
            NSLog(@"Error removing file at Path : %@", filePath);
        }
        else
            NSLog(@"File removed at Path : %@", filePath);
    }
}

+ (void) removeAllTempObjectAtPath:(NSArray *)images type:(MediaType)mediaType{
    NSString *rootPath = [self tempPathForKey:mediaType];
    for (NSString *name in images) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePath = [rootPath stringByAppendingPathComponent:name];
        NSError *error = nil;
        if([fileManager fileExistsAtPath:filePath])
            [fileManager removeItemAtPath:filePath error:&error];
        if(error){
            NSLog(@"Error removing file at Path : %@", filePath);
        }
        else
            NSLog(@"File removed at Path : %@", filePath);
    }
}

#pragma mark - GET COUNTS OF VIDEOS , IMAGES

+ (NSMutableArray *) getProfileImagesArray{
    NSString *path = [SMSharedFilesClass profileTempImagesPath];
    NSMutableArray *images = [[NSMutableArray alloc] initWithArray:[SMSharedFilesClass allFilesAtPath:path]];
//    NSArray *tempImages = [SMSharedFilesClass allFilesAtPath:path];
//    if(![images count]){
    path = [SMSharedFilesClass profileImagesPath];
    
    [images addObjectsFromArray:[SMSharedFilesClass allFilesAtPath:path]];
//    }
    return images;
}

+ (NSMutableArray *) getProfileVideosArray{
    NSString *path = [SMSharedFilesClass profileTempVideosPath];
    NSMutableArray *videos = [[NSMutableArray alloc] initWithArray:[SMSharedFilesClass allFilesAtPath:path]];
//    if(![videos count]){
        path = [SMSharedFilesClass profileVideosPath];
        [videos addObjectsFromArray:[SMSharedFilesClass allFilesAtPath:path]];
//    }
    return videos;
}

+ (NSArray *) getProfileResumesArray{

    NSString *path = [SMSharedFilesClass profileTempResumePath];
    NSMutableArray *images = [[NSMutableArray alloc] initWithArray:[SMSharedFilesClass allFilesAtPath:path]];
//    if(![images count]){
        path = [SMSharedFilesClass profileResumePath];
        [images addObjectsFromArray:[SMSharedFilesClass allFilesAtPath:path]];
//    }
    return images;
}

+ (NSArray *) getProfileLettersOfRecommendatationsArray{

    NSString *path = [SMSharedFilesClass profileTempRecommendationLettersPath];
    NSMutableArray *images = [[NSMutableArray alloc] initWithArray:[SMSharedFilesClass allFilesAtPath:path]];
//    if(![images count]){
        path = [SMSharedFilesClass profilePRecommendationLettersPath];
        [images addObjectsFromArray:[SMSharedFilesClass allFilesAtPath:path]];
//    }
    return images;
}

//+ (NSArray *) getprofilePictureArray{
//    NSString *path = [SMSharedFilesClass profileTempRecommendationLettersPath];
//    NSArray *images = [SMSharedFilesClass allFilesAtPath:path];
//    if(![images count]){
//        path = [SMSharedFilesClass profilePRecommendationLettersPath];
//        images = [SMSharedFilesClass allFilesAtPath:path];
//    }
//    return images;
//}



//- (NSArray *) getVideoImagesArray{
//    
//    NSArray *arrayVedios = [SMSharedFilesClass allFilesAtPath:[SMSharedFilesClass profileVideosPath]];
//    if(![arrayVedios count])
//        arrayVedios = [SMSharedFilesClass allFilesAtPath:[SMSharedFilesClass profileTempVideosPath]];
//    
//    for (NSString *string in arrayVedios) {
//         = [ReusedMethods generateThumbImage:[[SMSharedFilesClass profileVideosPath] stringByAppendingPathComponent:string]];
//        
//        //        NSLog(@"Image : %@", _thumb);
//    }
//}

+ (void) removeFileFromLocalAtIndex:(NSIndexPath *) indexpath andMediaType:(MediaType) mediaType {
    
    NSArray *  objects ;
    NSArray *  serverObjects ;
    NSString *path;
    BOOL server = NO;
    if(mediaType == imageType){
        path = [self profileTempImagesPath];
        objects = [self allFilesAtPath:path];
        if(![objects count]){
            path = [self profileImagesPath];
            objects = [self allFilesAtPath:path];
            server = YES;
        }
        else{
            serverObjects = [self allFilesAtPath:[self profileImagesPath]];
        }
    }
    if(mediaType == videoType){
        path = [self profileTempVideosPath];
        objects = [self allFilesAtPath:path];
        if(![objects count]){
            path = [self profileVideosPath];
            objects = [self allFilesAtPath:path];
            server = YES;
            serverObjects = objects;
        }
        else{
            serverObjects = [self allFilesAtPath:[self profileVideosPath]];
        }
    }
    
    if(mediaType == resumeType){
        path = [self profileTempResumePath];
        objects = [self allFilesAtPath:path];
        if(![objects count]){
            path = [self profileResumePath];
            objects = [self allFilesAtPath:path];
            server = YES;
            serverObjects = objects;
        }
        else{
            serverObjects = [self allFilesAtPath:[self profileResumePath]];
        }
    }
    if(mediaType == recommendationType){
        path = [self profileTempRecommendationLettersPath];
        objects = [self allFilesAtPath:path];
        if(![objects count]){
            path = [self profilePRecommendationLettersPath];
            objects = [self allFilesAtPath:path];
            server = YES;
            serverObjects = objects;
        }
        else{
            serverObjects = [self allFilesAtPath:[self profilePRecommendationLettersPath]];
        }
    }
    if(mediaType == videoThumbnailType){
        path = [self profileTempVideoThumbNailPath];
        objects = [self allFilesAtPath:path];
        if(![objects count]){
            path = [self profileVideoThumbNailPath];
            objects = [self allFilesAtPath:path];
            server = YES;
            serverObjects = objects;
        }
        else{
            serverObjects = [self allFilesAtPath:[self profileVideoThumbNailPath]];
        }
    }

    
    
    NSString *filePath;
    
    if([objects count]){
        int row = indexpath.row;
        if(!server){
            row -= serverObjects.count;
        }
        filePath = [path stringByAppendingPathComponent:[objects objectAtIndex:row]];
    }
    
    if(!filePath)
        return;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // NSString *filePath = [rootPath stringByAppendingPathComponent:name];
    NSError *error = nil;
    if([fileManager fileExistsAtPath:filePath])
        [fileManager removeItemAtPath:filePath error:&error];
    if(error){
        NSLog(@"Error removing file at Path : %@", filePath);
    }
    else
        NSLog(@"File removed at Path : %@", filePath);
}


+ (void) removeAllFilesFromLocal{
    [self removeFilesAtPath:[self profileImagesPath]];
    [self removeFilesAtPath:[self profileTempImagesPath]];
    
    [self removeFilesAtPath:[self profilePicturePath]];
    [self removeFilesAtPath:[self profileTempPicturePath]];
    
    [self removeFilesAtPath:[self profileVideosPath]];
    [self removeFilesAtPath:[self profileTempVideosPath]];
    
    [self removeFilesAtPath:[self profileResumePath]];
    [self removeFilesAtPath:[self profileTempResumePath]];
    
    [self removeFilesAtPath:[self profilePRecommendationLettersPath]];
    [self removeFilesAtPath:[self profileTempRecommendationLettersPath]];
    
    [self removeFilesAtPath:[self profileVideoThumbNailPath]];
    [self removeFilesAtPath:[self profileTempVideoThumbNailPath]];
    
    
}

+ (void) removeFilesAtPath:(NSString *) rootPath{
    NSArray *arrayImages = [self allFilesAtPath:rootPath];
    for (NSString *name in arrayImages) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePath = [rootPath stringByAppendingPathComponent:name];
        NSError *error = nil;
        if([fileManager fileExistsAtPath:filePath])
            [fileManager removeItemAtPath:filePath error:&error];
        if(error){
            NSLog(@"Error removing file at Path : %@", filePath);
        }
        else
            NSLog(@"File removed at Path : %@", filePath);
    }
}

+ (void) removeUncecceryFiles{
    [self removeLocalFiles:[SMSharedFilesClass profileImagesPath] withKey:@"image"];
    [self removeLocalFiles:[SMSharedFilesClass profileVideosPath] withKey:@"video"];
    [self removeLocalFiles:[SMSharedFilesClass profileResumePath] withKey:@"resume"];
    [self removeLocalFiles:[SMSharedFilesClass profilePicturePath] withKey:@"profile"];
    [self removeLocalFiles:[SMSharedFilesClass profilePRecommendationLettersPath] withKey:@"recomendationLettrs"];
    [self removeLocalFiles:[SMSharedFilesClass profileVideoThumbNailPath] withKey:@"videoThumbnail"];
}

+ (void) removeLocalFiles:(NSString *) path withKey:(NSString *)key{
    NSArray *files = [SMSharedFilesClass allFilesAtPath:path];
    NSArray *array = [[ReusedMethods userProfile] objectForKey:key];
    
    for (NSString *imageName in files) {
        if([array isKindOfClass:[NSArray class]]){
            if(![array containsObject:imageName]){
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSString *filePath = [path stringByAppendingPathComponent:imageName];
                NSError *error = nil;
                if([fileManager fileExistsAtPath:filePath])
                    [fileManager removeItemAtPath:filePath error:&error];
                if(error){
                    NSLog(@"Error removing file at Path : %@", filePath);
                }
                else
                    NSLog(@"File removed at Path : %@", filePath);
            }
        }
        else{
            if(![(NSString *)array isEqualToString:imageName]){
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSString *filePath = [path stringByAppendingPathComponent:imageName];
                NSError *error = nil;
                if([fileManager fileExistsAtPath:filePath])
                    [fileManager removeItemAtPath:filePath error:&error];
                if(error){
                    NSLog(@"Error removing file at Path : %@", filePath);
                }
                else
                    NSLog(@"File removed at Path : %@", filePath);
            }
        }
    }
}

@end
