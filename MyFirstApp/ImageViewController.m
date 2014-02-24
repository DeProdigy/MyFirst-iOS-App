//
//  ImageViewController.m
//  MyFirstApp
//
//  Created by Alex Hint on 2/23/14.
//  Copyright (c) 2014 Alex Hint. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicatorView;

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
    
    self.title = self.mediaObject.username;
    
    // Ensure that our UI elements begin just after the navigationBar rather than beneath it
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupImageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup

- (void)setupImageView
{
    [self.activityIndicatorView startAnimating];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *getImageTask = [session downloadTaskWithURL:self.mediaObject.imageURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200)
        {
            UIImage *downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activityIndicatorView stopAnimating];
                self.imageView.image = downloadedImage;
            });
        }
    }];
    [getImageTask resume];
}

@end
