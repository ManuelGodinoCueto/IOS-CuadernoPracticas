//
//  RateViewController.m
//  IOS-CuadernoPracticas
//
//  Created by Manuel Godino Cueto on 20/08/13.
//  Copyright (c) 2013 Manuel Godino Cueto. All rights reserved.
//

#import "RateViewController.h"

@interface RateViewController ()

@end

@implementation RateViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    // Set navigationBar title
    self.navigationBar.topItem.title = [NSString stringWithFormat:@"%@ - %@",self.video, self.folder];
    
    [self.activityIndicator startAnimating];
    
    dispatch_queue_t queue = dispatch_queue_create("getRateForPractice", NULL);
    dispatch_async(queue, ^{
        id response = [WebServices getRateForPractice:self.folder andFollower:self.video];
        dispatch_async(dispatch_get_main_queue(), ^ {
            if ([response isKindOfClass:[NSDictionary class]]) {
                // Practice rated
                NSString *rate = [response objectForKey:@"Rate"];
                NSString *comment = [response objectForKey:@"Comment"];
                
                NSScanner *ns = [NSScanner scannerWithString:rate];
                float floatRate;
                if ([ns scanFloat:&floatRate]) {
                    self.sendButton.enabled = YES;
                    self.label.text = rate;
                    self.textView.text = comment;
                    
                    if (floatRate < 5.0) {
                        [self.label setTextColor:[UIColor redColor]];
                    } else {
                        [self.label setTextColor:[UIColor greenColor]];
                    }
                    [self.slider setValue:floatRate animated:NO];
                }
            } else if ([response isKindOfClass:[NSString class]]) {
                // Practice not yet rated so adjust size to show not rated message
                self.label.font = [UIFont systemFontOfSize:20.0];
                self.label.text = @"Práctica sin calificar";
            }
            
            // Add horizontal line o separate slider from textView
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 190, self.view.bounds.size.width, 1)];
            lineView.backgroundColor = [UIColor grayColor];
            [self.view addSubview:lineView];
            
            [self.textView becomeFirstResponder];
            
            [self.activityIndicator stopAnimating];
        });
    });
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    self.sendButton.enabled = YES;
    self.label.text = [NSString stringWithFormat:@"%.1f", [sender value]];
    if (sender.value < 5.0) {
        [self.label setTextColor:[UIColor redColor]];
    } else {
        [self.label setTextColor:[UIColor greenColor]];
    }
}

- (IBAction)sendButtonPressed:(UIBarButtonItem *)sender {
    NSString *comment = self.textView.text;
    dispatch_queue_t queue = dispatch_queue_create("rate", NULL);
    dispatch_async(queue, ^{
        NSString *message = [WebServices setRate:self.label.text withComment:comment forPractice:self.folder andFollower:self.video];
        UIAlertView *openURLAlert = [[UIAlertView alloc] initWithTitle:@"Calificar vídeo" message:message delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^ {
            [openURLAlert show];
        });
    });
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
    
}

@end
