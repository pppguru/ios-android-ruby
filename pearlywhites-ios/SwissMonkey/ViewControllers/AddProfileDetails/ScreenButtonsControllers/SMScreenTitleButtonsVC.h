//
//  SMScreenTitleButtonsVC.h
//  SwissMonkey
//
//  Created by Kasturi on 2/3/16.
//  Copyright (c) 2016 rapidBizApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMHomeVC.h"

@interface SMScreenTitleButtonsVC : SMHomeVC


@property (nonatomic, readwrite) MediaType mediaType;
@property                        int       indexProfileDetail;

- (void) uploadImages;

@end
