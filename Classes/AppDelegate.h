//
//  BEEntityManagerAppDelegate.h
//  BEEntityManager
//
//  Created by Ben Ellingson on 1/26/11.
//  Copyright 2011 Northstar New Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "BEEntityManager.h"

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;


}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) BEEntityManager *entityManager;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

@end

