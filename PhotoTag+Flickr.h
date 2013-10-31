//
//  PhotoTag+Flickr.h
//  SPoT
//
//  Created by Pierre Thelusma on 10/29/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "PhotoTag.h"

@interface PhotoTag (Flickr)

+ (PhotoTag *) photoTag: (NSString *) photo_id context:(NSManagedObjectContext *)context tag_id:(NSNumber *) tag_id;
+ (NSInteger) tagCount: (NSNumber *) tag_id context:(NSManagedObjectContext *)context;

@end
