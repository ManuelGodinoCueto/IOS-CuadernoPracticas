//
//  PickerViewController.m
//  IOS-CuadernoPracticas
//
//  Created by Manuel Godino Cueto on 17/07/13.
//  Copyright (c) 2013 Manuel Godino Cueto. All rights reserved.
//

#import "PickerViewController.h"

@interface PickerViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation PickerViewController

#pragma mark - UIPickerViewDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // At least 1 row if the array is empty
    return [self.pickerRowValues count] == 0 ? 1 : [self.pickerRowValues count];
}

#pragma mark - UIPickerViewDelegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // Empty string if there is no value
    return [self.pickerRowValues objectAtIndex:row] ? [self.pickerRowValues objectAtIndex:row] : @"";
}

@end