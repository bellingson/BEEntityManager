//
//  TestData.h
//  BEEntityManager
//
//  Created by Ben Ellingson on 1/27/11.
//  Copyright 2011 Northstar New Media. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BEEntityManager.h"

#import "Book.h"

@interface TestData : NSObject {
	
}
@property (retain, nonatomic) BEEntityManager *entityManager;

+ (void) makeSomeData;

- (Book *) makeBook: (NSString *) title withAuthor: (NSString *) author;


@end
