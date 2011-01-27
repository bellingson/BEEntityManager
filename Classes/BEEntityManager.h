//
//
//  Created by Ben Ellingson  - http://benellingson.blogspot.com/ on 10/10/2010
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>



@interface BEEntityManager : NSObject {

    NSManagedObjectContext *managedObjectContext;	    
	NSString *defaultSortField;
	
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSString *defaultSortField;

+ (void)createPersistentStoreCoordinator: (NSString *) storeName;

- (id) get: (id) entity;
- (id) get: (NSString *) entityName intID: (int) ID;
- (id) get: (NSString *) entityName ID: (NSNumber *) ID;
- (id) get: (NSString *) entityName criteria: (NSString *) crit;

- (NSArray*) query: (NSString *) entityName criteria: (NSString *) crit sort: (NSString *) sort;
- (NSArray*) query: (NSString *) entityName criteria: (NSString *) crit sort: (NSString *) sort ascending: (BOOL) asc;
- (NSArray*) query: (NSString *) entityName predicate: (NSPredicate *) predicate sort: (NSString *) sort ascending: (BOOL) asc;

- (id) createOrUpdateEntity: (NSString *) entityName ID: (NSNumber *) ID;
- (id) createEntity: (NSString *) entityName;

- (BOOL) save;
- (void) delete: (NSManagedObject *) entity;
- (void) deleteItems: (NSArray *) entities;






@end


