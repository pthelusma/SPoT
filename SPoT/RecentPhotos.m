//
//  RecentPhotos.m
//  SPoT
//
//  Created by Pierre Thelusma on 10/15/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "RecentPhotos.h"
#import "FlickrFetcher.h"

@implementation RecentPhotos

#define KEY_RECENT_PHOTOS @"KEY_RECENT_PHOTOS"

+ (NSArray *)photos
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_RECENT_PHOTOS];
}

+ (void)addPhoto:(NSDictionary *)photo;
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recentPhotos = [[userDefaults objectForKey:KEY_RECENT_PHOTOS] mutableCopy];
    
    if (!recentPhotos)
    {
        recentPhotos = [[NSMutableArray alloc] init];
    }
    
    NSInteger index = -1;
    
    for(NSDictionary *recentPhoto in recentPhotos)
    {
        if([recentPhoto[FLICKR_PHOTO_ID] isEqualToString:photo[FLICKR_PHOTO_ID]])
        {
            index = [recentPhotos indexOfObject:recentPhoto];
        }
    }
    
    if(index != -1)
    {
        [recentPhotos removeObjectAtIndex:index];
    }
    
    [recentPhotos insertObject:photo atIndex:0];
    
    while([recentPhotos count] > 10)
    {
        [recentPhotos removeLastObject];
    }
    
    [userDefaults setObject:recentPhotos forKey:KEY_RECENT_PHOTOS];
    [userDefaults synchronize];
    
}

@end
