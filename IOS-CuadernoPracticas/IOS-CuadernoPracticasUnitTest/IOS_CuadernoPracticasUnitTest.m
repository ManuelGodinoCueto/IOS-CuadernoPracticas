//
//  IOS_CuadernoPracticasUnitTest.m
//  IOS-CuadernoPracticasUnitTest
//
//  Created by Manuel Godino Cueto on 14/09/13.
//  Copyright (c) 2013 Manuel Godino Cueto. All rights reserved.
//

#import "IOS_CuadernoPracticasUnitTest.h"
#import "WebServices.h"

@implementation IOS_CuadernoPracticasUnitTest

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

// getRolFromTwitterAccount
- (void)testgetRolFromTwitterAccountWithProfessor{
    NSString *rol = [WebServices getRolFromTwitterAccount:@"@UC3MTADSG42"];
    STAssertTrue([rol isEqualToString:@"Professor"], @"Professor JSON response not equal to \"Professor\"");
}

- (void)testgetRolFromTwitterAccountWithStudent
{
    NSString *rol = [WebServices getRolFromTwitterAccount:@"@alumno001"];
    STAssertTrue([rol isEqualToString:@"Student"], @"Student JSON response not equal to \"Student\"");
}

- (void)testgetRolFromTwitterAccountWithNoProfessorOrStudent
{
    NSString *rol = [WebServices getRolFromTwitterAccount:@"@xxxxxxxxx"];
    STAssertTrue([rol isEqualToString:@"You are not a professor or student."], @"Anonymous JSON response not equal to \"You are not a professor or student.\"");
}

// getDirectoryFileList

- (void)testgetDirectoryFileList
{
    NSDictionary *directory = [WebServices getDirectoryFileList];
    STAssertNotNil(directory, @"Directory nil");
}

// getActiveFollowers

- (void)testgetActiveFollowers
{
    NSArray *activeFollowers = [WebServices getActiveFollowers];
    STAssertNotNil(activeFollowers, @"Directory nil");
}

// getPracticesForFollower

- (void)testgetPracticesForFollower
{
    NSArray *practicesForFollower = [WebServices getPracticesForFollower:@"ª!\"·$%&/()"];
    STAssertTrue([practicesForFollower count] == 0, @"Practices for invalid Follower are not 0");
}

// getPractices

- (void)testgetPractices
{
    NSArray *practices = [WebServices getPractices];
    STAssertNotNil(practices, @"Practices not nil");
}

// getFollowersForPractice

- (void)testgetFollowersForPractice
{
    NSArray *followersForPractice = [WebServices getFollowersForPractice:@""];
    STAssertTrue([followersForPractice count] == 0, @"Practices for invalid practice name are not 0");
}

// doesVideoExistForFolder

- (void)testDoesVideoExistForFolder
{
    BOOL doesVideoExistForFolder = [WebServices doesVideoExistForFolder:@"" andFollower:@"ª!\"·$%&/()"];
    STAssertFalse(doesVideoExistForFolder, @"Video not exist for invalid practice name and invalid Follower");
}

// getRateForPractice

- (void)testgetRateForPractice
{
    id rateForPractice = [WebServices getRateForPractice:@"" andFollower:@"ª!\"·$%&/()"];
    STAssertTrue([rateForPractice isEqualToString:@"La práctica no ha sido calificada."], @"Practice not rated for invalid practice and invalid Follower");
}

@end