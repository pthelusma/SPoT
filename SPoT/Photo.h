//
//  Photo.h
//  SPoT
//
//  Created by Pierre Thelusma on 10/31/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PhotoTag;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * photo_id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * thumbnail_url;
@property (nonatomic, retain) NSData * thumbnail_image_data;
@property (nonatomic, retain) PhotoTag *toPhotoTag;

@end
