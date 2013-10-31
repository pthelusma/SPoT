//
//  Tag+Flickr.h
//  SPoT
//
//  Created by Pierre Thelusma on 10/29/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "Tag.h"

@interface Tag (Flickr)

+ (Tag *) tag: (NSString *) title context:(NSManagedObjectContext *)context photo:(NSDictionary *) photo;


@end
