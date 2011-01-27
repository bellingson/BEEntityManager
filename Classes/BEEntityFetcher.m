//
//  EntityFetcher.m
//  UberConf
//
//  Created by Ben Ellingson on 10/7/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//
/// EntityFetcher consolidates some of the cruft needed to use a FetchResultsController 
//

#import "BEEntityFetcher.h"


@implementation BEEntityFetcher

@synthesize managedObjectContext, fetchRequest, sortDescriptor, fetchResultsController;

- (id) initWith: (NSManagedObjectContext *) moc entityName: (NSString *) entityName sort: (NSString *) sortKey ascending: (BOOL) asc {
    
    if ((self = [super init])) {

        self.managedObjectContext = moc;
        
        self.fetchRequest = [[NSFetchRequest alloc] init];
        
        fetchRequest.entity = [NSEntityDescription entityForName: entityName inManagedObjectContext: managedObjectContext];
        
		self.sortDescriptor = [[NSSortDescriptor alloc] initWithKey: sortKey ascending: asc];
		[fetchRequest setSortDescriptors: [NSArray arrayWithObject:sortDescriptor]];
		
        self.fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                                                            managedObjectContext:managedObjectContext
                                                                            sectionNameKeyPath:nil
                                                                            cacheName:nil];
    }
    
   return self;                         
}

- (void)dealloc {
    [managedObjectContext release];
    [fetchRequest release];
    [sortDescriptor release];
    [fetchResultsController release];
    [super dealloc];
}


@end
