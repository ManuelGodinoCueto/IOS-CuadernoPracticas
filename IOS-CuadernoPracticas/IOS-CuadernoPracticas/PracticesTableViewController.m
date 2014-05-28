//
//  PracticesTableViewController.m
//  IOS-CuadernoPracticas
//
//  Created by Manuel Godino Cueto on 26/07/13.
//  Copyright (c) 2013 Manuel Godino Cueto. All rights reserved.
//

#import "PracticesTableViewController.h"

@interface PracticesTableViewController ()

@end

@implementation PracticesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.refreshControl addTarget:self action:@selector(loadPracticesTableViewControllerWithOptionalRefreshControl:withOptionalActivityIndicator:) forControlEvents:UIControlEventValueChanged];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadPracticesTableViewControllerWithOptionalRefreshControl:nil withOptionalActivityIndicator:self.activityIndicator];
}

- (void) loadPracticesTableViewControllerWithOptionalRefreshControl:(UIRefreshControl *) refreshControl withOptionalActivityIndicator:(UIActivityIndicatorView *) activityIndicator
{
    [refreshControl beginRefreshing];
    
    activityIndicator.center = self.view.center;
    [activityIndicator startAnimating];
    
    dispatch_queue_t queue = dispatch_queue_create("getFolders", NULL);
    dispatch_async(queue, ^{
        NSArray *practices = [WebServices getPractices];
        // Set cell with user profile image asynchronously
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableRowValues = practices;            
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
    
    // Set cell text with folder name
    cell.textLabel.text = [self.tableRowValues objectAtIndex:indexPath.row];
    // Set cell image
    UIImage *image = [UIImage imageNamed:@"folder.png"];
    cell.imageView.image = image;
    
    return cell;
}

#pragma mark - Table view data delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"practicesToFollowersForFolderReplaceDetailSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"practicesToFollowersForFolderSegue"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setPracticeSelected:)]) {
                    NSString *practiceSelected = [self.tableRowValues objectAtIndex:indexPath.row];
                    [segue.destinationViewController performSelector:@selector(setPracticeSelected:) withObject:practiceSelected];
                }
            } else if ([segue.identifier isEqualToString:@"practicesToFollowersForFolderReplaceDetailSegue"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setFolder:)]) {
                    NSString *practiceForfollowerSelected = [self.tableRowValues objectAtIndex:indexPath.row];
                    [segue.destinationViewController performSelector:@selector(setFolder:) withObject:practiceForfollowerSelected];
                }
            }
        }
    }
}

@end
