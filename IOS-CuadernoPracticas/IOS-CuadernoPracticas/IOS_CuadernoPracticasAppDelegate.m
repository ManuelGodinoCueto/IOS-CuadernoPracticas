//
//  IOS_CuadernoPracticasAppDelegate.m
//  IOS-CuadernoPracticas
//
//  Created by Manuel Godino Cueto on 24/03/13.
//  Copyright (c) 2013 Manuel Godino Cueto. All rights reserved.
//

#import "IOS_CuadernoPracticasAppDelegate.h"
#import "TwitterAccountSelectorViewController.h"

@implementation IOS_CuadernoPracticasAppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}

-(void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

-(void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

-(void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    UIViewController* viewController = self.window.rootViewController;
    if ([viewController isKindOfClass:[TwitterAccountSelectorViewController class]]) {
        [viewController performSelector:@selector(reloadView)];
    }
}

-(void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

-(void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+(void)initialize
{
    NSString *      initialDefaultsPath = [[NSBundle mainBundle] pathForResource:@"InitialDefaults" ofType:@"plist"];
    NSDictionary *  initialDefaults = [NSDictionary dictionaryWithContentsOfFile:initialDefaultsPath];
    [[NSUserDefaults standardUserDefaults] registerDefaults:initialDefaults];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if (url != Nil && [url isFileURL] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"twitterUsernameSelectedRol"] isEqualToString:@"Professor"]) {
        // Logged as a Professor
        
        // If exist, remove previous PDF imported
        NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:@"importedPDFURL"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:Nil];
        }
        // Save imported PDF path to userDefaults
        [[NSUserDefaults standardUserDefaults] setObject:[url path] forKey:@"importedPDFURL"];
        // Show alert telling user a new PDF has been imported
        NSString *filename = [url lastPathComponent];
        NSString *message = [NSString stringWithFormat:@"Fichero %@ recibido correctamente, seleccione donde desea colocarlo.", filename];
        UIAlertView *openURLAlert = [[UIAlertView alloc] initWithTitle:@"PDF recibido" message:message delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [openURLAlert show];
        return YES;
    } else {
        // Not logged as a Professor
        NSString *message = @"Inicie sesión como profesor para publicar PDF's.";
        UIAlertView *openURLAlert = [[UIAlertView alloc] initWithTitle:@"Error en la importación" message:message delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [openURLAlert show];
        return NO;
    }
}

@end
