//
//  Created by Ben Ellingson  - http://benellingson.blogspot.com/ on 3/23/10.
//

#import "BEEntityManager.h"


#import "BEEntityManagerContext.h"

#pragma mark -
#pragma mark EntityManager

@implementation BEEntityManager

@synthesize managedObjectContext;

static BEEntityManagerContext *context;

#pragma mark -
#pragma mark initialize db

+ (void) useDb: (NSString *) dbName {
	
	context = [[BEEntityManagerContext alloc] initWithDb: dbName];
	
}


#pragma mark -
#pragma mark instance init

- (id) init
{
	self = [super init];
	if (self != nil) {
		self.managedObjectContext = [context managedObjectContext];		
	}
	return self;
}

- (id) initWithNewManagedObjectContext 
{
	self = [super init];
	if (self != nil) {		
		self.managedObjectContext = [[NSManagedObjectContext alloc] init];
        managedObjectContext.persistentStoreCoordinator = [context persistentStoreCoordinator];
	}
	return self;
}


#pragma mark -
#pragma mark query

- (NSArray*) query: (NSString *) entityName {
	return [self query: entityName criteria: nil sort: nil ascending: YES];
}

- (NSArray*) query: (NSString *) entityName criteria: (NSString *) crit sort: (NSString *) sort  {
	return [self query: entityName criteria:crit sort:sort ascending: YES];
}

- (NSArray*) query: (NSString *) entityName criteria: (NSString *) crit sort: (NSString *) sort ascending: (BOOL) asc {
	
	NSPredicate *pred = nil;
	if (crit != nil) {
		pred = [NSPredicate predicateWithFormat: crit];
	}
	return [self query: entityName predicate: pred sort: sort ascending: asc];
}

- (NSArray*) query: (NSString *) entityName predicate: (NSPredicate *) predicate sort: (NSString *) sort ascending: (BOOL) asc {
	

	if (sort == nil) {
		sort = DEFAULT_SORT_FIELD;
	}
    
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	
	fetchRequest.entity = [NSEntityDescription entityForName: entityName inManagedObjectContext: managedObjectContext];
	
	NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey: sort ascending: asc] autorelease];
	[fetchRequest setSortDescriptors: [NSArray arrayWithObject: sortDescriptor]];
	
	NSFetchedResultsController *fetchResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																	  managedObjectContext:managedObjectContext
																		sectionNameKeyPath:nil
																				 cacheName:nil] autorelease];
	
	
	if (predicate != nil) {
		[fetchRequest setPredicate:predicate];
	}
		
	NSError *error = nil;
	if(![fetchResultsController performFetch:&error]) {
		NSLog(@"error: %@",[error userInfo]);
	}
	
	NSArray *entities = [fetchResultsController fetchedObjects];
    
	return entities;
}

#pragma mark -
#pragma mark get


- (id) get: (NSString *) entityName criteria: (NSString *) crit {
	
	NSArray *entities = [self query: entityName criteria: crit sort: nil];

	NSUInteger cnt = [entities count];
	
	if(cnt <= 0) {
		return nil;
	}	 
	
	id r = [entities objectAtIndex:0];

	
	return r;	
	
}

- (id) get: (NSString *) entityName ID: (NSNumber *) ID {
	
	NSString *criteria = [NSString stringWithFormat:@"ID = %@",ID];
	
	NSArray *entities = [self query: entityName criteria: criteria sort: nil];
  
	NSUInteger cnt = [entities count];
	
	if(cnt <= 0) {
		//NSLog(@"nothing found: %@ : %@",entityName,ID);
		return nil;
	}	 
	
	id r = [entities objectAtIndex:0];
	
	return r;	
}

- (id) get: (id) entity {
	
	if (entity == nil) {
		return nil;
	}
	
	return [self.managedObjectContext objectWithID: [entity objectID]];
}


#pragma mark -
#pragma mark create

- (id) create: (NSString *) entityName {
	
    NSEntityDescription *entity = [NSEntityDescription entityForName: entityName inManagedObjectContext: managedObjectContext];
    
	return [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext: managedObjectContext];
}


- (id) createOrUpdate: (NSString *) entityName ID: (NSNumber *) ID {
	
	id entity = [self get:entityName ID:ID];
	
	if(entity == nil) {
		entity = [self create:entityName];
		[entity setID: ID];
	}
	return entity;	
}

#pragma mark -
#pragma mark save

- (BOOL) save {
	
	NSError *error = nil;
	if(![managedObjectContext save: &error]) {
		NSLog(@"save error: %@",[error localizedDescription]);
        return NO;
	}
    return YES;
}

- (void)saveContext {
    
    NSError *error = nil;

	if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	} 
}    

#pragma mark -
#pragma mark delete

- (void) delete: (NSManagedObject *) entity {
	if (entity == nil) return;
	
	if (entity.managedObjectContext != managedObjectContext) {
		entity = [self get: entity];
	}

	[managedObjectContext deleteObject: entity];
	NSError *error = nil;
	[managedObjectContext save:&error];
	if (error != nil) {
		NSLog(@"ERROR: %@",[error userInfo]);
	}
}

- (void) deleteItems: (NSArray *) entities {
	
	if (entities == nil || [entities count] == 0) {
		return;
	}

	for (id item in entities) {
		[managedObjectContext deleteObject: item];
	}
	NSError *error = nil;
	[managedObjectContext save:&error];
	if (error != nil) {
		NSLog(@"ERROR: %@",[error userInfo]);
	}
}


#pragma mark -
#pragma mark dealloc

- (void) dealloc
{
	[managedObjectContext release];
	[super dealloc];
}


@end


