//
//  RecentPhoto+Flickr.h
//  SPoT
//
//  Created by Pierre Thelusma on 10/30/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "RecentPhoto.h"
#import "Photo.h"

@interface RecentPhoto (Flickr)

+ (void) addPhoto: (Photo *) photo context:(NSManagedObjectContext *)context;

+ (void) addRecentPhoto: (RecentPhoto *) recentPhoto context:(NSManagedObjectContext *)context;

@end
