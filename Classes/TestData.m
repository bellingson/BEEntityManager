//
//  TestData.m
//  BEEntityManager
//
//  Created by Ben Ellingson on 1/27/11.
//  Copyright 2011 Northstar New Media. All rights reserved.
//

#import "TestData.h"


@implementation TestData

@synthesize entityManager;

- (id) init
{
	self = [super init];
	if (self != nil) {
		self.entityManager = [[BEEntityManager alloc] init];
	}
	return self;
}



+ (void) makeSomeData {
	
	TestData *td = [[TestData alloc] init];
	
	[td makeBook:@"Moby Dick" withAuthor: @"Herman Melville"];
	[td makeBook:@"War and Peace" withAuthor: @"Leo Tolstoy"];
	[td makeBook:@"The Great Gatsby" withAuthor: @"F. Scott Fitzgerald"];
	[td makeBook:@"For Whom The Bell Tolls" withAuthor: @"Earnest Hemingway"];
	[td makeBook:@"On the Road" withAuthor: @"Jack Kerouac"];
	[td makeBook:@"Rabbit, Run" withAuthor: @"John Updike"];
	[td makeBook:@"Microserfs" withAuthor: @"Douglas Coupland"];
		
	[td.entityManager save];	
	
	[td release];
	
	
}

- (Book *) makeBook: (NSString *) title withAuthor: (NSString *) author {
	
	NSString *crit = [NSString stringWithFormat: @"title = '%@'",title];
	Book *book = [entityManager get: @"Book" criteria: crit];
	
	if(book != nil) return book;
	
	book = [entityManager create: @"Book" ];
	book.ID = [NSNumber numberWithInt: rand() * 1000];
	book.title = title;
	book.author = author;

	return book;	
}


@end
