//
//  CoreDataScratchTest.m
//  BEEntityManager
//
//  Created by Ben Ellingson on 1/28/11.
//  Copyright 2011 http://benellingson.blogspot.com. All rights reserved.
//

#import "GTMSenTestCase.h"

#import "BEEntityManager.h"
#import "TestData.h"

@interface CoreDataScratchTest : GTMTestCase
{
	
}

@end


@implementation CoreDataScratchTest

- (void) setUp {
		
	[BEEntityManager useDb:@"test.sqlite"];
	
	[TestData makeSomeData];
	
}

- (NSManagedObjectContext *) managedObjectContext {
	
	BEEntityManager *em = [[BEEntityManager alloc] init];	
	NSManagedObjectContext *managedObjectContext = em.managedObjectContext;
	[em release];
	
	return managedObjectContext;
}


- (void) testCoreDataQuery {
	
	NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
	
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	
	fetchRequest.entity = [NSEntityDescription entityForName: @"Book" 
				inManagedObjectContext: managedObjectContext];


	NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] 
											initWithKey: @"title"  ascending: YES] autorelease];
	[fetchRequest setSortDescriptors: [NSArray arrayWithObject: sortDescriptor]];

	 
	 
	NSFetchedResultsController *fetchResultsController = 
		[[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
								  managedObjectContext:managedObjectContext
									sectionNameKeyPath:nil
											 cacheName:nil] autorelease];
	
	
	NSError *error = nil;
	if(![fetchResultsController performFetch:&error]) {
		NSLog(@"FETCH ERROR: %@",[error userInfo]);
	}
	
	NSArray *entities = [fetchResultsController fetchedObjects];
	
	NSLog(@"found %d books",entities.count);
	
}

- (void) testBEEntityManagerQuery {
	
	BEEntityManager *entityManager = [[[BEEntityManager alloc] init] autorelease];
	
	NSArray *books = [entityManager query: @"Book" criteria: @"author = 'F. Scott Fitzgerald'" sort: @"title" ascending: YES ];
	
	NSLog(@"found %d books",books.count);
	
	
}





@end
