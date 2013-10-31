//
//  PhotoCDTVC.h
//  SPoT
//
//  Created by Pierre Thelusma on 10/29/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Tag.h"

@interface PhotoCDTVC : CoreDataTableViewController

@property (nonatomic, strong) Tag *tag;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end
