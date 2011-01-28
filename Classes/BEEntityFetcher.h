//
//  EntityFetcher.h
//  UberConf
//
//  Created by Ben Ellingson on 10/7/10.
//  Copyright (c) 2010 Northstar New Media. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

@interface BEEntityFetcher : NSObject {

    NSManagedObjectContext *managedObjectContext;
    
    NSFetchRequest *fetchRequest;
    NSSortDescriptor *sortDescriptor;
    NSFetchedResultsController *fetchResultsController;
    
}

@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (retain, nonatomic) NSFetchRequest *fetchRequest;
@property (retain, nonatomic) NSSortDescriptor *sortDescriptor;
@property (retain, nonatomic) NSFetchedResultsController *fetchResultsController;

- (id) initWith: (NSManagedObjectContext *) moc entityName: (NSString *) entityName sort: (NSString *) sort ascending: (BOOL) asc;

@end
