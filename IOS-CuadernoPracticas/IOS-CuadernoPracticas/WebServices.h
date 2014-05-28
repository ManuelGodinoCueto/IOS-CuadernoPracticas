//
//  WebServices.h
//  IOS-CuadernoPracticas
//
//  Created by Manuel Godino Cueto on 23/07/13.
//  Copyright (c) 2013 Manuel Godino Cueto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServices : NSObject

+(NSString *)getRolFromTwitterAccount:(NSString *)twitterAccount;
+(NSDictionary *)getDirectoryFileList;
+(NSArray *)getActiveFollowers;
+(NSArray *)getPracticesForFollower:(NSString *)follower;
+(NSArray *)getPractices;
+(NSArray *)getFollowersForPractice:(NSString *)practice;
+(BOOL)doesVideoExistForFolder:(NSString *)folder andFollower:(NSString *)follower;

+(NSString *)setRate:(NSString *)rate withComment:(NSString *)comment forPractice:(NSString *)practice andFollower:(NSString *)follower;
+(NSString *)getRateForPractice:(NSString *)practice andFollower:(NSString *)follower;

@end