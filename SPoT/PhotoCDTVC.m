//
//  PhotoCDTVC.m
//  SPoT
//
//  Created by Pierre Thelusma on 10/29/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "PhotoCDTVC.h"
#import "Tag.h"
#import "Photo.h"
#import "PhotoTag.h"
#import "FlickrFetcher.h"
#import "RecentPhoto+Flickr.h"

@interface PhotoCDTVC ()

@end

@implementation PhotoCDTVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photos";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PhotoTag *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = photo.toPhoto.title;
    cell.detailTextLabel.text = photo.toPhoto.subtitle;
    
    cell.imageView.image = [UIImage imageWithData:photo.toPhoto.thumbnail_image_data];
    if (!cell.imageView.image) {
        dispatch_queue_t q = dispatch_queue_create("Fetch Thumbnail", NULL);
        dispatch_async(q, ^{
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:photo.toPhoto.thumbnail_url]];
            [photo.managedObjectContext performBlock:^{
                photo.toPhoto.thumbnail_image_data = imageData;
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imageView.image = [UIImage imageWithData:imageData];
                    [cell setNeedsLayout];
                });
            }];
        });
    }
    
    
    return cell;
}

- (void) setDictionary:(NSMutableDictionary *) dictionary
{
    self.tag = [dictionary valueForKey:@"tag"];
    self.context = [dictionary valueForKey:@"context"];
    
    [self.tableView reloadData];
}

- (void)setContext:(NSManagedObjectContext *)context
{
    _context = context;
    
    if(context)
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"PhotoTag"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"toPhoto.title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        
        request.predicate = [NSPredicate predicateWithFormat:@"tag_id = %@", [self.tag tag_id]];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    } else
    {
        self.fetchedResultsController = nil;
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([sender isKindOfClass:[UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        if(indexPath)
        {
            if([segue.identifier isEqualToString:@"Show Photo"])
            {
                if([segue.destinationViewController respondsToSelector:@selector(setImageURL:)])
                {
                    PhotoTag *photoTag = [self.fetchedResultsController objectAtIndexPath:indexPath];
                    Photo *photo = photoTag.toPhoto;
                    
                    [RecentPhoto  addPhoto:photo context:self.context];
                    
                    NSURL *url = [[NSURL alloc] initWithString:photoTag.toPhoto.url];
                    
                    [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                    [segue.destinationViewController setTitle:photoTag.toPhoto.title];
                }
            }
        }
    }

}

@end
