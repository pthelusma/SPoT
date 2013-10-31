//
//  ImageViewController.m
//  SPoT
//
//  Created by Pierre Thelusma on 10/15/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "ImageViewController.h"
#import "FlickrFetcher.h"
#import "NetworkActivity.h"
#import "Cache.h"

@interface ImageViewController () <UIScrollViewDelegate, UISplitViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ImageViewController

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
	[self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 5.0;
    self.scrollView.delegate = self;
    self.activityIndicator.hidesWhenStopped = true;
    [self resetImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self resetImage];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.imageView.image = nil;
}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void) setPhoto:(NSDictionary *)photo
{
    _photo = photo;
    
    FlickrPhotoFormat flickrPhotoFormat = FlickrPhotoFormatLarge;
    
    if([self isIpad])
    {
        flickrPhotoFormat = FlickrPhotoFormatOriginal;
    }
        
    _imageURL = [FlickrFetcher urlForPhoto:photo format:flickrPhotoFormat];
    [self resetImage];
}

- (void) setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    
    NSLog(@"%@", [imageURL path]);
    
    [self resetImage];
}

- (BOOL) isIpad
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (void) resetImage
{
    if(self.scrollView)
    {
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        
        
        NSURL *imageURL = self.imageURL;
        
        if(imageURL)
        {
            [self.activityIndicator startAnimating];
            
            dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);
            dispatch_async(downloadQueue, ^{
                
                Cache *cache = [[Cache alloc] init];
                NSData *imageData;
                NSURL *cachedURL = [cache getCachedURL:imageURL];
                
                if ([cache fileExists:cachedURL]) {
                    imageData = [[NSData alloc] initWithContentsOfURL:cachedURL];
                } else
                {
                    [NetworkActivity startIndicator];
                    imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
                    [NetworkActivity stopIndicator];
                    [cache cacheData:imageData usingURL:self.imageURL];
                }
                
                UIImage  *image = [[UIImage alloc] initWithData:imageData];

                if(self.imageURL == imageURL){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if(image)
                        {
                            self.scrollView.zoomScale = 1.0;
                            self.scrollView.contentSize = image.size;
                            self.imageView.image = image;
                            self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                            
                            [self adjustZoom];
                            
                        }
                        [self.activityIndicator stopAnimating];
                        
                    });
                }
            });
        }
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self adjustZoom];
}

- (UIImageView *)imageView
{
    if(!_imageView)
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    
    return _imageView;
}

- (void) adjustZoom
{
    double widthScale = self.scrollView.bounds.size.width/self.imageView.image.size.width;
    double heightScale = self.scrollView.bounds.size.height/self.imageView.image.size.height;
    
    self.scrollView.zoomScale = widthScale > heightScale ? widthScale : heightScale;
}

@end
