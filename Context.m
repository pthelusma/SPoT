//
//  Context.m
//  SPoT
//
//  Created by Pierre Thelusma on 10/30/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "Context.h"

@implementation Context

- (void) createContext:(void(^)(void))callback refresh:(void(^)(void))refresh
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    url = [url URLByAppendingPathComponent:@"Document"];
    
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[url path]])
    {
        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if(success)
              {
                  self.context = document.managedObjectContext;
                  callback();
                  refresh();
              }
          }];
    } else if (document.documentState == UIDocumentStateClosed)
    {
        [document openWithCompletionHandler:^(BOOL success) {
            if(success)
            {
                self.context = document.managedObjectContext;
                callback();
            }
        }];
    } else
    {
        self.context = document.managedObjectContext;
        callback();
    }
}

@end
