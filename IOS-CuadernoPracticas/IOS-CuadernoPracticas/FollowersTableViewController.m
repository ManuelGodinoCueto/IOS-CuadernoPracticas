//
//  FollowersTableViewController.m
//  IOS-CuadernoPracticas
//
//  Created by Manuel Godino Cueto on 29/03/13.
//  Copyright (c) 2013 Manuel Godino Cueto. All rights reserved.
//

#import "FollowersTableViewController.h"

@interface FollowersTableViewController ()

@end

@implementation FollowersTableViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.refreshControl addTarget:self action:@selector(loadFollowersTableViewControllerWithOptionalRefreshControl:withOptionalActivityIndicator:) forControlEvents:UIControlEventValueChanged];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadFollowersTableViewControllerWithOptionalRefreshControl:nil withOptionalActivityIndicator:self.activityIndicator];
}

// TODO: Use cursor to navigate collections: https://dev.twitter.com/docs/misc/cursoring
-(void) loadFollowersTableViewControllerWithOptionalRefreshControl:(UIRefreshControl *) refreshControl withOptionalActivityIndicator:(UIActivityIndicatorView *) activityIndicator
{
    [refreshControl beginRefreshing];
    
    activityIndicator.center = self.view.center;
    [activityIndicator startAnimating];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccount *twitterAccount = [accountStore accountWithIdentifier:[[NSUserDefaults standardUserDefaults] stringForKey:@"twitterID"]];
    
    NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/followers/list.json"];
    SLRequest *postRequest = [SLRequest
                              requestForServiceType:SLServiceTypeTwitter
                              requestMethod:SLRequestMethodGET
                              URL:requestURL parameters:nil];
    
    postRequest.account = twitterAccount;
    
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSArray *requestData;
        NSArray *activeUsers;
        if (responseData) {
            requestData = [[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error] objectForKey:@"users"];
            activeUsers = [WebServices getActiveFollowers];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            self.tableRowValues = requestData;
            self.activeUsers = activeUsers;
            
            [activityIndicator stopAnimating];
            [refreshControl endRefreshing];
        });
    }];
}

#pragma mark - Table view data source

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView cellForRowAtIndexPath:indexPath];
    // Create cell to set information
    static NSString *CellIdentifier = @"Follower";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Get follower username
    NSString *name = [NSString stringWithFormat:@"@%@",[[self.tableRowValues objectAtIndex:indexPath.row] objectForKey:@"screen_name"]];
    // Set cell with username
    cell.textLabel.text = name;
    // Set cell accesory type depending on activity of the user
    if (![self.activeUsers containsObject:name]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.userInteractionEnabled = NO;
    }
    
    // Get follower profile image
    dispatch_queue_t queue = dispatch_queue_create("getUserImage", NULL);
    dispatch_async(queue, ^{
        NSString *urlString = [[self.tableRowValues objectAtIndex:indexPath.row] objectForKey:@"profile_image_url_https"];
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        // Set cell with user profile image asynchronously
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = image;
            [cell setNeedsLayout];
        });
    });
    
    // Return a cell with the follower username and profile image
    return cell;
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"followerToPracticesForUserSegue"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setFollowerSelected:)]) {
                    NSString *followerSelected = [NSString stringWithFormat:@"@%@",[[self.tableRowValues objectAtIndex:indexPath.row] objectForKey:@"screen_name"]];
                    [segue.destinationViewController performSelector:@selector(setFollowerSelected:) withObject:followerSelected];
                }
            }
        }
    }
    
}

@end