//
//  ImageViewController.h
//  SPoT
//
//  Created by Pierre Thelusma on 10/15/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cache.h"

@interface ImageViewController : UIViewController

@property (nonatomic, strong) NSDictionary *photo;
@property (nonatomic, strong) NSURL *imageURL;


@end
