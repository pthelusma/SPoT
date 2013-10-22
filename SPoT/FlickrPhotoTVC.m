 //
//  FlickrPhotoTVC.m
//  SPoT
//
//  Created by Pierre Thelusma on 10/15/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "FlickrPhotoTVC.h"
#import "FlickrFetcher.h"
#import "RecentPhotos.h"

@interface FlickrPhotoTVC () <UISplitViewControllerDelegate>

@end

@implementation FlickrPhotoTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) awakeFromNib
{
    self.splitViewController.delegate = self;
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

- (void) setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    [self.tableView reloadData];
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
                if([segue.destinationViewController respondsToSelector:@selector(setPhoto:)])
                {
                    NSDictionary* photo = self.photos[indexPath.item];
                    [RecentPhotos addPhoto:photo];
                    
                    [segue.destinationViewController performSelector:@selector(setPhoto:) withObject:photo];
                    [segue.destinationViewController setTitle:[self titleForRow:indexPath.item]];
                }
            }
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController = [self.splitViewController.viewControllers lastObject];
    
    if([viewController respondsToSelector:@selector(setPhoto:)])
    {
        NSDictionary* photo = self.photos[indexPath.item];
        [RecentPhotos addPhoto:photo];
        
        [viewController performSelector:@selector(setPhoto:) withObject:photo];
        [viewController setTitle:[self titleForRow:indexPath.item]];
    }
    
    
}

- (NSString *) titleForRow:(NSUInteger)row
{
    return [self.photos[row][FLICKR_PHOTO_TITLE] description];
}

- (NSString *) subtitleForRow:(NSUInteger)row
{
    return [self.photos[row][FLICKR_PHOTO_OWNER] description];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Photos";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [[self titleForRow:indexPath.row] capitalizedString];
    
    cell.detailTextLabel.text = [[self subtitleForRow:indexPath.row] capitalizedString];
    
    return cell;
}

@end
