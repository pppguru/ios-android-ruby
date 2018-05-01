//
//  SMUserProfileDescriptionModel.m
//  SwissMonkey
//
//  Created by Kasturi on 1/22/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "SMUserProfileDescriptionModel.h"

@implementation SMUserProfileDescriptionModel{
    NSMutableArray * tableViewArray;
    NSMutableDictionary  *  serverResponseDict;
    NSMutableArray * fileContentsArray;
    MediaType  mediaType;
    
}
@synthesize profileVideosArray,profileImagesArray, profileResumesArray, profileRecomendationsArray;
- (id)  init{
    
    if(self){
        
        self  =  [super init];
        tableViewArray  =  [[NSMutableArray alloc] initWithObjects: @"xxxx",@"xxxx",@"xxxx",@"xxxx",@"xxxx",@"xxxx", nil];
        serverResponseDict  =  [[NSMutableDictionary  alloc]  init];
        fileContentsArray = [[NSMutableArray alloc] init];
        
        //Getting the urls from profile info dictionary instead of ID.
        profileImagesArray  =  [[ReusedMethods userProfile] valueForKey:@"image_url"];//[SMSharedFilesClass getProfileImagesArray];
        profileVideosArray  =  [[ReusedMethods userProfile] valueForKey:@"video_url"];//[SMSharedFilesClass  getProfileVideosArray];
        profileResumesArray  =  [[ReusedMethods userProfile] valueForKey:@"resume_url"];//[SMSharedFilesClass  getProfileResumesArray];
        profileRecomendationsArray = [[ReusedMethods userProfile] valueForKey:@"recomendationLettrs_url"];//[SMSharedFilesClass getProfileLettersOfRecommendatationsArray];
    }
    return self;
    
    
}


-(void) callProfileDataAPICall
{
    APIObject * reqObject = [[APIObject alloc] initWithMethodName:METHOD_INFO ModuleName:MODULE_PROFILE MethodType:METHOD_TYPE_POST Parameters:nil SuccessCallBack:@selector(successAPICall:) AndFailureCallBack:@selector(failedAPICall:)];
    
    WebServiceCalls *service = [[WebServiceCalls alloc] initWebServiceCallWithAPIRequest:reqObject withDelegate:self];
    [service makeWebServiceCall];
}

#pragma mark - PROFILE DATA  SUCCESS  CALL BACK  METHODS

-(void) successAPICall:(WebServiceCalls *)service
{
    [serverResponseDict addEntriesFromDictionary:service.responseData];
    [ReusedMethods setUserProfile:service.responseData];
    [[ReusedMethods sharedObject] setUserProfileInfo:[NSMutableDictionary dictionaryWithDictionary:service.responseData]];
    [_delegate successResponseCall:service];
}

-(void) failedAPICall:(NSError *)error
{
    @try {
        if([error isKindOfClass:[NSError class]])
            [_delegate showErrorMessages:[error.userInfo objectForKey:@"NSLocalizedDescriptionKey"]];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}



//Changes in Hilight Colors for Buttons according to the selected one.
-(void)setHilightedColorForButton:(UIButton *)button
{
    if(button.highlighted)
    {
        button.backgroundColor =  [UIColor colorWithRed:100/255.0f green:80/255.0f blue:137/255.0f alpha:1];
    }
    else
    {
        button.backgroundColor = [UIColor clearColor];
    }
}

# pragma mark ----- UITableview Delegate And Datasource methods --------

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [ReusedMethods setSeperatorProperlyForCell:cell];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //  return 4; //To view resumes and resomendation letters on 3,4 rows
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 1) {
        
        
        NSString *cellIdentifier = [NSString stringWithFormat:@"UserProfileDescriptionCell"];
        
        UserProfileDescriptionCell  * cell  =  [tableView  dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil){
            
            cell  =  [[UserProfileDescriptionCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier frameWidth:tableView.frame.size.width];
        }
        
        // Selection indicator removing.
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        
        //Cell configure
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];

        [cell setUpCellData:serverResponseDict onindexpath:indexPath];
        [cell adjustCellFrames];
        return cell;
    }
    else{
        NSString *cellIdentifier = [NSString stringWithFormat:@"UserProfileFilesListCell"];
        
        UserProfileFilesListCell  * cell  =  [tableView  dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil){
            
            cell  =  [[UserProfileFilesListCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier frameWidth:tableView.frame.size.width];
        }
        
        // Selection indicator removing.
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        
        //Cell configure
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        
        NSString * buttonTitleString =  indexPath.row == 2 ? @"View Resume" : @"Letters of Recommendations";
        // asaign values  to  contents
        cell.fileTitleLabel.text  = buttonTitleString;
        [cell.fileIcon setTag:indexPath.row];
        [cell.fileIcon addTarget:self action:@selector(displayCorrespondingImages:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.fileIcon setBackgroundColor:[UIColor redColor]];
        [cell. transparentButton addTarget:self action:@selector(displayCorrespondingImages:) forControlEvents:UIControlEventTouchUpInside];
        
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 1) {
        NSString *cellIdentifier = [NSString stringWithFormat:@"UserProfileDescriptionCell"];
        UserProfileDescriptionCell  * cell  =  [tableView  dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil){
            cell  =  [[UserProfileDescriptionCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier frameWidth:tableView.frame.size.width];
        }
    @try {
        float cellHeight ;
            cellHeight  =  [cell getCellHeight:serverResponseDict onIndexPath:indexPath];
        return cellHeight;
    }
    @catch (NSException *exception) {
        return 80;
    }
    }else{
        return 50;
    }
}

#pragma mark -  COLECTION VIEW  METHODS
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    NSString *path = [SMSharedFilesClass profileTempImagesPath];
//    NSArray *images = [SMSharedFilesClass allFilesAtPath:path];
//    if(![images count]){
//        path = [SMSharedFilesClass profileImagesPath];
//        images = [SMSharedFilesClass allFilesAtPath:path];
//    }
//    return images.count;
//    if(section == 0)
//        return self.profileImagesArray.count;
//    else if (section == 1)
//         return self.profileVideosArray.count;
//    else if (section == 2)
//         return self.profileResumesArray.count;
//    else 
//        return self.profileRecomendationsArray.count;

    //Getting the urls from profile info dictionary instead of ID.
    if(section == 0)
        return [[[ReusedMethods userProfile] valueForKey:@"image_url"] count];
    else if (section == 1)
        return [[[ReusedMethods userProfile] valueForKey:@"video_url"] count];
    else if (section == 2)
        return [[[ReusedMethods userProfile] valueForKey:@"resume_url"] count];
    else
        return [[[ReusedMethods userProfile] valueForKey:@"recomendationLettrs_url"] count];
    
    
    
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotosCollectionViewCell" forIndexPath:indexPath];
    
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.backgroundColor=[UIColor clearColor];
    
    UIImageView *photosImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (CGRectGetWidth(collectionView.frame)/3) - 10, (CGRectGetWidth(collectionView.frame)/3) - 10)];
    
    [cell.contentView addSubview:photosImageView];
    
    if(indexPath.section == 0)
    {
        [SMSharedFilesClass setProfileImagesOnView:photosImageView atIndexPath:indexPath];
    }
    else if (indexPath.section == 1)
    {
        //Calling the updating the video thumb nail image on button on backgraound.
        NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[photosImageView, indexPath] forKeys:@[@"View",@"Index"]];
        [self performSelectorInBackground:@selector(threadSampleWithDictionary:) withObject:dict];
        //[SMSharedFilesClass setVideoImagesOnView:photosImageView atIndexpath:indexPath];
    }
    else  if(indexPath.section == 2)
    {
        [SMSharedFilesClass setResumeImagesOnView:photosImageView atIndexPath:indexPath];
    }
    else  if(indexPath.section == 3)
    {
        [SMSharedFilesClass setLetterOfRecommendationImagesOnView:photosImageView atIndexPath:indexPath];
    }
    
    [photosImageView setContentMode:UIViewContentModeScaleAspectFill];
    photosImageView.layer.borderWidth = 0.5f;
    photosImageView.layer.borderColor = [[UIColor appGrayColor] CGColor];
    photosImageView.layer.cornerRadius = 5;
    photosImageView.layer.masksToBounds = YES;
    
    return cell;
    
}

-(void)threadSampleWithDictionary:(NSDictionary *)dict
{
    id photosImageView = [dict valueForKey:@"View"];
    NSIndexPath *indexPath = [dict valueForKey:@"Index"];
    [SMSharedFilesClass setVideoImagesOnView:photosImageView atIndexpath:indexPath];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake ((CGRectGetWidth(collectionView.frame)/3) - 10, (CGRectGetWidth(collectionView.frame)/3) - 10);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor clearColor];
        
        for (UIView *prevSubview in headerView.subviews)
        {
            //To remove the over written heate title labels
            [prevSubview removeFromSuperview];
        }
        
        float xposSecTitle = 5;
        float yPosSecTitle = 20;
        float  lblWidth  = CGRectGetWidth(collectionView.frame)  -  (2 * xposSecTitle) ;
        
        if(indexPath.section == 0)
        {
            header_TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xposSecTitle, yPosSecTitle, lblWidth, 30)];
            [header_TitleLabel setBackgroundColor:[UIColor clearColor]];
            [header_TitleLabel setNumberOfLines:0];
            [header_TitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
            [header_TitleLabel setTextAlignment:NSTextAlignmentCenter];
            [header_TitleLabel setTextColor:[UIColor appCustomPurpleColor]];
            [header_TitleLabel setFont:[UIFont appLatoBlackFont20]];
            [headerView  addSubview:header_TitleLabel];
            
            header_TitleLabel.text = @"Bio";
            
            yPosSecTitle = CGRectGetMaxY(header_TitleLabel.frame) + 10;
            
            
            header_subTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(xposSecTitle, yPosSecTitle, lblWidth, CGRectGetHeight(headerView.frame) - CGRectGetHeight(header_TitleLabel.frame) )];
            [header_subTitleLable setBackgroundColor:[UIColor clearColor]];
            [header_subTitleLable setNumberOfLines:0];
            [header_subTitleLable setLineBreakMode:NSLineBreakByWordWrapping];
            [header_subTitleLable setTextAlignment:NSTextAlignmentCenter];
            [header_subTitleLable setTextColor:[UIColor darkGrayColor]];
            [header_subTitleLable setFont:[UIFont appLatoLightFont15]];
            [headerView  addSubview:header_subTitleLable];
            
            header_subTitleLable.text  =  [serverResponseDict objectForKey:ABOUTME];
            [header_TitleLabel resizeToFit];
            [header_subTitleLable  resizeToFit];
            
            yPosSecTitle = CGRectGetMaxY(header_subTitleLable.frame) + 10;
            
            
//            seperaterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yPosSecTitle, CGRectGetWidth(collectionView.frame), 1 )];
//            seperaterLabel.backgroundColor = [UIColor appLightGrayColor];
//            [headerView addSubview:seperaterLabel];
//            yPosSecTitle  =  CGRectGetMaxY(seperaterLabel.frame) + 5;
            
            
        }
        
        
        
        sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(xposSecTitle, yPosSecTitle, CGRectGetWidth(headerView.frame), 20)];
        [sectionTitle setBackgroundColor:[UIColor clearColor]];
        [sectionTitle setNumberOfLines:0];
        [sectionTitle setLineBreakMode:NSLineBreakByWordWrapping];
        [sectionTitle setTextAlignment:NSTextAlignmentCenter];
        [sectionTitle setTextColor:[UIColor appCustomPurpleColor]];
        [sectionTitle setFont:[UIFont appLatoBlackFont20]];
        [headerView  addSubview:sectionTitle];
        
        if(indexPath.section == 0)
            sectionTitle.text = @"Photos";
        else  if(indexPath.section == 1)
            sectionTitle.text = @"Videos";
        else  if(indexPath.section == 2)
            sectionTitle.text = @"Resumes";
        else  if(indexPath.section == 3)
            sectionTitle.text = @"Letters of recommendations";
        
        
        reusableview = headerView;
    }
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor clearColor];
        
        for (UIView *prevSubview in footerView.subviews)
        {
            //To remove the over written heate title labels
            [prevSubview removeFromSuperview];
        }
        
        float xposSecTitle = 5;
        float yPosSecTitle = 5;
        float  lblWidth  = CGRectGetWidth(collectionView.frame)  -  (2 * xposSecTitle) ;
        
        UILabel * footerSectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(xposSecTitle, yPosSecTitle, CGRectGetWidth(footerView.frame), 30)];
        [footerSectionTitle setBackgroundColor:[UIColor clearColor]];
        [footerSectionTitle setNumberOfLines:0];
        [footerSectionTitle setLineBreakMode:NSLineBreakByWordWrapping];
        [footerSectionTitle setTextAlignment:NSTextAlignmentCenter];
        [footerSectionTitle setTextColor:[UIColor darkGrayColor]];
        [footerSectionTitle setFont:[UIFont appLatoLightFont15]];
        [footerView  addSubview:footerSectionTitle];
        
//        if(indexPath.section == 0 && [SMSharedFilesClass getProfileImagesArray].count == 0)
//            footerSectionTitle.text = @"No photos to display";
//        else  if(indexPath.section == 1 && [SMSharedFilesClass getProfileVideosArray].count == 0)
//            footerSectionTitle.text = @"No videos to display";
//        else  if(indexPath.section == 2 && [SMSharedFilesClass getProfileResumesArray].count == 0)
//            footerSectionTitle.text = @"No resumes to display";
//        else  if(indexPath.section == 3 && [SMSharedFilesClass getProfileLettersOfRecommendatationsArray].count == 0)
//            footerSectionTitle.text = @"No recommendation letters to display";
        
        if(indexPath.section == 0 && [[[ReusedMethods userProfile] valueForKey:@"image_url"] count] == 0)
            footerSectionTitle.text = @"No photos to display";
        else  if(indexPath.section == 1 && [[[ReusedMethods userProfile] valueForKey:@"video_url"] count] == 0)
            footerSectionTitle.text = @"No videos to display";
        else  if(indexPath.section == 2 && [[[ReusedMethods userProfile] valueForKey:@"resume_url"] count] == 0)
            footerSectionTitle.text = @"No resumes to display";
        else  if(indexPath.section == 3 && [[[ReusedMethods userProfile] valueForKey:@"recomendationLettrs_url"] count] == 0)
            footerSectionTitle.text = @"No recommendation letters to display";

        
        reusableview  = footerView;
    }
    
    return reusableview;
    
    return nil;
}
//Add HEADER to Collection View to display Bio information at the top
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    if (kind == UICollectionElementKindSectionHeader)
//    {
//        
//        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
//        [headerView setBackgroundColor:[UIColor clearColor]];
//        
//        if (headerView==nil) {
//            headerView=[[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(collectionView.frame), 44)];
//        }
//        
//        float  xPos  = 3;
//        float  yPos  =  0;
//        
//        float  lblWidth  = CGRectGetWidth(collectionView.frame)  -  (2 * xPos) ;
//        float  lblHeight  =  20;
//                //[[headerView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
//        
//        
//        UILabel *header_TitleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetHeight(headerView.frame))];
//        [header_TitleLabel1 setBackgroundColor:[UIColor clearColor]];
//        [header_TitleLabel1 setNumberOfLines:0];
//        [header_TitleLabel1 setLineBreakMode:NSLineBreakByWordWrapping];
//        [header_TitleLabel1 setTextAlignment:NSTextAlignmentLeft];
//        [header_TitleLabel1 setTextColor:[UIColor appGrayColor]];
//        [header_TitleLabel1 setFont:[UIFont appNormalTextFont]];
//        [headerView  addSubview:header_TitleLabel1];
//        
//        if(indexPath.section == 0)
//            header_TitleLabel1.text = @"Videos";
//        else  if(indexPath.section == 1)
//            header_TitleLabel1.text = @"Photos";
//        
//
//       
//        /*
//        if(header_TitleLabel == nil && header_subTitleLable  ==  nil)
//        {
//            
//            //videos  title  displayed on textLabel
//            header_TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, lblWidth, lblHeight)];
//            [header_TitleLabel setBackgroundColor:[UIColor purpleColor]];
//            [header_TitleLabel setNumberOfLines:0];
//            [header_TitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
//            [header_TitleLabel setTextAlignment:NSTextAlignmentLeft];
//            [header_TitleLabel setTextColor:[UIColor appGrayColor]];
//            [header_TitleLabel setFont:[UIFont appNormalTextFont]];
//            [headerView  addSubview:header_TitleLabel];
//            
//            yPos = CGRectGetMaxY(header_TitleLabel.frame) + 20;
//            
//            //videos  title  displayed on textLabel
//            header_subTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, lblWidth, CGRectGetHeight(headerView.frame) - CGRectGetHeight(header_TitleLabel.frame) )];
//            [header_subTitleLable setBackgroundColor:[UIColor yellowColor]];
//            [header_subTitleLable setNumberOfLines:0];
//            [header_subTitleLable setLineBreakMode:NSLineBreakByWordWrapping];
//            [header_subTitleLable setTextAlignment:NSTextAlignmentLeft];
//            [header_subTitleLable setTextColor:[UIColor appLightGrayColor]];
//            [header_subTitleLable setFont:[UIFont appNormalTextFont]];
//            [headerView  addSubview:header_subTitleLable];
//            
//            //header_TitleLabel.text = @"Bio";
//            header_subTitleLable.text  =  [serverResponseDict objectForKey:ABOUTME];
//            
//            [header_TitleLabel resizeToFit];
//            [header_subTitleLable  resizeToFit];
//            
//            yPos = CGRectGetMaxY(header_subTitleLable.frame) + 10;
//            
//            seperaterLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, lblWidth, 1 )];
//            seperaterLabel.backgroundColor = [UIColor appLightGrayColor];
//            [headerView addSubview:seperaterLabel];
//            
//            yPos  =  CGRectGetMaxY(seperaterLabel.frame) + 5;
//            
//            sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, lblWidth, 20)];
//            [sectionTitle setBackgroundColor:[UIColor clearColor]];
//            [sectionTitle setNumberOfLines:0];
//            [sectionTitle setLineBreakMode:NSLineBreakByWordWrapping];
//            [sectionTitle setTextAlignment:NSTextAlignmentLeft];
//            [sectionTitle setTextColor:[UIColor appGrayColor]];
//            [sectionTitle setFont:[UIFont appNormalTextFont]];
//            [sectionTitle setText:sectionTitleString];
//            [headerView addSubview:sectionTitle];
//            
//        }
//        
//        //else
//        {
//            [headerView  addSubview:header_TitleLabel];
//            [headerView  addSubview:header_subTitleLable];
//            [headerView  addSubview:seperaterLabel];
//            [headerView addSubview:sectionTitle];
//        }
//         
//         */
//        return  headerView;
//        
//    }
//    return nil;
//}

//Header size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
//    float  xPos  = 3;
//    float  yPos  =  10;
//    
//    float  lblWidth  = CGRectGetWidth(collectionView.frame)  -  (2 * xPos) ;
//    float  lblHeight  =  20;

    
    /*
    if(section  ==  0)
    {
//        float  xPos  = 3;
//        float  yPos  =  10;
//        
//        float  lblWidth  = CGRectGetWidth(collectionView.frame)  -  (2 * xPos) ;
//        float  lblHeight  =  20;
        
        if(header_TitleLabel == nil ){
            
            //videos  title  displayed on textLabel
            header_TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, lblWidth, lblHeight)];
            [header_TitleLabel setBackgroundColor:[UIColor redColor]];
            [header_TitleLabel setNumberOfLines:0];
            [header_TitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
            [header_TitleLabel setTextAlignment:NSTextAlignmentLeft];
            [header_TitleLabel setTextColor:[UIColor greenColor]];
            [header_TitleLabel setFont:[UIFont appNormalTextFont]];
            [header_TitleLabel resizeToFit];

        }
        yPos = CGRectGetMaxY(header_TitleLabel.frame) + 20;

             if(header_subTitleLable == nil )
             {
            //videos  title  displayed on textLabel
            header_subTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, lblWidth, 20 )];
            [header_subTitleLable setBackgroundColor:[UIColor greenColor]];
            [header_subTitleLable setNumberOfLines:0];
            [header_subTitleLable setLineBreakMode:NSLineBreakByWordWrapping];
            [header_subTitleLable setTextAlignment:NSTextAlignmentLeft];
            [header_subTitleLable setTextColor:[UIColor redColor]];
            [header_subTitleLable setFont:[UIFont appNormalTextFont]];
            
           // header_TitleLabel.text = @"Bio";
            header_subTitleLable.text  =  [serverResponseDict objectForKey:ABOUTME];
            
            [header_subTitleLable  resizeToFit];
            
            
        }
        
    }
    
    */
//    yPos = (section == 0) ? CGRectGetMaxY(header_subTitleLable.frame) + 10 : 10;
//     sectionTitleString  =  (section ==  0) ? @"Photos" : @"Videos" ;
//    
//        seperaterLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, lblWidth, 1 )];
//        seperaterLabel.backgroundColor = [UIColor appLightGrayColor];
//    
//        yPos  =  CGRectGetMaxY(seperaterLabel.frame) + 5;
//    
//        sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(xPos, yPos, lblWidth, 20)];
//        [sectionTitle setBackgroundColor:[UIColor redColor]];
//        [sectionTitle setNumberOfLines:0];
//        [sectionTitle setLineBreakMode:NSLineBreakByWordWrapping];
//        [sectionTitle setTextAlignment:NSTextAlignmentLeft];
//        [sectionTitle setTextColor:[UIColor appGrayColor]];
//        [sectionTitle setFont:[UIFont appNormalTextFont]];
//        [sectionTitle setText:sectionTitleString];
    
    
    
    float width =  CGRectGetWidth(collectionView.frame)  -  (2 * 5);
    
    float cellHeight;
    
    if(section == 0)
    {
       
        
        float bioHeight = [self heightOfTextForString: [serverResponseDict objectForKey:ABOUTME]
                                              andFont:[UIFont appLatoLightFont15]
                                              maxSize: CGSizeMake(width, MAXFLOAT)];
      
        cellHeight =  bioHeight + 20 + 50 + 30;
        
    }
    else
    {
        cellHeight = 50;
    }
    
    CGSize headerSize = CGSizeMake(CGRectGetWidth(collectionView.frame), cellHeight + 10);
    
    return headerSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    photoIndex  = (int) indexPath.row;
    
    
    if(indexPath.section == 0)
    {
        mediaType   =  imageType;
        profileImagesArray  = [[ReusedMethods userProfile] valueForKey:@"image_url"];

        if([profileImagesArray count]){
            [fileContentsArray removeAllObjects];
            [fileContentsArray  addObjectsFromArray:profileImagesArray];
            [self addExapandableView];
        }
    }
    
    else if(indexPath.section == 2)
    {
        mediaType   =  resumeType;
        profileResumesArray  = [[ReusedMethods userProfile] valueForKey:@"resume_url"];
        if([profileResumesArray count]){
            [fileContentsArray removeAllObjects];
            [fileContentsArray  addObjectsFromArray:profileResumesArray];
            [self addExapandableView];
        }
    }
    
    else if(indexPath.section == 3)
    {
        mediaType   =  recommendationType;
        profileRecomendationsArray  = [[ReusedMethods userProfile] valueForKey:@"recomendationLettrs_url"];
        if([profileRecomendationsArray count]){
            [fileContentsArray removeAllObjects];
            [fileContentsArray  addObjectsFromArray:profileRecomendationsArray];
            [self addExapandableView];
        }
    }

}


// get images  array

//- (NSArray *) getProfileImagesArray{
//    NSString *path = [SMSharedFilesClass profileTempImagesPath];
//    NSArray *images = [SMSharedFilesClass allFilesAtPath:path];
//    if(![images count]){
//        path = [SMSharedFilesClass profileImagesPath];
//        images = [SMSharedFilesClass allFilesAtPath:path];
//    }
//    return images;
//}
#pragma  mark  -

- (IBAction)displayCorrespondingImages:(id) sender{
    photoIndex  =  0;
    mediaType   =  ([sender tag] == 2) ? resumeType: recommendationType;
    NSDictionary * dict = [SMSharedFilesClass getFilesArrayWithMediaType:mediaType] ;
    if([[dict objectForKey:@"objects"] count]){
        [fileContentsArray removeAllObjects];
        [fileContentsArray  addObjectsFromArray:[dict objectForKey:@"objects"]];
        [self addExapandableView];
    }else{
        [[[RBACustomAlert alloc] initWithTitle:APP_TITLE message:@"No files available to show" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
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
    [self swipeAnimationExpandableImageView:expandableImageView withleftRight:kCATransitionFromLeft];
    
}

-(void)rightButtonAction
{
    photoIndex++;
    [self loadExpandablemage];
    [self swipeAnimationExpandableImageView:expandableImageView withleftRight:kCATransitionFromRight];
}

# pragma  mark  --------- SWIPE  GESTURE  METHODS  -------
- (void) swipePreviousAction:(UISwipeGestureRecognizer*)sender{
    
    // dont execute  if  the  photo index  0 //  will crash
    if(photoIndex != 0){
        photoIndex--;
        [self loadExpandablemage];
        [self swipeAnimationExpandableImageView:expandableImageView withleftRight:kCATransitionFromLeft];
    }
}

-(void)swipeNextAction:(UISwipeGestureRecognizer*)sender{
    
    //  if photo reaches  count  dont allow  to increse
    if(photoIndex < (fileContentsArray.count -  1)){
        photoIndex++;
        [self loadExpandablemage];
        [self swipeAnimationExpandableImageView:expandableImageView withleftRight:kCATransitionFromRight];
    }
    
}


-(void)addExapandableView
{
    UIWindow *  window  =  [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:expandableView];
    //photoIndex = 0;
    if (fileContentsArray.count == 1)
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
    // NSString * imageURL = [[self getProfileImagesArray] objectAtIndex:photoIndex];
    NSIndexPath  *  indexPath  =  [NSIndexPath indexPathForRow:photoIndex inSection:0];
    if(mediaType  == resumeType){
    //    indexPath  =  [NSIndexPath indexPathForRow:photoIndex inSection:2];
        [SMSharedFilesClass setResumeImagesOnView:expandableImageView atIndexPath:indexPath];
    }else if (mediaType  ==  imageType){
        [SMSharedFilesClass setProfileImagesOnView:expandableImageView atIndexPath:indexPath];
    }else if (mediaType  ==  recommendationType){
        [SMSharedFilesClass setLetterOfRecommendationImagesOnView:expandableImageView atIndexPath:indexPath];
    }
    
    if (photoIndex == fileContentsArray.count-1)
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

//-(void)imageTapLoadExpandViewWithRow:(int)row index:(int)index
//{
//    //selectedPost = [[self getProfileImagesArray] objectAtIndex:row];
//    photoIndex = index;
//    UIWindow *  window  =  [[[UIApplication sharedApplication] delegate] window];
//    [window addSubview:expandableView];
//    [self loadExpandablemage];
//}

-(void)swipeAnimationExpandableImageView:(UIView *)expandedView withleftRight:(NSString *)leftRight
{
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setDuration:0.5f];
    [animation setType:kCATransitionPush];
    animation.subtype = leftRight;
    [expandedView.layer addAnimation:animation forKey:NULL];
}
//
//#pragma mark - EXPANDABLE VIEW LINER
//-(void)createExpandableViewLinear
//{
//    float screenWidth  = [[UIScreen mainScreen] bounds].size.width;
//    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
//    
//    expandableViewLinear = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
//    expandableViewLinear.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.9];
//    // [self.view addSubview:expandableView];
//    
//    // Adding UIImageView
//    
//    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60, screenWidth - 20, screenWidth - 20)];
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    imageView.center = expandableViewLinear.center;
//    imageView.layer.cornerRadius = 15.0f;
//    imageView.layer.masksToBounds = YES;
//    
//    [expandableViewLinear addSubview:imageView];
//    
//    expandableImageViewLIner  = imageView;
//    
//    
//    // Adding Left and Right Buttons
//    topButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (imageView.center.y)-75 , 60, 150)];
//    [topButton setImage:[UIImage imageNamed:@"leftarrow"] forState:UIControlStateNormal];
//    [topButton setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.1]];
//    [topButton addTarget:self action:@selector(topButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    // [expandableView addSubview:topButton];
//    
//    bottomButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 60, (imageView.center.y)-75, 60, 150)];
//    [bottomButton setImage:[UIImage imageNamed:@"rightarrow"] forState:UIControlStateNormal];
//    [bottomButton setBackgroundColor: [UIColor colorWithWhite:0.9 alpha:0.1]];
//    [bottomButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    //[expandableView addSubview:rightButton];
//    
//    // Close button
//    UIButton * closeButton = [[UIButton alloc] initWithFrame:CGRectMake(expandableViewLinear.frame.size.width - 60,20, 50, 50)];
//    [closeButton setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
//    [closeButton addTarget:self action:@selector(closeExpandableViewLiner) forControlEvents:UIControlEventTouchUpInside];
//    [expandableViewLinear addSubview:closeButton];
//    
//    
//    // add swipe  gesture  for  expandable  view
//    
//    UISwipeGestureRecognizer *swipeTopToDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeTopAction:)];
//    [swipeTopToDown setDirection:UISwipeGestureRecognizerDirectionDown];
//    [expandableViewLinear addGestureRecognizer:swipeTopToDown];
//    UISwipeGestureRecognizer *swipeDowntToTop = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownAction:)];
//    [swipeDowntToTop setDirection:UISwipeGestureRecognizerDirectionUp];
//    [expandableViewLinear addGestureRecognizer:swipeDowntToTop];
//    
//}
//
//-(void)closeExpandableViewLiner
//{
//    [expandableViewLinear removeFromSuperview];
//}
//
//-(void)topButtonAction
//{
//    photoIndexLiner--;
//    [self loadExpandablemageLIner];
//    [self swipeAnimationExpandableImageView:expandableImageViewLIner withleftRight:kCATransitionFromBottom];
//    
//}
//
//-(void)bottomButtonAction
//{
//    photoIndexLiner++;
//    [self loadExpandablemageLIner];
//    [self swipeAnimationExpandableImageView:expandableImageViewLIner withleftRight:kCATransitionFromTop];
//}
//
//# pragma  mark  --------- SWIPE  GESTURE  METHODS  -------
//- (void) swipeTopAction:(UISwipeGestureRecognizer*)sender{
//    
//    // dont execute  if  the  photo index  0 //  will crash
//    if(photoIndexLiner != 0){
//        photoIndexLiner--;
//        [self loadExpandablemageLIner];
//        [self swipeAnimationExpandableImageView:expandableImageViewLIner withleftRight:kCATransitionFromBottom];
//    }
//}
//
//-(void)swipeDownAction:(UISwipeGestureRecognizer*)sender{
//    
//    //  if photo reaches  count  dont allow  to increse
//    if(photoIndexLiner < (fileContentsArray.count -  1)){
//        photoIndexLiner++;
//        [self loadExpandablemageLIner];
//        [self swipeAnimationExpandableImageView:expandableImageViewLIner withleftRight:kCATransitionFromTop];
//    }
//    
//}
//
//
//-(void)addExapandableLinerView
//{
//    UIWindow *  window  =  [[[UIApplication sharedApplication] delegate] window];
//    [window addSubview:expandableViewLinear];
//    //photoIndex = 0;
//    if (fileContentsArray.count == 1)
//    {
//        topButton.hidden = YES;
//        bottomButton.hidden = YES;
//    }
//    else
//    {
//        topButton.hidden = NO;
//        bottomButton.hidden = NO;
//    }
//    leftButton.hidden = YES;
//    [self loadExpandablemageLIner];
//}
//
//-(void)loadExpandablemageLIner
//{
//    // NSString * imageURL = [[self getProfileImagesArray] objectAtIndex:photoIndex];
//    NSIndexPath  *  indexPath  =  [NSIndexPath indexPathForRow:photoIndexLiner inSection:0];
//    [SMSharedFilesClass setCorrespondingImagesOnView:expandableImageViewLIner atIndexPath:indexPath mediaType:mediaType];
//    
//    if (photoIndexLiner == profileImagesArray.count-1)
//    {
//        bottomButton.hidden = YES;
//    }
//    else
//    {
//        bottomButton.hidden  = NO;
//    }
//    if (photoIndexLiner == 0)
//    {
//        topButton.hidden = YES;
//    }
//    else
//    {
//        topButton.hidden = NO;
//    }
//}


//To calculate the height of the test based on its font size
-(CGFloat)heightOfTextForString:(NSString *)aString andFont:(UIFont *)aFont maxSize:(CGSize)aSize
{
    // iOS7
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        CGSize sizeOfText = [aString boundingRectWithSize: aSize
                                                  options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                               attributes: [NSDictionary dictionaryWithObject:aFont
                                                                                       forKey:NSFontAttributeName]
                                                  context: nil].size;
        
        return ceilf(sizeOfText.height);
    }
    
    // iOS6
    CGSize textSize = [aString sizeWithFont:aFont
                          constrainedToSize:aSize
                              lineBreakMode:NSLineBreakByWordWrapping];
    return ceilf(textSize.height);
    
}


@end
