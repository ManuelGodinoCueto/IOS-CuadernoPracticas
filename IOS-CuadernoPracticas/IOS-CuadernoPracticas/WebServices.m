//
//  WebServices.m
//  IOS-CuadernoPracticas
//
//  Created by Manuel Godino Cueto on 23/07/13.
//  Copyright (c) 2013 Manuel Godino Cueto. All rights reserved.
//

#import "WebServices.h"

@implementation WebServices

// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtain a JSON object with the rol of the Twitter username selected as a parameter from the Web Service declared at "webServiceGetUserRole" and return a NSString with the value.
//
//  The value can be:
//  - Professor
//  - Student
//  - You are not a professor or student.
//
// In case of an error return nil.
// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
+(NSString *)getRolFromTwitterAccount:(NSString *)twitterAccount
{
    NSString *response;
    
    NSString *webServicePath = [[NSUserDefaults standardUserDefaults] stringForKey:@"webServicePath"];
    NSString *webServiceGetUserRole = [[NSUserDefaults standardUserDefaults] stringForKey:@"webServiceGetUserRole"];
    NSURL *url = [NSURL URLWithString:[webServicePath stringByAppendingFormat:webServiceGetUserRole, twitterAccount]];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (jsonData) {
        NSError *error = nil;
        response = [[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error] objectForKey:[[NSUserDefaults standardUserDefaults] stringForKey:@"webServiceJSONResponseKey"]];
    }
    return response;
}

// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtain a list of files from the directory declared in the Service Web "webServiceGetFileList":
//
//    {
//        "Practica 1":[
//                      "@manugodino.MOV",
//                      "Enunciado 1.pdf"
//                      ],
//        "Practica 2":[
//                      "@alumno002.MOV",
//                      "@manugodino.MOV",
//                      "Enunciado 2.pdf"
//                      ],
//        "Practica 3":[
//        ]
//    }
//
//  In case of an error return nil.
// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
+(NSDictionary *)getDirectoryFileList
{
    NSString *twitterUsernameSelected = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitterUsernameSelected"];
    
    NSString *webServicePath = [[NSUserDefaults standardUserDefaults] stringForKey:@"webServicePath"];
    NSString *webServiceGetFileList = [[NSUserDefaults standardUserDefaults] stringForKey:@"webServiceGetFileList"];
    NSURL *url = [NSURL URLWithString:[webServicePath stringByAppendingFormat:webServiceGetFileList, twitterUsernameSelected]];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    id jsonDataSerialiced;
    if (jsonData) {
        NSError *error=nil;
        jsonDataSerialiced = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    }
    
    NSDictionary *response;
    if ([jsonDataSerialiced isKindOfClass:[NSDictionary class]]) {
        response = jsonDataSerialiced;
    }
    return response;
}

// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtain a list of users that have at least one file (video) uploaded:
//
// ["@manugodino","@alumno002"]
// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
+(NSArray *)getActiveFollowers
{
    NSDictionary *fileList = [self getDirectoryFileList];
    NSMutableArray *activeUsers = [[NSMutableArray alloc] init];
    
    for (id folder in fileList) {
        NSArray *files = [fileList objectForKey:folder];
        
        for (NSString *fileName in files) {
            NSString *filenameWithoutExtension = [[fileName componentsSeparatedByString:@"."] objectAtIndex:0];
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^@" options:0 error:NULL];
            if ([regex firstMatchInString:filenameWithoutExtension options:0 range:NSMakeRange(0, [filenameWithoutExtension length])]) {
                [activeUsers addObject:filenameWithoutExtension];
            }
        }
    }
    return [[NSSet setWithArray:activeUsers] allObjects];
}

// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtain a list of folders where the user selected as a parameter uploaded a file (video):
//
// ["Practica 1","Practica 2", "Practica 4"]
// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// TODO: check if there is PDF
+(NSArray *)getPracticesForFollower:(NSString *)follower
{
    NSDictionary *fileList = [self getDirectoryFileList];
    NSMutableArray *practices = [[NSMutableArray alloc] init];
    
    for (id folder in fileList) {
        NSArray *files = [fileList objectForKey:folder];
        
        for (NSString *fileName in files) {
            NSString *filenameWithoutExtension = [[fileName componentsSeparatedByString:@"."] objectAtIndex:0];
            if ([filenameWithoutExtension isEqualToString:follower]) {
                [practices addObject:folder];
                break;
            }
        }
    }
    
    NSArray *sortedPractices = [practices sortedArrayUsingSelector: @selector(localizedCaseInsensitiveCompare:)];
    return sortedPractices;
}

// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtain a list of all practice folders:
//
// ["Practica 1","Practica 2", "Practica 3", "Practica 4"]
// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
+(NSArray *)getPractices
{
    NSDictionary *fileList = [self getDirectoryFileList];
    
    NSArray *folders = [fileList allKeys];
    NSArray *sortedFolders = [folders sortedArrayUsingSelector: @selector(localizedCaseInsensitiveCompare:)];
    
    return sortedFolders;
}

// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Obtain a list of followers that upload at least a file (video) in the folder selected as a parameter:
//
// ["@manugodino","@alumno001", "@alumno003"]
// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
+(NSArray *)getFollowersForPractice:(NSString *)practice
{
    NSDictionary *fileList = [self getDirectoryFileList];
    NSMutableArray *followers = [[NSMutableArray alloc] init];
    
    NSArray *files = [fileList objectForKey:practice];
    
    for (NSString *fileName in files) {
        NSString *filenameWithoutExtension = [[fileName componentsSeparatedByString:@"."] objectAtIndex:0];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^@" options:0 error:NULL];
        if ([regex firstMatchInString:filenameWithoutExtension options:0 range:NSMakeRange(0, [filenameWithoutExtension length])]) {
            [followers addObject:filenameWithoutExtension];
        }
    }
    
    return followers;
}

// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Check if a follower has upload a video in the folder selected as a parameter:
// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
+(BOOL)doesVideoExistForFolder:(NSString *)folder andFollower:(NSString *)follower
{
    BOOL videoExist = NO;
    
    NSDictionary *fileList = [self getDirectoryFileList];
    NSArray *files = [fileList objectForKey:folder];
    for (NSString *fileName in files) {
        NSString *filenameWithoutExtension = [[fileName componentsSeparatedByString:@"."] objectAtIndex:0];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^@" options:0 error:NULL];
        if ([regex firstMatchInString:filenameWithoutExtension options:0 range:NSMakeRange(0, [filenameWithoutExtension length])]) {
            if ([filenameWithoutExtension isEqualToString:follower]) {
                videoExist = YES;
                break;
            }
        }
    }
    return videoExist;
}

+(id)getRateForPractice:(NSString *)practice andFollower:(NSString *)follower
{
    id response;
    
    NSString *webServicePath = [[NSUserDefaults standardUserDefaults] stringForKey:@"webServicePath"];
    NSString *webServiceGetRate = [[NSUserDefaults standardUserDefaults] stringForKey:@"webServiceGetRate"];
    NSURL *url = [NSURL URLWithString:[[webServicePath stringByAppendingFormat:webServiceGetRate, practice, follower] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (jsonData) {
        NSError *error = nil;
        response = [[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error] objectForKey:[[NSUserDefaults standardUserDefaults] stringForKey:@"webServiceJSONResponseKey"]];
    }
    
    return response;
}

+(NSString *)setRate:(NSString *)rate withComment:(NSString*)comment forPractice:(NSString *)practice andFollower:(NSString *)follower;
{
    NSString *response;
    
    NSString *webServicePath = [[NSUserDefaults standardUserDefaults] stringForKey:@"webServicePath"];
    NSString *webServiceSetRate = [[NSUserDefaults standardUserDefaults] stringForKey:@"webServiceSetRate"];
    NSURL *url = [NSURL URLWithString:[[webServicePath stringByAppendingFormat:webServiceSetRate, practice, follower, rate, comment] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (jsonData) {
        NSError *error = nil;
        response = [[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error] objectForKey:[[NSUserDefaults standardUserDefaults] stringForKey:@"webServiceJSONResponseKey"]];
    }
    return response;
}
@end