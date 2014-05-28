//
//  MasterSplitTableViewController.m
//  IOS-CuadernoPracticas
//
//  Created by Manuel Godino Cueto on 29/03/13.
//  Copyright (c) 2013 Manuel Godino Cueto. All rights reserved.
//

#import "MasterSplitTableViewController.h"

@interface MasterSplitTableViewController () <UISplitViewControllerDelegate>

@end

@implementation MasterSplitTableViewController;

#pragma mark - Getters & Setters

-(void)setTableRowValues:(NSArray *)tableRowValues
{
    _tableRowValues = tableRowValues;
    [self.tableView reloadData];
}

#pragma mark - View lifecycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self updateTitleWithTwitterAccountSelected];
}

-(void)updateTitleWithTwitterAccountSelected
{
    // Get Twitter account selected from User Defaults
    NSString *twitterAccount = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitterUsernameSelected"];
    // Set title
    self.navigationItem.title = twitterAccount;
}

#pragma mark - UISplitViewControllerDelegate

// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Support all orientations making self as splitViewController delegate and calling to splitViewController:shouldHideViewController:inOrientation UISplitViewControllerDelegate method
// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void)awakeFromNib
{
    self.splitViewController.delegate = self;
}

// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Ensure that the Master View don't hide on landscape
// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableRowValues count];
}

@end
