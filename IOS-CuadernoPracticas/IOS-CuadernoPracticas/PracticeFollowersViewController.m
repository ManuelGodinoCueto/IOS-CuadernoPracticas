//
//  PracticeFollowersViewController.m
//  IOS-CuadernoPracticas
//
//  Created by Manuel Godino Cueto on 26/07/13.
//  Copyright (c) 2013 Manuel Godino Cueto. All rights reserved.
//

#import "PracticeFollowersViewController.h"

@interface PracticeFollowersViewController ()

@end

@implementation PracticeFollowersViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.refreshControl addTarget:self action:@selector(loadPracticeSelectedFollowersWithOptionalRefreshControl:withOptionalActivityIndicator:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.title = self.practiceSelected;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.selectedIndexPath) {
        [self loadPracticeSelectedFollowersWithOptionalRefreshControl:nil withOptionalActivityIndicator:self.activityIndicator];
    } else {
        [self.tableView selectRowAtIndexPath:self.selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        
    }
}

-(void) loadPracticeSelectedFollowersWithOptionalRefreshControl:(UIRefreshControl *) refreshControl withOptionalActivityIndicator:(UIActivityIndicatorView *) activityIndicator
{
    self.selectedIndexPath = Nil;
    
    [refreshControl beginRefreshing];
    activityIndicator.center = self.view.center;
    [activityIndicator startAnimating];
    
    dispatch_queue_t queue = dispatch_queue_create("obtainFollowersForPractice", NULL);
    dispatch_async(queue, ^{
        NSArray *obtainFollowersForPractice = [WebServices getFollowersForPractice:self.practiceSelected];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            self.tableRowValues = obtainFollowersForPractice;
            
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
    static NSString *CellIdentifier = @"Follower";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Set cell with directory name
    cell.textLabel.text = [self.tableRowValues objectAtIndex:indexPath.row];
    // Set cell accesory type
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Set profile image
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccount *twitterAccount = [accountStore accountWithIdentifier:[[NSUserDefaults standardUserDefaults] stringForKey:@"twitterID"]];
    
    NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"];
    SLRequest *postRequest = [SLRequest
                              requestForServiceType:SLServiceTypeTwitter
                              requestMethod:SLRequestMethodGET
                              URL:requestURL
                              parameters:[NSDictionary dictionaryWithObject:[self.tableRowValues objectAtIndex:indexPath.row] forKey:@"screen_name"]];
    
    postRequest.account = twitterAccount;
    dispatch_queue_t queue = dispatch_queue_create("getUserImasssssge", NULL);
    dispatch_async(queue, ^{
        
        NSURLRequest *request = [postRequest preparedURLRequest];
        NSURLResponse *response;
        NSError *error;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *requestData = [[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error] objectForKey:@"profile_image_url_https"];
        NSURL *url = [NSURL URLWithString:requestData];
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
            self.selectedIndexPath = indexPath;
            if ([segue.identifier isEqualToString:@"followersForPracticeToDetailSegue"]) {
                
                if ([segue.destinationViewController respondsToSelector:@selector(setFolder:)]) {
                    [segue.destinationViewController performSelector:@selector(setFolder:) withObject:self.practiceSelected];
                }
                
                if ([segue.destinationViewController respondsToSelector:@selector(setVideo:)]) {
                    NSString *followerForPracticeSelected = [self.tableRowValues objectAtIndex:indexPath.row];
                    [segue.destinationViewController performSelector:@selector(setVideo:) withObject:followerForPracticeSelected];
                }
                
            }
        }
    }
    
}
@end
