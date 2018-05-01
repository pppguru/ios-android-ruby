//
//  SMAddProfileFourthVCModel.h
//  SwissMonkey
//
//  Created by Prasad on 2/22/16.
//  Copyright © 2016 rapidBizApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol smAddProfileFourthVCModelDelegate <NSObject>


- (void)deleteSelectedImage;
- (void)displaySelectedVideo:(id) selectedVideo;
- (void)deleteSelectedVideo;
- (void)deleteSelectedResume;
- (void)deleteSelectedRecommendation;
@end
@interface SMAddProfileFourthVCModel : NSObject
@property  (nonatomic, retain)  id<smAddProfileFourthVCModelDelegate> delegate;
@property  (nonatomic, retain)  NSArray *  profileImagesArray , * profileVideosArray;
@property  (nonatomic, retain) NSIndexPath * selectedDeleteObjectIndexPath;
@property  (nonatomic, retain)     NSMutableDictionary *textFieldsData;

#pragma mark - Compensation Preferences Dropdown Handler

- (void)openCompensationPreferences:(UITextField*)textField;

#pragma mark - TEXTFIELD DELEGTE METHODS

- (BOOL) textFieldShouldReturn:(UITextField *)textField;
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField;
- (void) textFieldDidEndEditing:(UITextField *)textField;
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

- (void)setUPThumbNailsOnView:(UIView *)bgView ofCount:(int) count;
- (void) displayThumbNailsImagesOnView:(UIView *) BGView;
    



-(void)createExpandableView;


@end
