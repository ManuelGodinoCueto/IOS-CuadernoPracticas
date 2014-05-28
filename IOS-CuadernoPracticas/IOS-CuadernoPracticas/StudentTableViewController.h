//
//  StudentTableViewController.h
//  IOS-CuadernoPracticas
//
//  Created by Manuel Godino Cueto on 26/07/13.
//  Copyright (c) 2013 Manuel Godino Cueto. All rights reserved.
//

#import "MasterSplitTableViewController.h"

@interface StudentTableViewController : MasterSplitTableViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSArray *activePractices;

@end
