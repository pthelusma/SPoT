//
//  PhotoTag.h
//  SPoT
//
//  Created by Pierre Thelusma on 10/31/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo, Tag;

@interface PhotoTag : NSManagedObject

@property (nonatomic, retain) NSString * photo_id;
@property (nonatomic, retain) NSNumber * tag_id;
@property (nonatomic, retain) Tag *toTag;
@property (nonatomic, retain) Photo *toPhoto;

@end
