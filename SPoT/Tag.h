//
//  Tag.h
//  SPoT
//
//  Created by Pierre Thelusma on 10/13/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tag : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSInteger count;
@property (nonatomic, strong) NSMutableArray *photos;

-(id)initWithName:(NSString*)name;

@end
