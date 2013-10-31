//
//  Photo+Flickr.h
//  SPoT
//
//  Created by Pierre Thelusma on 10/29/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "Photo.h"

@interface Photo (Flickr)

+ (Photo *) photo: (NSDictionary *) photoDictionary context:(NSManagedObjectContext *)context;

@end
