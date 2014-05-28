//
//  PracticeFollowersViewController.h
//  IOS-CuadernoPracticas
//
//  Created by Manuel Godino Cueto on 26/07/13.
//  Copyright (c) 2013 Manuel Godino Cueto. All rights reserved.
//

#import "MasterSplitTableViewController.h"
#import <Social/Social.h>

@interface PracticeFollowersViewController : MasterSplitTableViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSString *practiceSelected;

@end
