//
//  TwitterAccountSelectorViewController.h
//  IOS-CuadernoPracticas
//
//  Created by Manuel Godino Cueto on 17/07/13.
//  Copyright (c) 2013 Manuel Godino Cueto. All rights reserved.
//

#import "PickerViewController.h"

@interface TwitterAccountSelectorViewController : PickerViewController

@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

//  Twitter accounts added to IOS with the next information:
//
//    type:(null)
//    identifier: 0A0A0A0A-0A0A-0A0A-0A0A-0A0A0A0A0A0A
//    accountDescription: @0A0A0A0A0A0
//    username: 0A0A0A0A0A
//    objectID: x-coredata://0A0A0A0A-0A0A-0A0A-0A0A-0A0A0A0A0A0A/Account/p95
//    enabledDataclasses: {
//        ()
//    }
//    enableAndSyncableDataclasses: {
//        ()
//    }
//    properties: {
//        "user_id" = 0000000000;
//    }
//    parentAccount: (null)
//    owningBundleID:(null)
@property (strong, nonatomic) NSArray *twitterAccounts;

@end
