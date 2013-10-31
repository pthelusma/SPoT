 //
//  Tag+Flickr.m
//  SPoT
//
//  Created by Pierre Thelusma on 10/29/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "Tag+Flickr.h"
#import "PhotoTag+Flickr.h"
#import "FlickrFetcher.h"

@implementation Tag (Flickr)

+ (Tag *) tag: (NSString *) title context:(NSManagedObjectContext *)context photo:(NSDictionary *) photo;
{
    Tag *tag = nil;
    
    NSFetchRequest*request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"title = %@", title];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if(!matches || [matches count] > 1)
    {
        //do something
    } else if(![matches count])
    {
        tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:context];
        
        tag.tag_id = [self createTagId:context];
        tag.title = title;
        
    } else
    {
        tag = [matches objectAtIndex:0];
    }
    
    return tag;
}

+ (NSNumber *) createTagId: (NSManagedObjectContext *)context
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    NSNumber *tagId = [[NSNumber alloc] initWithInteger:[matches count]];
    
    return tagId;
    
}

@end
