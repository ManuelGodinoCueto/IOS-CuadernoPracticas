//
//  FollowerPracticesViewController.h
//  IOS-CuadernoPracticas
//
//  Created by Manuel Godino Cueto on 19/07/13.
//  Copyright (c) 2013 Manuel Godino Cueto. All rights reserved.
//

#import "MasterSplitTableViewController.h"

@interface FollowerPracticesViewController : MasterSplitTableViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSString *followerSelected;

@end
