//
//  SMJobProfileDescriptionModel.m
//  SwissMonkey
//
//  Created by Kasturi on 1/28/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "SMJobProfileDescriptionModel.h"
#import "JobInfoDescriptionCell.h"
#import "AboutPracticeInfoCell.h"
#import "PracticeDescriptionCell.h"
#import "PracticePhotosCell.h"
#import "JobPhotosCollectionViewCell.h"
#import "PracticeInfoHeaderView.h"
#import "VideoDisplayHeaderView.h"

@implementation SMJobProfileDescriptionModel{
    
    JobInfoDescriptionCell  *  jobInfoDescCell;
    AboutPracticeInfoCell *  aboutPracticeInfoCell;
    PracticeDescriptionCell *  practiceDescriptionCell;
    PracticePhotosCell *  practicePhotoCell;
    
    UIView * expandableView;
    UIImageView * expandableImageView;
    UIButton * leftButton,*rightButton;
    int photoIndex;
    NSArray * displayImagesArray;
    PracticeInfoHeaderView *header;
}

- (id) init{
  self =  [super init];
    
    if(self){
        
        UINib *customNib = [UINib nibWithNibName:@"PracticeDescriptionCustomView" bundle:nil];
        header = [[customNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    }
    return self;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //[ReusedMethods setSeperatorProperlyForCell:cell];
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  [tableView tag]  == 620 ? 4 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([tableView tag] == 620){
        
        NSString *  cellIdendifier  =  [NSString  stringWithFormat:@"JobInfoDescriptionCell"];
        
        jobInfoDescCell =  [tableView dequeueReusableCellWithIdentifier:cellIdendifier];
       // [jobInfoDescCell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        if(!jobInfoDescCell){
            
            jobInfoDescCell  =  [[JobInfoDescriptionCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdendifier frameWidth:tableView.frame.size.width];
        }
        
        jobInfoDescCell.selectionStyle  =  UITableViewCellSelectionStyleNone;
        [jobInfoDescCell setupCellDataforIndex:indexPath andJobDetails:_jobDetails];
        return jobInfoDescCell;
    }else{
        
        // [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        if(indexPath.row  == 0){
            NSString *  cellIdendifier  =  [NSString  stringWithFormat:@"AboutPracticeInfoCell"];
            
            aboutPracticeInfoCell =  [tableView dequeueReusableCellWithIdentifier:cellIdendifier];
            if(!aboutPracticeInfoCell){
                
                [tableView  registerNib:[UINib nibWithNibName:@"AboutPracticeInfoCell" bundle:nil] forCellReuseIdentifier:cellIdendifier];
                aboutPracticeInfoCell =  [tableView dequeueReusableCellWithIdentifier:cellIdendifier];
            }
            aboutPracticeInfoCell.selectionStyle  =  UITableViewCellSelectionStyleNone;
            return aboutPracticeInfoCell;
        }
        else if(indexPath.row == 2){
            NSString *  cellIdendifier  =  [NSString  stringWithFormat:@"PracticePhotosCell"];
            
            practicePhotoCell =  [tableView dequeueReusableCellWithIdentifier:cellIdendifier];
//            if(!practicePhotoCell){
//                //[tableView  registerNib:[UINib nibWithNibName:@"PracticeDescriptionCustomcell" bundle:nil] forCellReuseIdentifier:cellIdendifier];
//                practicePhotoCell  =  [tableView dequeueReusableCellWithIdentifier:cellIdendifier];;
//            }
            practicePhotoCell.selectionStyle  =  UITableViewCellSelectionStyleNone;
            return practicePhotoCell;
        }
        else {
            NSString *  cellIdendifier  =  [NSString  stringWithFormat:@"PracticeDescriptionCell"];
            practiceDescriptionCell =  [tableView dequeueReusableCellWithIdentifier:cellIdendifier];
            if(!practiceDescriptionCell){
                [tableView  registerNib:[UINib nibWithNibName:@"PracticeDescriptionCustomcell" bundle:nil] forCellReuseIdentifier:cellIdendifier];
                practiceDescriptionCell  =  [tableView dequeueReusableCellWithIdentifier:cellIdendifier];
            }
            practiceDescriptionCell.selectionStyle  =  UITableViewCellSelectionStyleNone;
            return practiceDescriptionCell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float  height = 0;
    if([tableView tag] == 620){
        return tableView.estimatedRowHeight;
    }
    else{
        if(indexPath.row  == 0){
            NSString *  cellIdendifier  =  [NSString  stringWithFormat:@"AboutPracticeInfoCell"];
            aboutPracticeInfoCell =  [tableView dequeueReusableCellWithIdentifier:cellIdendifier];
            if(!aboutPracticeInfoCell){
                [tableView  registerNib:[UINib nibWithNibName:@"AboutPracticeInfoCell" bundle:nil] forCellReuseIdentifier:cellIdendifier];
                aboutPracticeInfoCell =  [tableView dequeueReusableCellWithIdentifier:cellIdendifier];
            }
            @try {
                // [aboutPracticeInfoCell setupCellDataforIndex:indexPath];
                [aboutPracticeInfoCell layoutIfNeeded];
                height  =  [aboutPracticeInfoCell.contentView   systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
                height  =  MAX(height, CGRectGetMaxY(aboutPracticeInfoCell.benefitsTitleLabel.frame) + 5);
            }
            @catch (NSException *exception) {
                
                return 100;
            }
            return  MAX(height, 50);
        }
        else if(indexPath.row == 1){
            NSString *  cellIdendifier  =  [NSString  stringWithFormat:@"PracticeDescriptionCell"];
            practiceDescriptionCell =  [tableView dequeueReusableCellWithIdentifier:cellIdendifier];
            if(!practiceDescriptionCell){
                [tableView  registerNib:[UINib nibWithNibName:@"PracticeDescriptionCustomcell" bundle:nil] forCellReuseIdentifier:cellIdendifier];
                practiceDescriptionCell  =  [tableView dequeueReusableCellWithIdentifier:cellIdendifier];
            }
            @try {
                // [aboutPracticeInfoCell setupCellDataforIndex:indexPath];
                [practiceDescriptionCell layoutIfNeeded];
                height  =  [practiceDescriptionCell.contentView   systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
                height  =  MAX(height, CGRectGetMaxY(practiceDescriptionCell.ProfileDescriptionLabel.frame));
            }
            @catch (NSException *exception) {
                
                return 50;
            }
            return  MAX(height, 50);
        }
        else if(indexPath.row  ==  2){
            NSString *  cellIdendifier  =  [NSString  stringWithFormat:@"PracticePhotosCell"];
            practicePhotoCell =  [tableView dequeueReusableCellWithIdentifier:cellIdendifier];
            if(!practicePhotoCell){
                //[tableView  registerNib:[UINib nibWithNibName:@"PracticeDescriptionCustomcell" bundle:nil] forCellReuseIdentifier:cellIdendifier];
                practicePhotoCell  =  [tableView dequeueReusableCellWithIdentifier:cellIdendifier];;
            }
            @try {
                // [aboutPracticeInfoCell setupCellDataforIndex:indexPath];
                [practicePhotoCell layoutIfNeeded];
                height  =  [practicePhotoCell.contentView   systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
                height  =  MAX(height, CGRectGetMaxY(practicePhotoCell.photosCollectionView.frame) + 5);
            }
            @catch (NSException *exception) {
                return 50;
            }
            return  MAX(height, 50);
        }
    }
}


#pragma mark - COLLECTION VIEW  DELEGATE METHODS

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
     return (section == 0) ? [[_jobDetails objectForKey:@"practicephotos"] count] == 0 ? 1: [[_jobDetails objectForKey:@"practicephotos"] count] : 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JobPhotosCollectionViewCell *jobPhotosCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JobPhotosCollectionViewCell"
                                                                                           forIndexPath:indexPath];
    
    if(indexPath.section  == 0){
        NSString *anonymous = [_jobDetails valueForKey:@"company_name"];
        if ([anonymous isEqualToString:ANONYMOUS]) {
            return  [self displayNoItemsFoundMessage:@"" onCell:jobPhotosCell];
        }else{
            if([[_jobDetails objectForKey:@"practicephotos"] count] == 0){
                return  [self displayNoItemsFoundMessage:@"No Photos to display" onCell:jobPhotosCell];
            }
            
            //        [collectionView registerNib:[UINib nibWithNibName:@"PracticeDescriptionCustomView" bundle:nil]
            //         forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
            //                withReuseIdentifier:@"PracticeInfoHeaderView"];
            [jobPhotosCell setImageAtIndex:indexPath FromImagesArray:[_jobDetails objectForKey:@"practicephotos"]];
        }
    }else{
        NSString *anonymous = [_jobDetails valueForKey:@"company_name"];
        if ([anonymous isEqualToString:ANONYMOUS]) {
            return  [self displayNoItemsFoundMessage:@"" onCell:jobPhotosCell];
        }else{
            NSString *  urlString  = [_jobDetails objectForKey:@"video_link"];
            if(urlString.length == 0){
                return  [self displayNoItemsFoundMessage:@"No video to display" onCell:jobPhotosCell];
            }
            
            [collectionView registerNib:[UINib nibWithNibName:@"VideoDisplayHeaderView" bundle:nil]
             forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                    withReuseIdentifier:@"VideoDisplayHeaderView"];
            NSString * youtubeID = [ReusedMethods getVideoIdFromLink:urlString];
            
            if(youtubeID == nil){
                //[[[RBACustomAlert alloc]initWithTitle:APP_TITLE message:@"Video link not valid" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
                
                return jobPhotosCell;
            }
            
            NSURL * url  = [NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",youtubeID]];
            NSURLRequest *request  =  [NSURLRequest requestWithURL:url];
            
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [spinner setCenter:jobPhotosCell.center];
            [jobPhotosCell.photoImgView addSubview:spinner];
            [jobPhotosCell.photoImgView setImage:nil];
            [jobPhotosCell.photoImgView setBackgroundColor:[UIColor blackColor]];
            [spinner startAnimating];
            
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       if (!error) {
                                           jobPhotosCell.photoImgView.image = [UIImage imageWithData:data];
                                           [jobPhotosCell.photoImgView setContentMode:UIViewContentModeScaleAspectFit];
                                       } else {
                                           NSLog(@"error  descripyion :%@",error);
                                       }
                                       [spinner stopAnimating];
                                   }];
        }
    }
    return jobPhotosCell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    PracticeInfoHeaderView *reusableview = nil;
    VideoDisplayHeaderView * reusableView2  = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        if(indexPath.section  ==  0){
            reusableview = [PracticeInfoHeaderView collectionReusableViewForCollectionView:collectionView forIndexPath:indexPath withKind:kind];
            [reusableview getHeaderHeightWithJobDetails:_jobDetails];
            return reusableview;
        }
        if(indexPath.section  ==  1){
            reusableView2 = [VideoDisplayHeaderView collectionReusableViewForCollectionView:collectionView forIndexPath:indexPath withKind:kind];
            return reusableView2;
        }

    }
   // [reusableview setupHeaderDataWithJobDetails:_jobDetails];
    return reusableview;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if(section == 0){
//    PracticeInfoHeaderView *header = nil;
//    UINib *customNib = [UINib nibWithNibName:@"PracticeDescriptionCustomView" bundle:nil];
//    header = [[customNib instantiateWithOwner:self options:nil] objectAtIndex:0];
    CGSize headerSize  =  [header getHeaderHeightWithJobDetails:_jobDetails];
    return CGSizeMake(headerSize.width, headerSize.height);
    }else{
        NSString *anonymous = [_jobDetails valueForKey:@"company_name"];
        if ([anonymous isEqualToString:ANONYMOUS]) {
            return CGSizeZero;
        }
        VideoDisplayHeaderView *videoheader = nil;
        UINib *customNib = [UINib nibWithNibName:@"VideoDisplayHeaderView" bundle:nil];
        videoheader = [[customNib instantiateWithOwner:self options:nil] objectAtIndex:0];
        return CGSizeMake(videoheader.frame.size.width, 40);
 
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section  == 0){
    photoIndex  = (int) indexPath.row;
    displayImagesArray  = [_jobDetails objectForKey:@"practicephotos"];
    [self addExapandableView];
    }else{
        
        NSString *  urlString  = [_jobDetails objectForKey:@"video_link"];
        
        NSString * youtubeID = [ReusedMethods getVideoIdFromLink:urlString];
        
        if(youtubeID == nil){
            [[[RBACustomAlert alloc]initWithTitle:APP_TITLE message:@"Video link not valid" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
            
            return ;
        }

        
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_jobDetails objectForKey:@"video_link"]]]];
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if([[_jobDetails objectForKey:@"practicephotos"] count] == 0 && indexPath.section  == 0){
        return CGSizeMake ((CGRectGetWidth(collectionView.frame)/3) - 10, 50);

    }
    if([[_jobDetails objectForKey:@"video_link"] length] == 0 && indexPath.section  == 1){
        return CGSizeMake ((CGRectGetWidth(collectionView.frame)/3) - 10, 50);
        
    }
    return CGSizeMake ((CGRectGetWidth(collectionView.frame)/3) - 10, (CGRectGetWidth(collectionView.frame)/3) - 10);
}


- (void) applyJob{
    APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_APPLY ModuleName:MODULE_JOBS MethodType:METHOD_TYPE_POST Parameters:[NSMutableDictionary dictionaryWithObject:[_jobDetails objectForKey:@"job_id"] forKey:@"jobID"] SuccessCallBack:@selector(applyApiCallSuccess:) AndFailureCallBack:@selector(applyApiCallFailed:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
    [service makeWebServiceCall];
}

- (void) applyApiCallSuccess:(WebServiceCalls *)server{
    [[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:[server.responseData objectForKey:@"success"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

- (void) applyApiCallFailed:(WebServiceCalls *)serverError{
    
    NSString * errmsg;
    if(serverError.responseError){
        errmsg =[[serverError responseError].userInfo objectForKey:@"NSLocalizedDescriptionKey"];
    }else{
        if ([[[serverError responseData] objectForKey:@"error"] length]) {
            errmsg = [[serverError responseData] objectForKey:@"error"];
            
        }
    }
    
    RBACustomAlert  * alert  =  [[RBACustomAlert alloc] initWithTitle:APP_TITLE message:errmsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}

#pragma mark - EXPANDABLE VIEW FOR IMAGES DISPLAY RELATED METHODS

-(void)createExpandableView
{
    float screenWidth  = [[UIScreen mainScreen] bounds].size.width;
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    expandableView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    expandableView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.9];
    // [self.view addSubview:expandableView];
    
    // Adding UIImageView
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60, screenWidth - 20, screenWidth - 20)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.center = expandableView.center;
    imageView.layer.cornerRadius = 15.0f;
    imageView.layer.masksToBounds = YES;
    
    [expandableView addSubview:imageView];
    
    expandableImageView  = imageView;
    
    // Adding Left and Right Buttons
    leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (imageView.center.y)-75 , 60, 150)];
    [leftButton setImage:[UIImage imageNamed:@"leftarrow"] forState:UIControlStateNormal];
    [leftButton setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.1]];
    [leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    // [expandableView addSubview:leftButton];
    
    rightButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 60, (imageView.center.y)-75, 60, 150)];
    [rightButton setImage:[UIImage imageNamed:@"rightarrow"] forState:UIControlStateNormal];
    [rightButton setBackgroundColor: [UIColor colorWithWhite:0.9 alpha:0.1]];
    [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    //[expandableView addSubview:rightButton];
    
    // Close button
    UIButton * closeButton = [[UIButton alloc] initWithFrame:CGRectMake(expandableView.frame.size.width - 60,30, 50, 50)];
    [closeButton setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeExpandableView) forControlEvents:UIControlEventTouchUpInside];
    [expandableView addSubview:closeButton];
    
    
    // add swipe  gesture  for  expandable  view
    
    UISwipeGestureRecognizer *swipeLeftToRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipePreviousAction:)];
    [swipeLeftToRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [expandableView addGestureRecognizer:swipeLeftToRight];
    UISwipeGestureRecognizer *swipeRightToLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeNextAction:)];
    [swipeRightToLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [expandableView addGestureRecognizer:swipeRightToLeft];
    
}

-(void)closeExpandableView
{
    [expandableView removeFromSuperview];
}

-(void)leftButtonAction
{
    photoIndex--;
    [self loadExpandablemage];
    [self swipeAnimationExpandableImageView:kCATransitionFromLeft];
    
}

-(void)rightButtonAction
{
    photoIndex++;
    [self loadExpandablemage];
    [self swipeAnimationExpandableImageView:kCATransitionFromRight];
}

# pragma  mark  - SWIPE  GESTURE  METHODS

- (void) swipePreviousAction:(UISwipeGestureRecognizer*)sender{
    
    // dont execute  if  the  photo index  0 //  will crash
    if(photoIndex != 0){
        photoIndex--;
        [self loadExpandablemage];
        [self swipeAnimationExpandableImageView:kCATransitionFromLeft];
    }
}

-(void)swipeNextAction:(UISwipeGestureRecognizer*)sender{
    
    //  if photo reaches  count  dont allow  to increse
    if(photoIndex < (displayImagesArray.count -  1)){
        photoIndex++;
        [self loadExpandablemage];
        [self swipeAnimationExpandableImageView:kCATransitionFromRight];
    }
    
}


-(void)addExapandableView
{
    UIWindow *  window  =  [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:expandableView];
    //photoIndex = 0;
    if (displayImagesArray.count == 1)
    {
        leftButton.hidden = YES;
        rightButton.hidden = YES;
    }
    else
    {
        leftButton.hidden = NO;
        rightButton.hidden = NO;
    }
    leftButton.hidden = YES;
    [self loadExpandablemage];
}

-(void)loadExpandablemage
{
    NSIndexPath  *  indexPath  =  [NSIndexPath indexPathForRow:photoIndex inSection:0];
    [self setImageInLarge];
    if (photoIndex == displayImagesArray.count-1)
    {
        rightButton.hidden = YES;
    }
    else
    {
        rightButton.hidden  = NO;
    }
    if (photoIndex == 0)
    {
        leftButton.hidden = YES;
    }
    else
    {
        leftButton.hidden = NO;
    }
}


-(void)swipeAnimationExpandableImageView:(NSString *)leftRight
{
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setDuration:0.5f];
    [animation setType:kCATransitionPush];
    animation.subtype = leftRight;
    [expandableImageView.layer addAnimation:animation forKey:NULL];
}

- (void)setImageInLarge{
    
        NSURL * url  =  [NSURL URLWithString:[displayImagesArray objectAtIndex:photoIndex]];
        NSURLRequest *request  =  [NSURLRequest requestWithURL:url];
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [expandableView addSubview:spinner];
        [spinner setCenter:expandableImageView.center];
        [expandableImageView setImage:nil];
        [expandableImageView setBackgroundColor:[UIColor blackColor]];
        [spinner startAnimating];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   if (!error) {
                                       expandableImageView.image = [UIImage imageWithData:data];
                                       [expandableImageView setContentMode:UIViewContentModeScaleAspectFit];
                                   } else {
                                       NSLog(@"error  descripyion :%@",error);
                                   }
                                   [spinner stopAnimating];
                               }];
    
    
    
    //photoImgView.image = [UIImage  imageNamed:@"home"];
}

//  DIsplaying  empty  cell data

- (JobPhotosCollectionViewCell *) displayNoItemsFoundMessage:(NSString *) message onCell:(JobPhotosCollectionViewCell *) jobPhotosCell  {
    
    CGRect  cellFrame = jobPhotosCell.frame;
    cellFrame.size.width  =  150;
    cellFrame.size.height  = 50;
    jobPhotosCell.frame  =  cellFrame;
    
    
    UILabel * footerSectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, CGRectGetWidth(jobPhotosCell.frame)- (2 * 5), 40)];
    [footerSectionTitle setBackgroundColor:[UIColor clearColor]];
    [footerSectionTitle setNumberOfLines:0];
    [footerSectionTitle setLineBreakMode:NSLineBreakByWordWrapping];
    [footerSectionTitle setTextAlignment:NSTextAlignmentLeft];
    [footerSectionTitle setTextColor:[UIColor appLightGrayColor]];
    [footerSectionTitle setFont:[UIFont appNormalTextFont]];
    [footerSectionTitle setText:message];
    [jobPhotosCell.contentView addSubview:footerSectionTitle];
    jobPhotosCell.backgroundColor = [UIColor clearColor];
    [jobPhotosCell.photoImgView removeFromSuperview];
    return jobPhotosCell;

}



@end
