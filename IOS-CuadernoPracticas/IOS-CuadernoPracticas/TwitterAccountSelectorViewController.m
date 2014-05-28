//
//  TwitterAccountSelectorViewController.m
//  IOS-CuadernoPracticas
//
//  Created by Manuel Godino Cueto on 17/07/13.
//  Copyright (c) 2013 Manuel Godino Cueto. All rights reserved.
//

#import "TwitterAccountSelectorViewController.h"
#import <Accounts/Accounts.h>
#import "WebServices.h"

@interface TwitterAccountSelectorViewController ()

@end

@implementation TwitterAccountSelectorViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    // Clear selected rol
    [[NSUserDefaults standardUserDefaults] setObject:Nil forKey:@"twitterUsernameSelectedRol"];
    [self obtainTwitterAccounts];
    [self loadUserLastDecision];
}

-(void)reloadView
{
    [self obtainTwitterAccounts];
    [self loadUserLastDecision];
}
// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Load the last user selection from Picker
// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void)loadUserLastDecision
{
    // If number of Twitter accounts changed check if selected Twitter account still exist and update the index on user defaults
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"numberOfTwitterAccounts"] && self.twitterAccounts.count != [[NSUserDefaults standardUserDefaults] integerForKey:@"numberOfTwitterAccounts"]) {
        BOOL selectedTwitterAccountWasRemoved = YES;
        for (ACAccount *twitterAccount in self.twitterAccounts) {
            if ([twitterAccount.identifier isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"twitterUsernameSelected"]]) {
                [[NSUserDefaults standardUserDefaults] setInteger:[self.twitterAccounts indexOfObject:twitterAccount] forKey:@"mySelectedRow"];
                selectedTwitterAccountWasRemoved = NO;
                break;
            }
        }
        
        // If Twitter account was removed, remove user defaults selected row
        if (selectedTwitterAccountWasRemoved) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"twitterUsernameSelected"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mySelectedRow"];
        }
    }
    
    // Save the number of Twitter accounts to UserDefaults o control if they change
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"twitterUsernameSelected"]) {
        [[NSUserDefaults standardUserDefaults] setInteger:[self.twitterAccounts count] forKey:@"numberOfTwitterAccounts"];
    }
    
    [self.picker selectRow:(NSInteger)[[NSUserDefaults standardUserDefaults] integerForKey:@"mySelectedRow"] inComponent:0 animated:YES];
}

#pragma mark - Obtain Twitter Accounts

// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtain Twitter Accounts from IOS Account Store
//  - set them to the NSArray *twitterAccounts
//  - set the usernames to the NSArray *pickerRowValues
// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void)obtainTwitterAccounts
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // Obtain all Twitter accounts and set the data array
    NSArray *twitterAccounts = [accountStore accountsWithAccountType:twitterAccountType];
    self.twitterAccounts = twitterAccounts;
    
    // If don't get any Twitter account, request for permission to system (firs time application run case)
    // Request for permission is expensive in time, so it is better to request only if didn't get any
    if (![twitterAccounts count]) {
        [accountStore requestAccessToAccountsWithType:twitterAccountType
                                              options:nil
                                           completion:^(BOOL granted, NSError *error) {
                                               if (granted) {
                                                   NSArray *twitterAccounts = [accountStore accountsWithAccountType:twitterAccountType];
                                                   self.twitterAccounts = twitterAccounts;
                                                   // Get only the usernames of Twitter accounts
                                                   NSArray *twitterUsernames = [self obtainUsernamesFromTwitterAccounts:twitterAccounts];
                                                   self.pickerRowValues = twitterUsernames;
                                               }
                                           }
         ];
    } else {
        // Get only the usernames of Twitter accounts
        NSArray *twitterUsernames = [self obtainUsernamesFromTwitterAccounts:twitterAccounts];
        self.pickerRowValues = twitterUsernames;
    }
}

// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Return Twitter usernames from an Accountstore array with Twitter Account type
// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(NSArray *)obtainUsernamesFromTwitterAccounts:(NSArray *)twitterAccounts
{
    NSMutableArray *twitterUsernames = [NSMutableArray arrayWithCapacity:[twitterAccounts count]];
    
    for (id account in twitterAccounts) {
        [twitterUsernames addObject:[account accountDescription]];
    }
    
    return twitterUsernames;
}

#pragma mark - Select Account

-(IBAction)selectAccount
{
    [self.activityIndicator startAnimating];
    
    // Clear error message from Label
    self.errorLabel.text = nil;
    
    // Check if there are Twitter accounts
    if ([self.twitterAccounts count]) {
        
        // Get the Twitter account selecter from Picker
        NSString *twitterUsernameSelected = [[self.twitterAccounts objectAtIndex:[self.picker selectedRowInComponent:0]] accountDescription];
        
        // Save selection to User Defaults
        // Save username
        [[NSUserDefaults standardUserDefaults] setObject:twitterUsernameSelected forKey:@"twitterUsernameSelected"];
        // Save ID
        NSString *twitterID = [[self.twitterAccounts objectAtIndex:[self.picker selectedRowInComponent:0]] identifier];
        [[NSUserDefaults standardUserDefaults] setObject:twitterID forKey:@"twitterID"];
        // Save number of row selected
        [[NSUserDefaults standardUserDefaults] setInteger:[self.picker selectedRowInComponent:0] forKey:@"mySelectedRow"];
        
        // Obtain the rol of the Twitter Account
        dispatch_queue_t queue = dispatch_queue_create("obtainRolFromTwitterAccountSelected", NULL);
        dispatch_async(queue, ^{
            NSString *rol = [WebServices getRolFromTwitterAccount:twitterUsernameSelected];
            
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self.activityIndicator stopAnimating];
                if (rol) {
                    // Perform Segue depending of the rol
                    if ([rol isEqualToString:@"Professor"]) {
                        [[NSUserDefaults standardUserDefaults] setObject:rol forKey:@"twitterUsernameSelectedRol"];
                        [self performSegueWithIdentifier:@"professorSegue" sender:self];
                    } else if ([rol isEqualToString:@"Student"]) {
                        [[NSUserDefaults standardUserDefaults] setObject:rol forKey:@"twitterUsernameSelectedRol"];
                        [self performSegueWithIdentifier:@"studentSegue" sender:self];
                    } else {
                        // Not a professor or Student
                        [self showErrorMessage:[[NSUserDefaults standardUserDefaults] stringForKey:@"notAProfessorOrStudentErrorMessage"] toUILabel:self.errorLabel];
                    }
                } else {
                    // Show message eror.
                    NSString *errorMessage = [[NSUserDefaults standardUserDefaults] stringForKey:@"connectionErrorMessage"];
                    [self showErrorMessage:errorMessage toUILabel:self.errorLabel];
                }
            });
        });
    } else {
        // No Twitter accounts
        [self.activityIndicator stopAnimating];
        [self showErrorMessage:[[NSUserDefaults standardUserDefaults] stringForKey:@"notTwitterAccountsErrorMessage"] toUILabel:self.errorLabel];
    }
}

// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Show an error message to an UILabel
// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-(void)showErrorMessage:(NSString *)error toUILabel:(UILabel *)label
{
    [UIView transitionWithView:self.errorLabel
                      duration:0.75
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        label.text = error;
                        [label setTextColor:[UIColor redColor]];
                    }
                    completion:nil
     ];
}

@end
