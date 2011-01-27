//
//  BEEntityManagerTest.m
//
//  Created by Ben Ellingson on 7/20/10.
//  Copyright 2010 Ben Ellingson. All rights reserved.
//

#import "BaseUnitTest.h"

#import "BEEntityManager.h"

#import "Show.h"

#import "ShowDataHelper.h"

@interface BEEntityManagerTest : BaseUnitTest {

}

@end

@implementation BEEntityManagerTest


- (void) testGet {

	EntityManager *em = [[EntityManager alloc] init];
	
	Show *show = [em get:@"Show" ID:SHOW_ID];
	
	STAssertTrue(show != nil,@"show not nil");
	
	[em release];
	
}

- (void) testDelete {

	EntityManager *em = [[EntityManager alloc] init];
	
	NSString *ID = @"999999";
	
	Show *s1 = [em createOrUpdateEntity:@"Show" ID:ID];
	s1.name = @"Greater Metro Test Symposium";
	
	[em save];
	
	Show *s2 = [em get:@"Show" ID:ID];
	
	STAssertTrue(s2 != nil,"show is not nil");

	[em delete:s2];
	
	s2 = [em get:@"Show" ID:ID];
	
	STAssertTrue(s2 == nil,@"show is nil");

	[em release];
}



@end
