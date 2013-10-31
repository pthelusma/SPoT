//
//  RecentPhoto+Flickr.m
//  SPoT
//
//  Created by Pierre Thelusma on 10/30/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "RecentPhoto+Flickr.h"
#import "Photo.h"

@implementation RecentPhoto (Flickr)


+ (void) addPhoto: (Photo *) photo context:(NSManagedObjectContext *)context
{
    NSFetchRequest*request = [NSFetchRequest fetchRequestWithEntityName:@"RecentPhoto"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"photo_id = %@", photo.photo_id];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    RecentPhoto *recentPhoto = nil;
    
    if(!matches || [matches count] > 1)
    {
        //There was a problem
    } else if(![matches count])
    {
        recentPhoto = [NSEntityDescription insertNewObjectForEntityForName:@"RecentPhoto" inManagedObjectContext:context];
        
        recentPhoto.title = photo.title;
        recentPhoto.subtitle = photo.subtitle;
        recentPhoto.url = photo.url;
        recentPhoto.thumbnail_url = photo.thumbnail_url;
        recentPhoto.photo_id = photo.photo_id;
        recentPhoto.date_added = [[NSDate alloc] init];
        
        
    } else
    {
        recentPhoto = [matches objectAtIndex:0];
    }
}

+ (void) addRecentPhoto: (RecentPhoto *) recentPhoto context:(NSManagedObjectContext *)context
{
    
    NSFetchRequest*request = [NSFetchRequest fetchRequestWithEntityName:@"RecentPhoto"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    //request.predicate = [NSPredicate predicateWithFormat:@"photo_id = %@", recentPhoto.photo_id];
    
    request.predicate = nil;
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    for(RecentPhoto *r in matches)
    {
        NSLog(@"%@", r.photo_id);
    }
    
    NSLog(@"%d", matches.count);
    
    RecentPhoto *recentPhotoToAdd = nil;
    
    if(!matches || [matches count] > 1)
    {
        //There was a problem
    } else if(![matches count])
    {
        recentPhotoToAdd = [NSEntityDescription insertNewObjectForEntityForName:@"RecentPhoto" inManagedObjectContext:context];
        
        recentPhotoToAdd.title = recentPhoto.title;
        recentPhotoToAdd.subtitle = recentPhoto.subtitle;
        recentPhotoToAdd.url = recentPhoto.url;
        recentPhotoToAdd.thumbnail_url = recentPhoto.thumbnail_url;
        recentPhotoToAdd.photo_id = recentPhoto.photo_id;
        recentPhotoToAdd.date_added = [[NSDate alloc] init];
        
        
    } else
    {
        recentPhotoToAdd = [matches objectAtIndex:0];
        recentPhotoToAdd.date_added = [[NSDate alloc] init];
    }
}

@end
