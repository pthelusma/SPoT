//
//  Tag.m
//  SPoT
//
//  Created by Pierre Thelusma on 10/13/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "Tag.h"

@implementation Tag

-(id)initWithName:(NSString*)name
{
    self = [super init];
    self.name = name;
    self.count = 1;
    return self;
};

- (NSMutableArray *) photos
{
    if(!_photos)
    {
        _photos = [[NSMutableArray alloc] init];
    }
    
    return _photos;
}



@end
