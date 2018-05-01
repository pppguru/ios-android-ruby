//
//  SMSharedFilesClass.h
//  SwissMonkey
//
//  Created by Yadagiri Neeli on 24/02/16.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kMAXIMAGES 3
#define kMAXVIDEOS 3
#define kMAXPPICTURES 1
#define kMAXRESUMES 5  //=====UPLOAD5RESUMES===

#define kMAXLETTERSOFRECOMMENDATION 2
#define kMAXVIDEOTIME 3 * 60

@interface SMSharedFilesClass : NSObject

@property (nonatomic, readwrite) NSInteger dowloadImagesCount, uploadingCount;

+ (SMSharedFilesClass *) sharedFileObject;

+ (NSString *) profileImagesPath;
+ (NSString *) profileTempImagesPath;
+ (NSString *) profileVideosPath;
+ (NSString *) profileTempVideosPath;
+ (NSString *) profilePicturePath;
+ (NSString *) profileTempPicturePath;
+ (NSString *) profileResumePath;
+ (NSString *) profileTempResumePath;
+ (NSString *) profilePRecommendationLettersPath;
+ (NSString *) profileTempRecommendationLettersPath;
+ (NSString *) profileVideoThumbNailPath;
+ (NSString *) profileTempVideoThumbNailPath;

//+ (void) uploadAllLocalImagesToServer:(id) delegate;
//+ (void) uploadAllLocalVideosToServer:(id) delegate;
//+ (void) uploadAllLocalPPictureToServer:(id) delegate;
+ (void) uploadAllLocalFilesToServer:(id) delegate andMediaType:(MediaType) mediaType;

+ (NSInteger) filesCountAtPath:(NSString *)path;

+ (UIActionSheet *) actionSheetWithDelegate:(id) actDelegate;

+ (NSString *) keyForMedia:(MediaType) type;
+ (NSString *) tempPathForKey:(MediaType)mediaType;
+ (NSString *) tempFilesPathsForKey:(MediaType)mediaType;
+ (NSArray *) allFilesAtPath:(NSString *) path;

//+ (void)removeFileAtPath:(NSString *)filePath;

+ (NSInteger) allProfileImages;
+ (NSString *) saveImageAtDocumentoryPath:(id) content withName:(NSString *)name needExtension:(BOOL) need mediaType:(MediaType)mediaType;
+ (NSInteger)listFileAtPath:(NSString *)path;
+ (void) downloadImage:(NSString *)imageStrURL;
+ (void) downloadAllImagesAndVideos;

+ (void) setProfilePicture2Button:(id) profileButton;
+ (void) setProfileImagesOnView:(id) profileImageView atIndexPath:(NSIndexPath *) indexpath;
+ (void) setVideoImagesOnView:(id) profileImageView atIndexpath:(NSIndexPath *) indexPath;
+ (void) setResumeImagesOnView:(id) profileImageView atIndexPath:(NSIndexPath *) indexpath;
+ (void) setLetterOfRecommendationImagesOnView:(id) profileImageView atIndexPath:(NSIndexPath *) indexpath;


+ (void) removeAllObjectAtPath:(NSArray *)images type:(MediaType)mediaType;
+ (void) removeFileFromLocalAtIndex:(NSIndexPath *) indexpath andMediaType:(MediaType) mediaType;
+ (void) removeAllTempObjectAtPath:(NSArray *)images type:(MediaType)mediaType;


+ (void) setCorrespondingImagesOnView:(id) profileImageView atIndexPath:(NSIndexPath *) indexPath mediaType:(MediaType) mediaType;
+ (NSMutableDictionary *) getFilesArrayWithMediaType:(MediaType) mediaType;



//+ (NSMutableArray *) getProfileImagesArray;
//+ (NSArray *) getProfileVideosArray;
//+ (NSArray *) getProfileLettersOfRecommendatationsArray;
//+ (NSArray *) getProfileResumesArray;

//+ (NSMutableArray *) getProfileVideosArray;
//+ (NSMutableArray *) getLettersOfRecommendatationsArray;
//+ (NSMutableArray *) getResumesArray;



+ (void) removeAllFilesFromLocal;
+ (void) removeFilesDownloadingLabel;

+ (void) removeUncecceryFiles;
+ (BOOL) addSkipBackupAttributeToItemAtPath:(NSString *) filePathString;


@end
