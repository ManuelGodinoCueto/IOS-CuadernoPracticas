//
//  FollowersTableViewController.h
//  IOS-CuadernoPracticas
//
//  Created by Manuel Godino Cueto on 29/03/13.
//  Copyright (c) 2013 Manuel Godino Cueto. All rights reserved.
//

#import "MasterSplitTableViewController.h"
#import <Social/Social.h>

@interface FollowersTableViewController : MasterSplitTableViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSArray *activeUsers;

@end
