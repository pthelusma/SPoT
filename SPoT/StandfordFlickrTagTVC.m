//
//  StandfordFlickrTagTVC.m
//  SPoT
//
//  Created by Pierre Thelusma on 10/13/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "StandfordFlickrTagTVC.h"
#import "FlickrFetcher.h"
#import "NetworkActivity.h"

@interface StandfordFlickrTagTVC ()

@end

@implementation StandfordFlickrTagTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadLatestStanfordPhotos];
    [self.refreshControl addTarget:self
                            action:@selector(loadLatestStanfordPhotos)
                  forControlEvents:UIControlEventValueChanged];
}

- (void) loadLatestStanfordPhotos
{
    [self.refreshControl beginRefreshing];
    
    dispatch_queue_t loaderQ = dispatch_queue_create("latest loader", NULL);
    dispatch_async(loaderQ, ^{
        
        [NetworkActivity startIndicator];
        NSArray *latestPhotos = [FlickrFetcher stanfordPhotos];
        [NetworkActivity stopIndicator];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photos = latestPhotos;
            [self.refreshControl endRefreshing];
        });
    });
}

@end
