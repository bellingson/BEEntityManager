//
//
//  Created by Ben Ellingson  - http://benellingson.blogspot.com/ on 10/10/2010
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

#define DEFAULT_SORT_FIELD @"ID"


@interface BEEntityManager : NSObject {

}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

+ (void) useDb: (NSString *) dbName;

- (id) get: (id) entity;
- (id) get: (NSString *) entityName ID: (NSNumber *) ID;
- (id) get: (NSString *) entityName criteria: (NSString *) crit;

- (NSArray*) query: (NSString *) entityName;
- (NSArray*) query: (NSString *) entityName criteria: (NSString *) crit sort: (NSString *) sort;
- (NSArray*) query: (NSString *) entityName criteria: (NSString *) crit sort: (NSString *) sort ascending: (BOOL) asc;
- (NSArray*) query: (NSString *) entityName predicate: (NSPredicate *) predicate sort: (NSString *) sort ascending: (BOOL) asc;

- (id) createOrUpdate: (NSString *) entityName ID: (NSNumber *) ID;
- (id) create: (NSString *) entityName;

- (BOOL) save;
- (void) saveContext;

- (void) delete: (NSManagedObject *) entity;
- (void) deleteItems: (NSArray *) entities;

@end


