//
//  Created by Ben Ellingson  - http://benellingson.blogspot.com/ on 3/23/10.
//

#import "BEEntityManager.h"
#import "BEEntityFetcher.h"


@implementation BEEntityManager

@synthesize managedObjectContext;

static NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (id) init
{
	self = [super init];
	if (self != nil) {
		NSManagedObjectContext *context = [self managedObjectContext];		
		self.managedObjectContext = context;
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
    
    BEEntityFetcher *entityFetcher = [[BEEntityFetcher alloc] initWith: managedObjectContext entityName: entityName sort:sort ascending:asc ];
	
	if (predicate != nil) {
		[entityFetcher.fetchRequest setPredicate:predicate];
	}
		
	NSError *error = nil;
	if(![entityFetcher.fetchResultsController performFetch:&error]) {
		NSLog(@"error: %@",[error userInfo]);
	}
	
	NSArray *entities = [entityFetcher.fetchResultsController fetchedObjects];
    
    [entityFetcher release];
	
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
	NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
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
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
	if (persistentStoreCoordinator == nil) {
		NSLog(@"persistence store not initialized");
		return nil;
	}
	
	self.managedObjectContext = [[NSManagedObjectContext alloc] init];
	managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;

    return managedObjectContext;
}


+ (void)createPersistentStoreCoordinator: (NSString *) storeName {
	
	NSString *storePath = [DOCUMENTS_FOLDER stringByAppendingPathComponent: storeName];
    NSURL *storeUrl = [NSURL fileURLWithPath: storePath];
	
	NSError *error = nil;	
	
	NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    

    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
	[managedObjectModel release];
	
	NSPersistentStore *store = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error];

	
    if (!store) {
		
		NSLog(@"error code: %d",error.code);
		
		// incompatible dbs... just replace it
		if (error.code == 134100) {
			if([self replaceOldDb: storePath storeUrl: storeUrl psc: persistentStoreCoordinator]) {
				return;
			}
		}
		
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
		
	}    
}

+ (BOOL) replaceOldDb: (NSString *) storePath storeUrl: (NSURL *) storeUrl psc: (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
	
	NSLog(@"replacing old data store");
	
	NSFileManager *nfm = [NSFileManager defaultManager];
	if ([nfm fileExistsAtPath: storePath]) {
		NSError *error2 = nil;
		[nfm removeItemAtPath:storePath error:&error2];
		if (error2 != nil) {
			NSLog(@"could not remove old data store: %@",[error2 userInfo]);
		} else {
			// try to recover
			NSError *error = nil;
			[persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error];
			if (error == nil) {
				return YES;
			}
		}
		
	}
	return NO;
	
}




#pragma mark -
#pragma mark dealloc

- (void) dealloc
{
	[managedObjectContext release];
	[super dealloc];
}


@end


