//
//  TagCDTVC.m
//  SPoT
//
//  Created by Pierre Thelusma on 10/29/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "TagCDTVC.h"
#import "Tag.h"
#import "NetworkActivity.h"
#import "FlickrFetcher.h"
#import "PhotoTag+Flickr.h"
#import "Photo+Flickr.h"
#import "Tag+Flickr.h"
#import "Context.h"

@interface TagCDTVC ()

@end

@implementation TagCDTVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(!self.context)
    {
        [Context createContext:^(NSManagedObjectContext *stuff){
            self.context = stuff;
        } refresh:^{
            [self refresh];
        }];
    }
}

- (void)setContext:(NSManagedObjectContext *)context
{
    _context = context;
    
    if(context)
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        
        request.predicate = nil;
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    } else
    {
        self.fetchedResultsController = nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"Tags"];
    
    Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = tag.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [PhotoTag tagCount:tag.tag_id context:self.context]];
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refresh];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)refresh
{
    [self.refreshControl beginRefreshing];
    
    dispatch_queue_t flickrFetcher = dispatch_queue_create("Flickr Fetcher", NULL);
    dispatch_async(flickrFetcher, ^{
        
        [NetworkActivity startIndicator];
        NSArray *photos = [FlickrFetcher stanfordPhotos];
        [NetworkActivity stopIndicator];
        
        [self.context performBlock:^{
            for(NSDictionary *photo in photos)
            {
                for(NSString *tag in [photo[FLICKR_TAGS] componentsSeparatedByString:@" "])
                {
                    if(![[self tagExceptions] containsObject:tag])
                    {
                        Tag *tagRow = [Tag tag:tag context:self.context photo:photo];
                        Photo *photoRow = [Photo photo:photo context:self.context];
                        
                        PhotoTag *photoTagRow = [PhotoTag photoTag:photoRow.photo_id context:self.context tag_id:tagRow.tag_id];
                        
                        photoTagRow.toPhoto = photoRow;
                        photoTagRow.toTag = tagRow;
                    }
                }
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
        });
    });
}

- (NSArray *) tagExceptions
{
    return @[@"cs193pspot", @"portrait", @"landscape"];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([sender isKindOfClass:[UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        if(indexPath)
        {
            if([segue.identifier isEqualToString:@"Show Photos for Tag"])
            {
                if([segue.destinationViewController respondsToSelector:@selector(setDictionary:)])
                {
                    
                    Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
                    
                    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
                    [dictionary setValue:self.context forKey:@"context"];
                    [dictionary setValue:tag forKey:@"tag"];
                    
                    [segue.destinationViewController performSelector:@selector(setDictionary:) withObject:dictionary];
                    [segue.destinationViewController setTitle:[tag.title capitalizedString]];
                    
                }
            }
        }
    }
}

@end
