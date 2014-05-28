//
//  PracticasViewController.m
//  IOS-CuadernoPracticas
//
//  Created by Manuel Godino Cueto on 19/07/13.
//  Copyright (c) 2013 Manuel Godino Cueto. All rights reserved.
//

#import "FollowerPracticesViewController.h"

@interface FollowerPracticesViewController ()

@end

@implementation FollowerPracticesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.refreshControl addTarget:self action:@selector(loadFollowerSelectedPracticesWithOptionalRefreshControl:withOptionalActivityIndicator:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.title = self.followerSelected;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.selectedIndexPath) {
        [self loadFollowerSelectedPracticesWithOptionalRefreshControl:nil withOptionalActivityIndicator:self.activityIndicator];
    } else {
        [self.tableView selectRowAtIndexPath:self.selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void) loadFollowerSelectedPracticesWithOptionalRefreshControl:(UIRefreshControl *) refreshControl withOptionalActivityIndicator:(UIActivityIndicatorView *) activityIndicator
{
    self.selectedIndexPath = Nil;
    [refreshControl beginRefreshing];
    
    activityIndicator.center = self.view.center;
    [activityIndicator startAnimating];
    
    dispatch_queue_t queue = dispatch_queue_create("obtainPracticesForFollower", NULL);
    dispatch_async(queue, ^{
        NSArray *obtainPracticesForFollower = [WebServices getPracticesForFollower:self.followerSelected];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            self.tableRowValues = obtainPracticesForFollower;
            
            [activityIndicator stopAnimating];
            [refreshControl endRefreshing];
        });
    });
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView cellForRowAtIndexPath:indexPath];
    // Create cell to set information
    static NSString *CellIdentifier = @"Practice";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Set cell with directory name
    cell.textLabel.text = [self.tableRowValues objectAtIndex:indexPath.row];
    // Set cell accesory type
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Return a cell with the follower username and profile image
    return cell;
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            self.selectedIndexPath = indexPath;
            if ([segue.identifier isEqualToString:@"practicesForUserToDetailSegue"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setFolder:)]) {
                    NSString *practiceForfollowerSelected = [self.tableRowValues objectAtIndex:indexPath.row];
                    [segue.destinationViewController performSelector:@selector(setFolder:) withObject:practiceForfollowerSelected];
                }
                
                if ([segue.destinationViewController respondsToSelector:@selector(setVideo:)]) {
                    [segue.destinationViewController performSelector:@selector(setVideo:) withObject:self.followerSelected];
                }
            }
        }
    }
    
}

@end
