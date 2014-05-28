//
//  StudentTableViewController.m
//  IOS-CuadernoPracticas
//
//  Created by Manuel Godino Cueto on 26/07/13.
//  Copyright (c) 2013 Manuel Godino Cueto. All rights reserved.
//

#import "StudentTableViewController.h"

@interface StudentTableViewController ()

@end

@implementation StudentTableViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.refreshControl addTarget:self action:@selector(loadPracticesTableViewControllerWithOptionalRefreshControl:withOptionalActivityIndicator:) forControlEvents:UIControlEventValueChanged];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.selectedIndexPath) {
        [self loadPracticesTableViewControllerWithOptionalRefreshControl:nil withOptionalActivityIndicator:self.activityIndicator];
    } else {
        [self.tableView selectRowAtIndexPath:self.selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}

-(void) loadPracticesTableViewControllerWithOptionalRefreshControl:(UIRefreshControl *) refreshControl withOptionalActivityIndicator:(UIActivityIndicatorView *) activityIndicator
{
    self.selectedIndexPath = Nil;
    
    [refreshControl beginRefreshing];
    activityIndicator.center = self.view.center;
    [activityIndicator startAnimating];
    
    dispatch_queue_t queue = dispatch_queue_create("getFolders", NULL);
    dispatch_async(queue, ^{
        NSArray *practices = [WebServices getPractices];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableRowValues = practices;
            [activityIndicator stopAnimating];
            [refreshControl endRefreshing];
        });
    });
}

#pragma mark - Table view data source

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView cellForRowAtIndexPath:indexPath];
    // Create cell to set information
    static NSString *CellIdentifier = @"Practice";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Set cell with folder name
    cell.textLabel.text = [self.tableRowValues objectAtIndex:indexPath.row];
    // Set image cell
    UIImage *image = [UIImage imageNamed:@"folder.png"];
    cell.imageView.image = image;
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
            if ([segue.identifier isEqualToString:@"practiceForStudentToDetailSegue"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setFolder:)]) {
                    NSString *practiceForfollowerSelected = [self.tableRowValues objectAtIndex:indexPath.row];
                    [segue.destinationViewController performSelector:@selector(setFolder:) withObject:practiceForfollowerSelected];
                }
                
                if ([segue.destinationViewController respondsToSelector:@selector(setVideo:)]) {
                    [segue.destinationViewController performSelector:@selector(setVideo:) withObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"twitterUsernameSelected"]];
                }
            }
        }
    }
    
}
@end
