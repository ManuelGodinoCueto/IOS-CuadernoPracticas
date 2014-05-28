//
//  GetRateViewController.m
//  IOS-CuadernoPracticas
//
//  Created by Manuel Godino Cueto on 23/08/13.
//  Copyright (c) 2013 Manuel Godino Cueto. All rights reserved.
//

#import "GetRateViewController.h"

@interface GetRateViewController ()

@end

@implementation GetRateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Set navigationBar title
    self.navigationBar.topItem.title = [NSString stringWithFormat:@"Calificación %@", self.folder];
    
    [self.activityIndicator startAnimating];
    
    dispatch_queue_t queue = dispatch_queue_create("getRate", NULL);
    dispatch_async(queue, ^{
        id response = [WebServices getRateForPractice:self.folder andFollower:self.video];
        dispatch_async(dispatch_get_main_queue(), ^ {
            [UIView transitionWithView:self.label
                              duration:0.75
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                if ([response isKindOfClass:[NSDictionary class]]) {
                                    // Practice rated
                                    NSString *rate = [response objectForKey:@"Rate"];
                                    NSString *comment = [response objectForKey:@"Comment"];
                                    
                                    NSScanner *ns = [NSScanner scannerWithString:rate];
                                    float floatRate;
                                    if ([ns scanFloat:&floatRate]) {
                                        self.label.text = rate;
                                        self.textView.text = comment;
                                        
                                        if (floatRate < 5.0) {
                                            [self.label setTextColor:[UIColor redColor]];
                                        } else {
                                            [self.label setTextColor:[UIColor greenColor]];
                                        }
                                    }
                                } else if ([response isKindOfClass:[NSString class]]) {
                                    // Practice not yet rated so adjust size to show not rated message
                                    self.label.font = [UIFont systemFontOfSize:20.0];
                                    self.label.text = @"Práctica sin calificar";
                                }
                                // Add horizontal line o separate slider from textView
                                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.label.center.y +self.label.frame.size.height / 2 + 5.0, self.view.bounds.size.width, 1)];
                                lineView.backgroundColor = [UIColor grayColor];
                                [self.view addSubview:lineView];
                            }
                            completion:nil
             ];
            [self.activityIndicator stopAnimating];
        });
    });
}

- (IBAction)aceptarButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

@end
