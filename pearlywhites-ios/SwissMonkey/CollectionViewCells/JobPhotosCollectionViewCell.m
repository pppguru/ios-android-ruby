//
//  JobPhotosCollectionViewCell.m
//  SwissMonkey
//
//  Created by Kasturi on 2/1/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import "JobPhotosCollectionViewCell.h"

@implementation JobPhotosCollectionViewCell
@synthesize photoImgView;

- (void)layoutSubviews
{
    [super layoutSubviews];
    photoImgView.layer.borderWidth = 0.5f;
    photoImgView.layer.borderColor = [[UIColor appGrayColor] CGColor];
    photoImgView.layer.cornerRadius = 5;
    photoImgView.layer.masksToBounds = YES;
    
}

- (void)setImageAtIndex:(NSIndexPath *)currentIndexPath FromImagesArray:(NSMutableArray *)imagesArray{
    
        NSURL * url  =  [NSURL URLWithString:[imagesArray objectAtIndex:currentIndexPath.row]];
        NSURLRequest *request  =  [NSURLRequest requestWithURL:url];
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [spinner setCenter:CGPointMake(photoImgView.center.x, photoImgView.center.y + 20)];
        [photoImgView setImage:nil];
        [photoImgView setBackgroundColor:[UIColor blackColor]];
        [self.contentView addSubview:spinner];
//        [self.contentView bringSubviewToFront:spinner];
        [spinner startAnimating];
       
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   if (!error) {
                                      photoImgView.image = [UIImage imageWithData:data];
                                       [photoImgView setContentMode:UIViewContentModeScaleAspectFit];
                                   } else {
                                       NSLog(@"error  descripyion :%@",error);
                                   }
                                   [spinner stopAnimating];
                               }];
}


@end
