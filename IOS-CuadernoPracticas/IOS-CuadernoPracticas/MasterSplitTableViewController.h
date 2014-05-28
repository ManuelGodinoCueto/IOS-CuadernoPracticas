//
//  MasterSplitTableViewController.h
//  IOS-CuadernoPracticas
//
//  Created by Manuel Godino Cueto on 29/03/13.
//  Copyright (c) 2013 Manuel Godino Cueto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import "WebServices.h"

@interface MasterSplitTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *tableRowValues;
@property (nonatomic) NSIndexPath *selectedIndexPath;

@end
