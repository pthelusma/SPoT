//
//  Photo+Flickr.m
//  SPoT
//
//  Created by Pierre Thelusma on 10/29/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"

@implementation Photo (Flickr)

+ (Photo *) photo: (NSDictionary *) photoDictionary context:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    
    NSFetchRequest*request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"photo_id = %@", [photoDictionary[FLICKR_PHOTO_ID] description]];
    
    photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
    
    photo.title = [photoDictionary[FLICKR_PHOTO_TITLE] description];
    photo.subtitle = [[photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION] description];
    photo.url = [[FlickrFetcher urlForPhoto:photoDictionary format:FlickrPhotoFormatLarge] absoluteString];
    photo.thumbnail_url = [[FlickrFetcher urlForPhoto:photoDictionary format:FlickrPhotoFormatSquare] absoluteString];
    photo.photo_id = [photoDictionary[FLICKR_PHOTO_ID] description];
    
    return photo;
}

@end
