//
//  FlickerTagTVC.m
//  SPoT
//
//  Created by Pierre Thelusma on 10/13/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "FlickerTagTVC.h"
#import "FlickrFetcher.h"
#import "Tag.h"

@interface FlickerTagTVC ()

@end

@implementation FlickerTagTVC

- (NSArray *) tagExceptions
{
    return @[@"cs193pspot", @"portrait", @"landscape"];
}

- (void) setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    for(NSDictionary *photo in photos)
    {
        for(NSString *tag in [photo[FLICKR_TAGS] componentsSeparatedByString:@" "])
        {
//            if(![[self tagExceptions] containsObject:tag])
//            {
//                Tag *foundTag = nil;
//                
//                if([self findTag:tag])
//                {
//                    [self findTag:tag].count += 1;
//                } else
//                {
//                    [self.tags addObject:[[Tag alloc] initWithName:tag]];
//                }
//                
//                foundTag = [self findTag:tag];
//                [foundTag.photos addObject:photo];
//            }
        }
    }
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [self.tags sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    [self.tableView reloadData];
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
                if([segue.destinationViewController respondsToSelector:@selector(setPhotos:)])
                {
                    
//                    Tag *tag = [self findTag:[self tagForRow:indexPath.row]];
//                    
//                    NSArray *photos = [tag photos];
//                    
//                    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:FLICKR_PHOTO_TITLE  ascending:YES];
//                    
//                    photos = [photos sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor, nil]];
//                    
//                    [segue.destinationViewController performSelector:@selector(setPhotos:) withObject:photos];
//                    [segue.destinationViewController setTitle:[tag.name capitalizedString]];
                }
            }
        }
    }
}

- (Tag *) findTag: (NSString *) tagName
{
    
    Tag *foundTag = nil;
    
    for(Tag *tag in self.tags)
    {
//        if([[tag name] isEqualToString: tagName])
//        {
//            foundTag = tag;
//        }
    }
    
    return foundTag;
    
}

- (NSMutableArray *) tags
{
    if(!_tags)
    {
        _tags = [[NSMutableArray alloc] init];
    }
    
    return _tags;
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tags count];
}

- (NSString *) tagForRow:(NSUInteger)row
{
    return [self.tags[row] name];
}

- (NSInteger) countForRow:(NSUInteger)row
{    
    return [[self.tags[row] photos] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Tags";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [[self tagForRow:indexPath.row] capitalizedString];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[self countForRow:indexPath.row]];
    
    return cell;
}

@end
