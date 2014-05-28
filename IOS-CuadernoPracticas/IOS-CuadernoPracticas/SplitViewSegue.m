//
//  SplitViewSegue.m
//  IOS-CuadernoPracticas
//
//  Created by Manuel Godino Cueto on 18/07/13.
//  Copyright (c) 2013 Manuel Godino Cueto. All rights reserved.
//

#import "SplitViewSegue.h"

@implementation SplitViewSegue

-(void)perform
{
    UIViewController *sourceViewController      = (UIViewController *)self.sourceViewController;
    UIViewController *destinationViewController = (UIViewController *)self.destinationViewController;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = destinationViewController;
    window.rootViewController = sourceViewController;
    
    [UIView transitionWithView:sourceViewController.view.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        window.rootViewController = destinationViewController;
                    }
                    completion:^(BOOL finished){
                    }
     ];
}

@end
