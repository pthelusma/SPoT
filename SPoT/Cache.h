//
//  Cache.h
//  SPoT
//
//  Created by Pierre Thelusma on 10/17/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cache : NSObject

@property (nonatomic, strong) NSURL *folder;
@property (nonatomic, strong) NSFileManager *fileManager;

- (NSURL *)getCachedURL:(NSURL *)url;
- (void)cacheData:(NSData *)data usingURL:(NSURL *)url;
- (BOOL) fileExists:(NSURL *)url;
- (void) manageCache;
@end
