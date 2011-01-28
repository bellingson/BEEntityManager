//
//  BEEntityManagerTest.m
//
//  Created by Ben Ellingson on 7/20/10.
//  Copyright 2010 Ben Ellingson. All rights reserved.
//

#import "GTMSenTestCase.h"

#import "BEEntityManager.h"

#import "TestData.h"
#import "Book.h"

@interface BEEntityManagerTest : GTMTestCase {

}

@end

@implementation BEEntityManagerTest

- (void) setUp {

	// do once
	static NSObject *obj = nil;
	if (obj == nil) {
		obj = [[NSObject alloc] init];

		[BEEntityManager createPersistentStoreCoordinator: @"books_test.sqlite"];
		
		[TestData makeSomeData];
		
	}
	
}

#pragma mark -
#pragma mark test get methods

- (void) testGetWithCriteria {

	BEEntityManager *em = [[BEEntityManager alloc] init];
	
	NSString *crit = [NSString stringWithFormat:@"title = 'Moby Dick'"];
	Book *book = [em get: @"Book" criteria: crit];
	
	STAssertTrue(book != nil,@"book exists");
	[em release];
	
}

- (void) testGetWithID {
	
	TestData *data = [[TestData alloc] init];
	
	Book *book1 = [data makeBook:@"Blink" withAuthor:@"Malcom Gladwell"];
	
	[data release];
	
		
	STAssertTrue([book1 ID] != nil,@"book 1 created");
	
	BEEntityManager *em = [[BEEntityManager alloc] init];

	Book *book2 = [em get: @"Book" ID: book1.ID];
	
	STAssertTrue(book2 != nil,@"book exists");
	
	[em release];
	
}

- (void) testGet {
	
	TestData *data = [[TestData alloc] init];
	
	Book *book1 = [data makeBook:@"Blink" withAuthor:@"Malcom Gladwell"];
	
	[data release];
	
	
	STAssertTrue([book1 ID] != nil,@"book 1 created");
	
	BEEntityManager *em = [[BEEntityManager alloc] init];
	
	Book *book2 = [em get: book1];
	
	STAssertTrue(book2 != nil,@"book exists");
	
	[em release];
	
}

#pragma mark -
#pragma mark test query methods

- (void) testQuery {
	
	BEEntityManager *em = [[BEEntityManager alloc] init];
	
	// load all
	NSArray *books = [em query: @"Book"];
	
	STAssertTrue(books.count > 0,@"books loaded");	
	
	[em release];
	
}


- (void) testQueryWithCriteria {
	
	BEEntityManager *em = [[BEEntityManager alloc] init];
	
	// nil sort defaults to ID
	NSArray *books = [em query:@"Book" criteria:@"title = 'Moby Dick'" sort: nil];
	
	STAssertTrue(books.count == 1,@"book found");
	
	// add sort param
	books = [em query:@"Book" criteria:@"title = 'Moby Dick'" sort: @"title"];
	
	STAssertTrue(books.count == 1,@"book found again");
	
	[em release];
	
}

- (void) testQueryWithSortAscending {
	
	BEEntityManager *em = [[BEEntityManager alloc] init];
	
	// nil sort defaults to ID
	NSArray *books = [em query:@"Book" criteria:@"ID != null" sort: @"title" ascending: YES];
	
	STAssertTrue(books.count > 2,@"books fetched");
	
	Book *book1 = [books objectAtIndex: 0];
	
	Book *book2 = [books objectAtIndex: 1];
	
	Book *book3 = [books objectAtIndex: 3];
	
	NSComparisonResult *r1 = [book1.title compare: book2.title];
	
	STAssertTrue(r1 == NSOrderedAscending,@"ascending");
	
	NSComparisonResult *r2 = [book2.title compare: book3.title];	
	
	STAssertTrue(r2 == NSOrderedAscending,@"ascending");
	
	STAssertTrue(r2 != NSOrderedSame,@"not same");
	
		
	[em release];
	
}

- (void) testQueryWithSortDescending {
	
	BEEntityManager *em = [[BEEntityManager alloc] init];
	
	// nil sort defaults to ID
	NSArray *books = [em query:@"Book" criteria:@"ID != null" sort: @"title" ascending: NO];
	
	STAssertTrue(books.count > 2,@"books fetched");
	
	Book *book1 = [books objectAtIndex: 0];
	
	Book *book2 = [books objectAtIndex: 1];
	
	Book *book3 = [books objectAtIndex: 3];
	
	NSComparisonResult *r1 = [book1.title compare: book2.title];
	
	STAssertTrue(r1 == NSOrderedDescending,@"descending");
	
	NSComparisonResult *r2 = [book2.title compare: book3.title];	
	
	STAssertTrue(r2 == NSOrderedDescending,@"descending");
	
	STAssertTrue(r2 != NSOrderedSame,@"not same");
	
	[em release];
	
}

#pragma mark -
#pragma mark create methods

- (void) testCreateOrUpdate {
	
	BEEntityManager *em = [[BEEntityManager alloc] init];
	
	Book *book = [em get:@"Book" criteria: @"title = 'Moby Dick'"];
	
	STAssertTrue(book != nil,@"book exists");
	
	Book *book2 = [em createOrUpdate:@"Book" ID: book.ID];
	
	STAssertTrue([book2.title isEqualToString:@"Moby Dick"],@"book exists"); 
	
	NSNumber *r = [NSNumber numberWithInt:rand() * [NSDate timeIntervalSinceReferenceDate]];
	Book *book3 = [em createOrUpdate: @"Book" ID: r];
	STAssertTrue(book3 != nil,@"book created");
	
	STAssertTrue(book3.title == nil,@"title not initialized");
	[em delete: book3];
	[em save];
	
	[em release];
	
}

- (void) testCreate {
	
	
	BEEntityManager *em = [[BEEntityManager alloc] init];
	
	Book *book = [em create:@"Book"];
	
	STAssertTrue(book != nil,@"book created");
	STAssertTrue(book.title == nil,@"book has not title");
	
	[em delete:book];
	[em save];
	
	[em release];
	
}

#pragma mark -
#pragma mark test save methods

- (void) testSave {
	
	NSNumber *r = [NSNumber numberWithInt:rand() * [NSDate timeIntervalSinceReferenceDate]];
	
	BEEntityManager *em1 = [[BEEntityManager alloc] init];
	
	Book *book1 = [em1 get: @"Book" ID: r];
	STAssertTrue(book1 == nil,@"book is nil");
	
	book1 = [em1 create: @"Book"];
	book1.ID = r;
	[em1 save];
	
	[em1 release];
	
	BEEntityManager *em2 = [[BEEntityManager alloc] init];
	Book *book2 = [em2 get: @"Book" ID: r];
	
	STAssertTrue(book2 != nil,@"book exists");
	
	[em2 delete: book2];
	
	[em2 release];
	
}



#pragma mark -
#pragma mark test delete methods



- (void) testDelete {

	TestData *data = [[TestData alloc] init];
	Book *book = [data makeBook:@"Grapes of Wrath" withAuthor: @"John Steinbeck"];
	book.ID = [NSNumber numberWithInt: rand() * [NSDate timeIntervalSinceReferenceDate]];
	[data.entityManager save];
	[data release];
	
	BEEntityManager *em = [[BEEntityManager alloc] init];
	
	Book *book2 = [em get: book];
	
	STAssertTrue(book2 != nil,@"book found");
	
	[em delete: book2];
	
	[em saveContext];
	 
	[em release];
	 
	 BEEntityManager *em2 = [[BEEntityManager alloc] init];
	Book *book3 = [em2 get: @"Book" ID: book.ID];
	 
	 STAssertTrue(book3 == nil,@"book does not exist");
	 
	[em2 release];
	 
}

- (void) testDeleteCollection {
	
	TestData *data = [[TestData alloc] init];
	
	NSArray *items = [NSArray arrayWithObjects: 
					  [data makeBook:@"Of Mice and Men" withAuthor: @"John Steinbeck"],
					  [data makeBook:@"Anatomy of a Murder" withAuthor: @"Robert Traver"], nil];
					  
	BEEntityManager *em = data.entityManager;
	[em save];
	
	Book *book1 = [em get:@"Book" criteria: @"title = 'Anatomy of a Murder'"];
	
	STAssertTrue(book1 != nil,@"book exist");
	
	[em deleteItems: items];
	[em save];
	
	book1 = [em get:@"Book" criteria: @"title = 'Anatomy of a Murder'"];
		
	STAssertTrue(book1 == nil,@"book1 deleted");
	
	Book *book2 = [em get:@"Book" criteria: @"title = 'Of Mice and Men'"];
	
	STAssertTrue(book2 == nil,@"book2 deleted");
	
	[data release];	
	
	
}




@end
