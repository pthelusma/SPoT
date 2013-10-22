//
//  RecentPhotos.h
//  SPoT
//
//  Created by Pierre Thelusma on 10/15/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentPhotos : NSObject

+ (NSArray *)photos;
+ (void)addPhoto:(NSDictionary *)photo;

@end
