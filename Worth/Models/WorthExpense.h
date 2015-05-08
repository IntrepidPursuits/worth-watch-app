//
//  WorthExpense.h
//  Worth
//
//  Created by Patrick Butkiewicz on 5/8/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WorthUser;

@interface WorthExpense : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * cost;
@property (nonatomic, retain) NSNumber * payPeriod;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSSet *user;
@end

@interface WorthExpense (CoreDataGeneratedAccessors)

- (void)addUserObject:(WorthUser *)value;
- (void)removeUserObject:(WorthUser *)value;
- (void)addUser:(NSSet *)values;
- (void)removeUser:(NSSet *)values;

@end
