//
//  Context.h
//  SPoT
//
//  Created by Pierre Thelusma on 10/30/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Context : NSObject

@property (nonatomic, strong) NSManagedObjectContext *context;

- (void) createContext:(void(^)(void))callback refresh:(void(^)(void))refresh;

@end
