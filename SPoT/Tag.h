//
//  Tag.h
//  SPoT
//
//  Created by Pierre Thelusma on 10/31/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PhotoTag;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSNumber * tag_id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) PhotoTag *toPhotoTag;

@end
