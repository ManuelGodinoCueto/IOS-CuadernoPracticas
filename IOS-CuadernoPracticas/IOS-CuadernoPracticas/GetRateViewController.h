//
//  GetRateViewController.h
//  IOS-CuadernoPracticas
//
//  Created by Manuel Godino Cueto on 23/08/13.
//  Copyright (c) 2013 Manuel Godino Cueto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServices.h"

@interface GetRateViewController : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) NSString *folder;
@property (strong, nonatomic) NSString *video;

@end
