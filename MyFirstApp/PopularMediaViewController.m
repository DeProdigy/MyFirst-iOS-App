//
//  PopularMediaViewController.m
//  MyFirstApp
//
//  Created by Alex Hint on 2/22/14.
//  Copyright (c) 2014 Alex Hint. All rights reserved.
//

#import "PopularMediaViewController.h"
#import "MediaController.h"
#import "MediaObject.h"
#import "ImageViewController.h"

@interface PopularMediaViewController ()

@end


@interface PopularMediaViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MediaController *mediaManager;

@end


@implementation PopularMediaViewController

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
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Media";
    
    self.mediaManager = [[MediaController alloc] init];
    [self updateContent];
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(didTapRefresh:)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    //change bar's color to black
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setTintColor:[UIColor blackColor]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageViewController *viewController = [[ImageViewController alloc] initWithNibName:@"ImageViewController" bundle:Nil];
    viewController.mediaObject = [self.mediaManager.mediaObjects objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UITableView Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Get the mediaObject at indexPath.row
    // Set the cell's textLabel to the mediaObject's username
    MediaObject *mediaObject = [self.mediaManager.mediaObjects objectAtIndex:indexPath.row];
    cell.textLabel.text = mediaObject.username;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:18];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of objects in the self.mediaManager.mediaObjects array
    return [self.mediaManager.mediaObjects count];
}

- (void)updateContent
{
    __weak PopularMediaViewController *weakSelf = self;
    [self.mediaManager fetchPopularMediaWithCompletionBlock:^(BOOL success) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            //prevent the user from tapping on the refrsh button while the pro
            //[weakSelf enableRefreshButton:YES];
            
            if (success)
            {
                // Reload the tableview here
                [weakSelf.tableView reloadData];
            }
            else
            {
                // Alert the user that the request failed
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Uh Oh!"
                                                                 message:@"An error occurred"
                                                                delegate:nil
                                                       cancelButtonTitle:@"Okay"
                                                       otherButtonTitles:nil];
                [alert show];
            }
        });
    }];
}

- (void)didTapRefresh:(UIBarButtonItem *)sender
{
    [self updateContent];
}


@end






