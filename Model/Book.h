//
//  Book.h
//  BEEntityManager
//
//  Created by Ben Ellingson on 1/27/11.
//  Copyright 2011 http://benellingson.blogspot.com. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Book :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * ID;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * title;

@end



