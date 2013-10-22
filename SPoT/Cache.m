//
//  Cache.m
//  SPoT
//
//  Created by Pierre Thelusma on 10/17/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "Cache.h"

@implementation Cache

#define CACHE_FOLDER @"CACHEFOLDER"

- (BOOL) isIpad
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (NSURL *)getCachedURL:(NSURL *)url
{
    return [self.folder URLByAppendingPathComponent: [[url path] lastPathComponent]];
}

- (void)cacheData:(NSData *)data usingURL:(NSURL *)url
{

    NSURL *cachedURL = [self getCachedURL:url];
    BOOL isExists = [self fileExists:cachedURL];
    
    if(!isExists)
    {
        [self.fileManager createFileAtPath:[cachedURL path]
                                            contents:data attributes:nil];
        [self manageCache];
    }
}

- (NSURL *) folder
{
    if(!_folder)
    {
        _folder = [[[self.fileManager URLsForDirectory:NSCachesDirectory
                                             inDomains:NSUserDomainMask] lastObject]
                   URLByAppendingPathComponent:CACHE_FOLDER isDirectory:YES];
        
            if (![self.fileManager fileExistsAtPath:[_folder path]
                                        isDirectory:NO]) {
                [self.fileManager createDirectoryAtURL:_folder
                           withIntermediateDirectories:YES
                                            attributes:nil
                                                 error:nil];
            }
    }

    return _folder;
}

- (NSFileManager *) fileManager
{
    if(!_fileManager)
    {
        _fileManager = [[NSFileManager alloc] init];
    }
    
    return _fileManager;
}

- (BOOL) fileExists:(NSURL *)url
{
    return [self.fileManager fileExistsAtPath:[url path]];
        
}

#define TOTAL_IPONE_CACHE_SIZE 1000000
#define TOTAL_IPAD_CACHE_SIZE 8000000

- (void) manageCache
{
    
    NSDirectoryEnumerator *directoryEnumerator =
    [self.fileManager enumeratorAtURL:self.folder
           includingPropertiesForKeys:@[NSFileModificationDate, NSFileSize]
                              options:NSDirectoryEnumerationSkipsHiddenFiles
                         errorHandler:nil];
    
    NSInteger currentCacheSize = 0;
    NSMutableArray *fileArray = [[NSMutableArray alloc] init];
    
    for (NSURL *url in directoryEnumerator)
    {
        
        NSDate *modificationDate;
        NSNumber *fileSize;
        
        [url getResourceValue:&fileSize forKey:NSURLFileSizeKey error:nil];
        [url getResourceValue:&modificationDate forKey:NSURLAttributeModificationDateKey error:nil];
        
        currentCacheSize += [fileSize integerValue];
        
        NSMutableDictionary *fileDictionary = [[NSMutableDictionary alloc] init];
        [fileDictionary setValue:fileSize forKey:@"fileSize"];
        [fileDictionary setValue:url forKey:@"url"];
        [fileDictionary setValue:modificationDate forKey:@"modificationDate"];
        
        [fileArray addObject:fileDictionary];
        
        //NSLog(@"%d", currentCacheSize);
    }
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"modificationDate"  ascending:YES];
    NSArray *sortedFileArray = [fileArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    
    fileArray = [[NSMutableArray alloc] initWithArray:sortedFileArray];
    
    NSInteger cacheSize = [self isIpad] ? TOTAL_IPAD_CACHE_SIZE : TOTAL_IPONE_CACHE_SIZE;
    
    while(currentCacheSize > cacheSize)
    {
        NSDictionary *fileDictionary = [fileArray objectAtIndex:0];
        NSNumber *fileSize = [fileDictionary objectForKey:@"fileSize"];
        NSURL *url = [fileDictionary objectForKey:@"url"];
        
        [self.fileManager removeItemAtPath:[url path]  error:NULL];
        [fileArray removeObjectAtIndex:0];
        currentCacheSize -= [fileSize integerValue];
    }
}

@end
