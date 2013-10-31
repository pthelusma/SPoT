//
//  RecentPhotoCDTVC.m
//  SPoT
//
//  Created by Pierre Thelusma on 10/30/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "RecentPhotoCDTVC.h"
#import "RecentPhoto.h"
#import "RecentPhoto+Flickr.h"
#import "TagCDTVC.h"
#import "Context.h"
#import "Photo.h"

@interface RecentPhotoCDTVC ()

@end

@implementation RecentPhotoCDTVC

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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(!self.context)
    {
        Context *context = [[Context alloc] init];
        [context createContext:^{
            self.context = [context context];
        }  refresh:nil];
    }
}

- (void)setContext:(NSManagedObjectContext *)context
{
    
    if(context)
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"RecentPhoto"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date_added" ascending:NO selector:@selector(localizedCaseInsensitiveCompare:)]];
        
        request.predicate = nil;
        
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
                    RecentPhoto *recentPhoto = [self.fetchedResultsController objectAtIndexPath:indexPath];
                    
                    [RecentPhoto addRecentPhoto:recentPhoto context:self.context];
                    
                    NSURL *url = [[NSURL alloc] initWithString:recentPhoto.url];
                    
                    [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                    [segue.destinationViewController setTitle:recentPhoto.title];
                }
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photos";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    RecentPhoto *recentPhoto = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = recentPhoto.title;
    cell.detailTextLabel.text = recentPhoto.subtitle;
    
    cell.imageView.image = [UIImage imageWithData:recentPhoto.thumbnail_image_data];
    if (!cell.imageView.image) {
        dispatch_queue_t q = dispatch_queue_create("Fetch Thumbnail", NULL);
        dispatch_async(q, ^{
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:recentPhoto.thumbnail_url]];
            [recentPhoto.managedObjectContext performBlock:^{
                recentPhoto.thumbnail_image_data = imageData;
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imageView.image = [UIImage imageWithData:imageData];
                    [cell setNeedsLayout];
                });
            }];
        });
    }
    
    
    return cell;
}

@end
