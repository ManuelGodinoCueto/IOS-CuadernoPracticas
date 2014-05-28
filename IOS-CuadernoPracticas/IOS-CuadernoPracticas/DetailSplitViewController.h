//
//  DetailSplitViewController.h
//  IOS-CuadernoPracticas
//
//  Created by Manuel Godino Cueto on 25/07/13.
//  Copyright (c) 2013 Manuel Godino Cueto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailSplitViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) NSString *folder;
@property (strong, nonatomic) NSString *video;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
