//
//  EntityManagerContext.m
//  BEEntityManager
//
//  Created by Ben Ellingson on 1/27/11.
//  Copyright 2011 http://benellingson.blogspot.com. All rights reserved.
//

#import "BEEntityManagerContext.h"


@implementation BEEntityManagerContext

@synthesize persistentStoreCoordinator, managedObjectContext;

- (id) initWithDb: (NSString *) dbName 
{
	self = [super init];
	if (self != nil) {
		[self useDb: dbName];
		self.managedObjectContext = [[NSManagedObjectContext alloc] init];
		[managedObjectContext setPersistentStoreCoordinator: persistentStoreCoordinator];
	}
	return self;
}

- (void) useDb: (NSString *) storeName {
	
	NSString *storePath = [DOCUMENTS_FOLDER stringByAppendingPathComponent: storeName];
    NSURL *storeUrl = [NSURL fileURLWithPath: storePath];
	
	NSError *error = nil;	
	
	NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
	
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
	[managedObjectModel release];
	
	NSPersistentStore *store = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error];
	
	
    if (!store) {
		
		NSLog(@"error code: %d",error.code);
		
		// incompatible dbs... just replace it
		if (error.code == 134100) {
			if([self replaceOldDb: storePath storeUrl: storeUrl ]) {
				return;
			}
		}
		
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
		
	}    
}

- (BOOL) replaceOldDb: (NSString *) storePath storeUrl: (NSURL *) storeUrl {
	
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



@end
