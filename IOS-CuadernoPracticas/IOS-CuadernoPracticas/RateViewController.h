//
//  RateViewController.h
//  IOS-CuadernoPracticas
//
//  Created by Manuel Godino Cueto on 20/08/13.
//  Copyright (c) 2013 Manuel Godino Cueto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServices.h"

@interface RateViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) NSString *folder;
@property (strong, nonatomic) NSString *video;

@end
