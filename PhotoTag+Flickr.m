//
//  PhotoTag+Flickr.m
//  SPoT
//
//  Created by Pierre Thelusma on 10/29/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "PhotoTag+Flickr.h"

@implementation PhotoTag (Flickr)

+ (PhotoTag *) photoTag: (NSString *) photo_id context:(NSManagedObjectContext *)context tag_id:(NSNumber *) tag_id
{
    PhotoTag *photoTag = nil;
    
    NSFetchRequest*request = [NSFetchRequest fetchRequestWithEntityName:@"PhotoTag"];
    request.predicate = [NSPredicate predicateWithFormat:@"tag_id == %@ AND photo_id = %@", tag_id, photo_id];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || [matches count] > 1)
    {
    } else if(![matches count])
    {
        photoTag = [NSEntityDescription insertNewObjectForEntityForName:@"PhotoTag" inManagedObjectContext:context];
        
        photoTag.photo_id = photo_id;
        photoTag.tag_id = tag_id;
    } else
    {
        photoTag = [matches objectAtIndex:0];
    }
    
    return photoTag;
    
}

+ (NSInteger) tagCount: (NSNumber *) tag_id context:(NSManagedObjectContext *)context
{
    
    NSFetchRequest*request = [NSFetchRequest fetchRequestWithEntityName:@"PhotoTag"];
    request.predicate = [NSPredicate predicateWithFormat:@"tag_id == %@", tag_id];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    return [matches count];
}

@end
