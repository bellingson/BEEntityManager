//
//  EntityManagerContext.h
//  BEEntityManager
//
//  Created by Ben Ellingson on 1/27/11.
//  Copyright 2011 http://benellingson.blogspot.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface BEEntityManagerContext : NSObject {

}

@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (retain, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (NSManagedObjectContext *) managedObjectContext;
- (id) initWithDb: (NSString *) dbName;

- (void) useDb: (NSString *) storeName;

- (BOOL) replaceOldDb: (NSString *) storePath storeUrl: (NSURL *) storeUrl;

@end
